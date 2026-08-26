# Safe Steps — Figma to Flutter (Iteration 1)

A VS Code-ready Flutter prototype based on the supplied Safe Steps Figma screens and client feedback for **Assessment 1 – Iteration 1 Development and Progress Demonstration**.

## Implemented feedback

- **Host Management added to the admin navigation.** Hosts are supplied by an Entra ID service layer rather than being maintained in a second host database.
- **Microsoft Entra ID integration path included.** `backend/entra_proxy` securely reads users from Microsoft Graph. The Flutter app never stores an Entra client secret.
- **Checkout password removed.** Checkout now asks for the visitor email address only.
- **Employee In/Out removed.** The visitor register has no staff check-in/out workflow.
- The original Figma flow is retained: kiosk welcome, individual/group check-in, host selection, returning-user login, admin login, terms, checkout confirmation, visitor activity view, admin dashboard, notifications/messages, location switching and manual admin entry.

## Quick start in VS Code

### Requirements

- Flutter SDK on PATH
- VS Code with the Flutter and Dart extensions
- Chrome for the easiest Iteration 1 demonstration

### Run immediately (self-contained Entra demo mirror)

```bash
flutter pub get
flutter run -d chrome
```

The app will use the built-in Entra demo mirror so the host-selection and Host Management screens work without tenant credentials.

### Run with the included Entra proxy

Terminal 1:

```bash
cd backend/entra_proxy
cp .env.example .env
npm install
npm start
```

Terminal 2, from the project root:

```bash
flutter pub get
flutter run -d chrome --dart-define=ENTRA_SYNC_URL=http://localhost:7071/api/hosts
```

The VS Code launch configuration **Safe Steps (Chrome)** already includes that URL.

## Live Microsoft Entra ID

The Flutter application should not directly hold an Entra client secret. For a live tenant, configure `backend/entra_proxy/.env` with an approved Entra app registration and set `DEMO_ENTRA=false`. The backend uses Microsoft Graph to read enabled users and returns them as hosts.

If the organisation still has on-premises Active Directory, its identities must first be synchronised into Microsoft Entra ID using the organisation's approved Microsoft identity-sync configuration. That tenant-level configuration is outside Flutter itself. Once identities are present in Entra ID, Safe Steps reads them from the single source of truth through the proxy.

## Prototype credentials

- Returning-user demo password: `demo123`
- Admin Number: `admin`
- Admin password: `admin123`

These are Iteration 1 demonstration credentials only and must not be used in production.

## Project structure

```text
lib/
  main.dart
  core/                 theme
  models/               host, visitor, check-in draft
  services/             Entra host service + visitor persistence
  state/                app state
  screens/              Figma-derived screens
  widgets/              shared shell, logo and cards
backend/entra_proxy/     secure Microsoft Graph/Entra bridge
docs/                    Iteration 1 assessment/demo notes
web/                     Flutter web launcher
.vscode/                 VS Code launch configurations
```

