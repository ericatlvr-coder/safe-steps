# Safe Steps Backend API

This directory contains the Node.js and Express backend API for the Safe Steps visitor management system.

The backend is hosted on Railway and connects to a Railway PostgreSQL database.

## Architecture

```text
Flutter Frontend
       |
       v
Node.js / Express API
       |
       v
PostgreSQL Database
```

The Flutter application does not connect directly to PostgreSQL. All visitor database operations are handled by this API.

## Main Files

```text
backend/api/
  database.js
  package.json
  package-lock.json
  schema.sql
  server.js
  .env.example
  .gitignore
  README.md
```

### database.js

Creates and manages the PostgreSQL connection used by the backend.

### schema.sql

Creates the visitor table and required database indexes.

### server.js

Runs the Express API and handles visitor requests.

### package.json

Contains the Node.js dependencies and start command.

## Visitor API

The backend provides visitor endpoints including:

```text
GET  /api/visitors
POST /api/visitors
PUT  /api/visitors/:id/complete
POST /api/visitors/checkout
```

### GET /api/visitors

Returns visitor records stored in PostgreSQL.

### POST /api/visitors

Creates a new visitor record.

### PUT /api/visitors/:id/complete

Changes an Active visitor to Complete.

A completed visitor cannot be changed back to Active.

### POST /api/visitors/checkout

Checks out an active visitor using their email address.

## Visitor Status

Safe Steps currently uses two visitor statuses:

```text
Active
Complete
```

The database enforces these allowed values.

The intended status flow is:

```text
Active
   |
   v
Complete
```

`Complete` is treated as a final status.

## Railway Deployment

The production backend is deployed using Railway.

The Railway service Root Directory is:

```text
/Safe-Steps-main/backend/api
```

Railway runs the backend using:

```bash
npm start
```

The production backend communicates with the PostgreSQL service through the `DATABASE_URL` environment variable configured in Railway.

## Local Development

The production Flutter application normally uses the deployed Railway backend, so running this backend locally is not required for normal frontend development.

If backend development or testing is required, first move into this directory:

```bash
cd backend/api
```

Install dependencies:

```bash
npm install
```

Create a local `.env` file based on `.env.example`.

The environment requires a PostgreSQL connection string:

```text
DATABASE_URL=
```

Then start the backend:

```bash
npm start
```

On Windows PowerShell, if execution policy prevents `npm` from running, use:

```powershell
npm.cmd install
npm.cmd start
```

## PostgreSQL

Visitor information is stored in PostgreSQL.

The visitor table contains fields for:

- ID
- Name
- Email
- Visitor type
- Purpose
- Location
- Host name
- Contact number
- Check-in time
- Check-out time
- Status

The database schema is defined in:

```text
schema.sql
```

## Security

Do not commit the following to GitHub:

```text
.env
node_modules/
database passwords
DATABASE_URL credentials
other secrets
```

The production PostgreSQL connection string is stored as a Railway environment variable rather than inside the source code.

## Production Data Flow

When the Flutter application creates or loads a visitor:

```text
Flutter
   |
   | HTTPS request
   v
Railway Safe Steps API
   |
   | SQL query
   v
Railway PostgreSQL
```

This allows multiple Safe Steps devices to use the same central visitor database.