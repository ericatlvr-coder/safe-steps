# Client feedback traceability

## Host Management / Entra ID

**Feedback:** add a dedicated Host Management area, with hosts synchronised from Microsoft Entra ID so the directory remains the single source of truth and administrators do not maintain a separate host database.

**Implemented:**
- `HostManagementScreen` added to the application drawer.
- `HostSelectionScreen` uses the same `EntraHostService` result.
- `ApiEntraHostService` reads a secure proxy endpoint.
- `backend/entra_proxy` obtains a server-side Microsoft Graph token and reads enabled Entra users.
- Flutter contains no client secret and does not create/edit a local host database.

## Checkout password

**Feedback:** password is unnecessary at checkout.

**Implemented:** `CheckoutScreen` contains only an email field plus validation. The visitor's latest active visit is located by email and updated to `Completed`.

## Employee In/Out

**Feedback:** the visitor register is not used for staff check-ins and this feature can be removed.

**Implemented:** no Employee In/Out action or employee-attendance flow is present in the welcome screen or application state.
