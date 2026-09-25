# Safe Steps — Visitor Management System

Safe Steps is a Flutter-based visitor management application designed for visitor check-in, checkout, host selection, visitor monitoring, and administration.

The current system uses a Flutter frontend connected to a Node.js/Express API hosted on Railway. Visitor information is stored centrally in a Railway PostgreSQL database.

## Current Architecture

```text
Flutter Web Application
        |
        v
Railway Node.js / Express API
        |
        v
Railway PostgreSQL Database
```

The Flutter application does not connect directly to PostgreSQL. All visitor database operations are handled securely through the backend API.

## Main Features

- Individual visitor check-in
- Group visitor check-in
- Host selection
- Host Management
- Visitor checkout using email
- Admin login
- Admin Dashboard
- Visitor activity monitoring
- Manual visitor entry
- Visitor status management
- Active and Complete visitor statuses
- Completed visitors are locked from further status changes
- Location selection
- Notifications/messages
- Central PostgreSQL visitor storage
- Shared visitor data between devices

## Host Management

Hosts are currently configured locally within the Safe Steps Flutter application.

The current host list includes demonstration hosts used by the prototype.

Host information is provided through the `HostService` service layer and is used by:

- Host Selection
- Host Management
- Manual Visitor Entry

No separate host database is currently required.

## Visitor Database

Visitor information is stored in PostgreSQL hosted on Railway.

The database stores information including:

- Visitor ID
- Name
- Email
- Visitor type
- Purpose of visit
- Location
- Host name
- Contact number
- Check-in time
- Check-out time
- Visitor status

Visitor statuses are:

```text
Active
Complete
```

Once a visitor has been marked as `Complete`, the status cannot be changed back to `Active`.

## Backend API

The Safe Steps backend is a Node.js and Express application hosted on Railway.

The backend communicates with PostgreSQL and provides API endpoints used by the Flutter application.

Main visitor endpoints include:

```text
GET  /api/visitors
POST /api/visitors
PUT  /api/visitors/:id/complete
POST /api/visitors/checkout
```

The production backend is hosted on Railway.

## Quick Start

### Requirements

Install:

- Flutter SDK
- VS Code
- Flutter extension for VS Code
- Dart extension for VS Code
- Chrome

The production visitor API is already hosted on Railway, so you do not need to run the Node.js backend locally just to run the Flutter application.

### Run the Flutter Application

From the Flutter project directory:

```bash
flutter pub get
flutter run -d chrome
```

The application will connect to the deployed Railway API.

## Run on Another Computer

Clone or download the project.

Open the Flutter project directory in VS Code and run:

```bash
flutter pub get
flutter run -d chrome
```

The computer does not need:

- PostgreSQL installed locally
- Railway database credentials
- A local Node.js server
- A local database

The application connects to the same Railway backend and PostgreSQL database, so visitor records are shared between devices.

## Testing

Run Flutter static analysis:

```bash
flutter analyze
```

Run automated tests:

```bash
flutter test
```

Run the application:

```bash
flutter run -d chrome
```

## Prototype Credentials

Returning-user demo password:

```text
demo123
```

Admin Number:

```text
admin
```

Admin password:

```text
admin123
```

These credentials are for the prototype/demo only and should not be used for a production authentication system.

## Project Structure

```text
lib/
  main.dart

  core/
    Application theme

  models/
    Host
    Visitor
    Check-in draft

  services/
    host_service.dart
    visitor_repository.dart

  state/
    safe_steps_store.dart

  screens/
    Application screens

  widgets/
    Shared UI components

backend/
  api/
    database.js
    package.json
    schema.sql
    server.js

docs/
  Assessment and project documentation

test/
  Flutter tests

web/
  Flutter web files
```

## Technology Stack

### Frontend

- Flutter
- Dart
- Flutter Web

### Backend

- Node.js
- Express

### Database

- PostgreSQL

### Hosting

- Railway — backend API
- Railway — PostgreSQL database
- GitHub — source code
- GitHub Pages — Flutter web frontend

## Data Flow

When a visitor checks in:

```text
Visitor
   |
   v
Flutter Application
   |
   v
Safe Steps Railway API
   |
   v
PostgreSQL
```

When the Admin Dashboard loads visitor information:

```text
PostgreSQL
   |
   v
Railway API
   |
   v
Flutter Application
   |
   v
Admin Dashboard
```

This allows multiple devices to access the same visitor information.

## Deployment

The backend and PostgreSQL database are deployed on Railway.

The Flutter web frontend can be built using:

```bash
flutter build web --release
```

The generated production web application is located in:

```text
build/web/
```

The Flutter web frontend is intended to be deployed using GitHub Pages.

## Security Notes

Sensitive database credentials must not be stored inside the Flutter application or committed to GitHub.

The PostgreSQL connection string is stored as a Railway environment variable and is used only by the backend.

The local `.env` file and `node_modules` directory should not be committed to Git.

## Current Project Status

The following components are operational:

- Flutter frontend
- Host selection
- Host Management
- Visitor check-in
- Visitor checkout
- Manual visitor entry
- Admin Dashboard
- Active/Complete status management
- Railway Node.js/Express API
- Railway PostgreSQL database
- Persistent visitor records
- Shared visitor data across devices

The next deployment stage is publishing the Flutter web frontend using GitHub Pages.