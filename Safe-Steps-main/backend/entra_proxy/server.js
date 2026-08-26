import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { ClientSecretCredential } from '@azure/identity';

const app = express();
app.use(cors());
app.use(express.json());

const port = Number(process.env.PORT || 7071);
const demoMode = String(process.env.DEMO_ENTRA || 'true').toLowerCase() === 'true';

const demoHosts = [
  { id: 'u-1001', displayName: 'John Smith', mail: 'john.smith@safesteps.demo', jobTitle: 'Counsellor', accountEnabled: true },
  { id: 'u-1002', displayName: 'Kate Spade', mail: 'kate.spade@safesteps.demo', jobTitle: 'Team Lead', accountEnabled: true },
  { id: 'u-1003', displayName: 'Ben Sawyer', mail: 'ben.sawyer@safesteps.demo', jobTitle: 'Case Worker', accountEnabled: true },
  { id: 'u-1004', displayName: 'Barbara Palvin', mail: 'barbara.palvin@safesteps.demo', jobTitle: 'Coordinator', accountEnabled: true },
  { id: 'u-1005', displayName: 'Natasha Ford', mail: 'natasha.ford@safesteps.demo', jobTitle: 'Practitioner', accountEnabled: true }
];

function requireEnv(name) {
  const value = process.env[name];
  if (!value) throw new Error(`${name} is required when DEMO_ENTRA=false`);
  return value;
}

async function graphHosts() {
  const credential = new ClientSecretCredential(
    requireEnv('TENANT_ID'),
    requireEnv('CLIENT_ID'),
    requireEnv('CLIENT_SECRET')
  );
  const token = await credential.getToken('https://graph.microsoft.com/.default');
  if (!token?.token) throw new Error('Could not obtain Microsoft Graph token');

  const select = 'id,displayName,mail,userPrincipalName,jobTitle,accountEnabled';
  const url = `https://graph.microsoft.com/v1.0/users?$select=${encodeURIComponent(select)}&$top=100`;
  const response = await fetch(url, {
    headers: {
      Authorization: `Bearer ${token.token}`,
      Accept: 'application/json'
    }
  });
  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Microsoft Graph returned ${response.status}: ${body.slice(0, 400)}`);
  }
  const body = await response.json();
  const users = Array.isArray(body.value) ? body.value : [];

  return users
    .filter((u) => u.accountEnabled !== false)
    .map((u) => ({
      id: u.id,
      displayName: u.displayName,
      mail: u.mail || u.userPrincipalName || '',
      jobTitle: u.jobTitle || 'Host',
      accountEnabled: u.accountEnabled !== false
    }));
}

app.get('/health', (_req, res) => {
  res.json({ ok: true, service: 'safe-steps-entra-proxy', demoMode });
});

app.get('/api/hosts', async (_req, res) => {
  try {
    const hosts = demoMode ? demoHosts : await graphHosts();
    res.set('Cache-Control', 'no-store');
    res.json({
      source: demoMode ? 'demo' : 'microsoft-entra-id',
      syncedAt: new Date().toISOString(),
      hosts
    });
  } catch (error) {
    console.error(error);
    res.status(502).json({ error: error instanceof Error ? error.message : 'Host sync failed' });
  }
});

app.listen(port, () => {
  console.log(`Safe Steps Entra proxy running on http://localhost:${port}`);
  console.log(`Mode: ${demoMode ? 'DEMO (no tenant credentials required)' : 'LIVE MICROSOFT ENTRA ID'}`);
});
