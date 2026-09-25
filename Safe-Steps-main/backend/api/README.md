# Safe Steps Entra ID host-sync proxy

This small Node service keeps Microsoft Entra credentials out of the Flutter client. The Flutter app reads hosts from `GET /api/hosts`; the proxy reads the live user directory through Microsoft Graph.

## Iteration 1 demo mode

```bash
cd backend/entra_proxy
cp .env.example .env
npm install
npm start
```

Leave `DEMO_ENTRA=true` for a self-contained prototype. Then run Flutter with:

```bash
flutter run -d chrome --dart-define=ENTRA_SYNC_URL=http://localhost:7071/api/hosts
```

## Live Entra ID mode

1. Your organisation first synchronises any required on-premises Active Directory identities to Microsoft Entra ID using its approved Microsoft identity-sync configuration.
2. Create an Entra app registration for this backend, not for embedding a secret in Flutter.
3. Grant only the Microsoft Graph application permission required to read the host directory (commonly `User.Read.All`) and obtain tenant administrator consent as required by your organisation.
4. Copy `.env.example` to `.env`, set `DEMO_ENTRA=false`, and fill `TENANT_ID`, `CLIENT_ID`, and `CLIENT_SECRET` locally.
5. Start this proxy and pass its URL to Flutter through `ENTRA_SYNC_URL`.

Do not commit `.env`, tenant secrets, tokens, or production visitor information to GitHub.
