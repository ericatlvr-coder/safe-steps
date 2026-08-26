# Figma → Flutter mapping

| Supplied Figma / feedback item | Flutter implementation |
|---|---|
| Kiosk welcome with check-in/out QR options | `WelcomeScreen` |
| Employee In/Out | Removed following client feedback |
| Individual / group choice | `SignupTypeScreen` |
| Individual check-in fields | `CheckInFormScreen(type: 'Individual')` |
| Group check-in fields | `CheckInFormScreen(type: 'Group')` |
| Choose person to meet | `HostSelectionScreen`, populated by `EntraHostService` |
| Returning-user login | `LoginScreen` |
| Admin Number/password login | `AdminLoginScreen` |
| Checkout | `CheckoutScreen`; email only, password removed |
| Thank-you screen | `ThankYouScreen` |
| Terms and Conditions | `TermsScreen` |
| Welcome / Activity Log | `UserHomeScreen` |
| Change location | `LocationPickerScreen` |
| Admin Dashboard | `AdminDashboardScreen` |
| Make Entry | `MakeEntryScreen` |
| Notifications and Messages | `NotificationsScreen` |
| New client-requested Host Management | `HostManagementScreen` |
| Entra ID as host source of truth | `EntraHostService` + `backend/entra_proxy` |

## Visual translation

The implementation follows the supplied visual language: purple Safe Steps brand blocks, lime action buttons, translucent/rounded kiosk panels, compact grey form fields, a two-part logo, mobile-first layouts and the green/purple admin/visitor navigation language. The supplied Figma screenshot contained an image backdrop; the Flutter prototype uses a code-generated abstract blurred backdrop so the project has no unlicensed or missing image dependency.
