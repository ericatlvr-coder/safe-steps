# Assessment 1 — Iteration 1 Development and Progress Demonstration

The supplied assessment instruction says the Iteration 1 submission/demonstration includes:

1. a technical report;
2. demonstration of a working prototype;
3. evidence of project management using Jira; and
4. evidence of version control using GitHub.

## What this ZIP gives you

- A working Figma-to-Flutter prototype with connected screens and real state changes.
- Local visitor persistence for repeatable demonstration.
- A Host Management area added after client feedback.
- A secure Entra integration boundary plus a runnable proxy and demo mode.
- Validation and error feedback in check-in, checkout and login flows.
- A clear trace between the supplied feedback and the implemented iteration.

## Recommended 5–8 minute prototype demonstration

- **Opening:** state that the iteration converts the agreed Figma design into a functional Flutter prototype.
- **Check-in:** show individual/group pathways, validation and host selection.
- **Client feedback item 1:** open Host Management and explain that host data is read from Entra ID as the source of truth, avoiding a second host database.
- **Client feedback item 2:** demonstrate checkout and show that the password requirement has been removed.
- **Client feedback item 3:** show the welcome screen and point out that Employee In/Out is no longer part of the visitor register.
- **Admin:** show the dashboard, visit statuses, metrics, manual entry and notifications.
- **Technical:** briefly show `services/entra_host_service.dart`, `state/safe_steps_store.dart` and `backend/entra_proxy/server.js` in VS Code.
- **Limitations:** state that production visitor persistence, identity/security hardening and organisational Entra tenant configuration remain later-iteration work.

## Technical report points to cover

Use your unit's pinned brief/template for the exact headings and word limits. The content should normally document:

- Iteration 1 objective and agreed scope.
- Figma screens implemented.
- Flutter/Dart architecture and key components.
- Data model for `Visitor`, `Host` and check-in drafts.
- Entra ID design: on-prem AD (where applicable) → Entra ID → Microsoft Graph → secure backend/proxy → Flutter host list.
- Why client secrets are kept out of Flutter.
- Client feedback and the three resulting scope changes.
- Validation/error handling and persistence used in the prototype.
- Testing performed and known limitations.
- Jira evidence mapped to stories/tasks/acceptance criteria.
- GitHub evidence mapped to commits/branches/merges from the actual team repository.
- Reflection and Iteration 2 priorities.

## Jira evidence to capture from the real board

Create/use genuine tickets such as: Figma shell; individual check-in; group check-in; host selection; Entra host-service spike; Host Management; checkout password removal; Employee In/Out removal; admin dashboard; validation/testing. Capture the board showing movement through your real workflow and the issue history/assignees relevant to your team.

## GitHub evidence to capture from the real repository

Show genuine repository activity: initial Flutter scaffold, feature branches if your team uses them, meaningful commits, changed files/diffs, merges/pull requests where applicable, and a final Iteration 1 tagged/identified commit. Do not manufacture screenshots or commit history after the fact solely to look active; the evidence should match actual development work.
