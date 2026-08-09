# Enterprise Feature Implementation Plan (Dynetix Pro)

Aligning the application with the professional SRS requirements, focusing on BLoC state management, Localization, Secure Storage, and Biometric Auth.

## User Review Required

> [!IMPORTANT]
> - **Authentication Migration**: We are currently using Supabase. The SRS mentions "Firebase Auth / Custom JWT". I will continue with Supabase (which provides JWT) unless Firebase is strictly required for Auth.
> - **Localization**: I will implement English and Urdu. Do you have specific translations for the technical terms, or should I use standard professional Urdu?

## Proposed Changes

### 1. Architecture & State Management
Migrate current `StatefulWidget` logic to **BLoC/Cubit** for predictable state flows.

#### [Auth BLoC](file:///presentation/auth/bloc/auth_bloc.dart) [NEW]
- Handle Login, Signup, and Logout states.
- Manage persistent user sessions.

### 2. Localization (L10n)
Implement support for **English** and **Urdu**.

#### [pubspec.yaml](file:///pubspec.yaml)
- Add `flutter_localizations` dependency.
- Add `intl` dependency.

#### [NEW] [app_en.arb](file:///lib/l10n/app_en.arb) / [app_ur.arb](file:///lib/l10n/app_ur.arb)
- Define strings for both languages.

### 3. Security & Persistence
#### [Secure Storage Service](file:///lib/core/services/secure_storage_service.dart) [NEW]
- Integrated `flutter_secure_storage` for tokens and sensitive data.

#### [Hive Cache Service](file:///lib/core/services/hive_service.dart) [NEW]
- Offline caching for Services and Academy courses data.

### 4. Advanced Authentication
#### [Biometric Service](file:///lib/core/services/biometric_service.dart) [NEW]
- Implementation of `local_auth` for Fingerprint/FaceID lock.

---

## Verification Plan

### Automated Tests
- `flutter test`: Run unit tests for Auth BLoC logic.

### Manual Verification
- **Language Switch**: Toggle between English and Urdu in Profile settings.
- **Offline Mode**: Disable internet and verify if cached services/courses are visible via Hive.
- **Biometric**: Trigger biometric prompt on sensitive actions or app startup.
