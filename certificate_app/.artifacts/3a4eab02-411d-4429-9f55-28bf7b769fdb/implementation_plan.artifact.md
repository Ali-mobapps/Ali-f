# CertifyPro App Implementation Plan

Build a full-featured certificate management application with a Flutter frontend and Firebase backend, based on the provided HTML/Tailwind designs.

## User Review Required

> [!IMPORTANT]
> **Firebase Setup**: I will set up the code for Firebase, but you will need to perform the initial project creation in the [Firebase Console](https://console.firebase.google.com/) and run `flutterfire configure` if you want to test on a real device/emulator.

> [!NOTE]
> **State Management**: I plan to use `Provider` or `Riverpod` for state management to keep the app scalable and maintainable.

## Proposed Changes

### 1. Foundation & Dependencies

#### [MODIFY] [pubspec.yaml](file:///C:/Users/Kashif Computers/Documents/GitHub/ali-f/certificate_app/pubspec.yaml)
- Add Firebase dependencies: `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_storage`.
- Add UI dependencies: `google_fonts`, `provider`, `intl`.

#### [NEW] Theme System
- Implement `CertifyProTheme` class in `lib/core/theme.dart` using colors and typography from `DESIGN.md`.

### 2. Project Structure
Organize `lib/` into a clean feature-first architecture:
- `lib/core/`: Theme, constants, common widgets (Sidebar, Navbar).
- `lib/features/auth/`: Login/Signup screens and logic.
- `lib/features/dashboard/`: Stats and recent activity.
- `lib/features/certificates/`: Issue, View Records, and Verification.
- `lib/features/templates/`: Customizer UI.
- `lib/services/`: Firebase Firestore and Auth services.

### 3. Frontend Implementation (UI Conversion)

#### [NEW] [DashboardScreen](file:///C:/Users/Kashif Computers/Documents/GitHub/ali-f/certificate_app/lib/features/dashboard/dashboard_screen.dart)
- Convert `dashboard/code.html` to a responsive Flutter layout with a persistent `NavigationDrawer` for desktop and `BottomNavigationBar` for mobile.

#### [NEW] [RecordsScreen](file:///C:/Users/Kashif Computers/Documents/GitHub/ali-f/certificate_app/lib/features/certificates/records_screen.dart)
- Convert `certificate_records/code.html` to a `DataTable` or custom list view with search and filter functionality.

#### [NEW] [IssueCertificateScreen](file:///C:/Users/Kashif Computers/Documents/GitHub/ali-f/certificate_app/lib/features/certificates/issue_screen.dart)
- Convert `issue_certificate/code.html` into a multi-step form or Bento-grid layout with a live preview card.

#### [NEW] [VerifyScreen](file:///C:/Users/Kashif Computers/Documents/GitHub/ali-f/certificate_app/lib/features/certificates/verify_screen.dart)
- Convert `verify_certificate/code.html` with a clear distinction between the "Scan/Search" state and "Verified" state.

#### [NEW] [TemplateCustomizerScreen](file:///C:/Users/Kashif Computers/Documents/GitHub/ali-f/certificate_app/lib/features/templates/customizer_screen.dart)
- Implement the complex two-column layout from `template_customizer/code.html`.

### 4. Backend Integration (Firebase)

- **Firestore**: Create collections for `certificates` (storing recipient info, issue date, template ID) and `templates` (storing custom styles, logos, signatures).
- **Authentication**: Secure the Admin sections (Dashboard, Records, Issue) so only authorized users can access them.
- **Verification Logic**: A public-facing service that queries Firestore by Certificate ID and returns the authenticity status.

## Verification Plan

### Automated Tests
- Unit tests for the `CertificateService` to ensure correct Firestore reads/writes.
- Widget tests for the `VerifyScreen` to check state transitions (Loading -> Verified).

### Manual Verification
- Verify responsiveness by resizing the window (Mobile vs. Desktop layouts).
- Test the "Issue Certificate" flow and verify the record appears in the "Records" list and Firestore Console.
- Test the "Verify" flow by entering a generated ID.
