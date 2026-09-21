# 🔒 Biometric Vault & Private Journal

A Flutter mobile application designed to securely store private notes and encrypted journal entries using a dual-layer security approach: **Cloud Authentication via Firebase** and **Hardware Security via Biometrics (Fingerprint/Face ID)**.

---

## 🌟 Key Features

* **Multi-Provider Firebase Authentication:**
  * Email & Password Sign-Up and Login with form validation.
  * Google Sign-In integration.
  * Real-time auth state updates using `FirebaseAuth.instance.authStateChanges()`.
  * Secure Sign-Out and session management.

* **Hardware Biometric Lock:**
  * Local device authentication (`local_auth`) requiring Fingerprint or Face ID to unlock private notes.
  * Automatic re-lock trigger when the application is minimized or resumed.

* **User-Scoped Private Vault:**
  * Journal entries tied strictly to the authenticated user's unique Firebase `UID`.
  * Staggered card layout displaying private notes.
  * Account management showing user profile info and auth provider details.

---

## 🏗️ Architecture & Auth Flow

```text
               +-----------------------------+
               |   App Launch (main.dart)    |
               +--------------+--------------+
                              |
                              v
               +-----------------------------+
               |   StreamBuilder Auth Check  |
               +--------------+--------------+
                              |
                 +------------+------------+
                 |                         |
         (User is null)            (User logged in)
                 v                         v
       +-------------------+     +-------------------+
       |   Login Screen    |     |  Biometric Lock   |
       | (Email / Google)  |     |  (local_auth)     |
       +-------------------+     +---------+---------+
                                           |
                                   (Biometric Success)
                                           v
                                 +-------------------+
                                 |  Journal Vault    |
                                 |  (User Notes)     |
                                 +-------------------+
```

## 📂 Project Structure

```text
lib/
├── main.dart                  # App entry point & Firebase initialization
├── firebase_options.dart      # FlutterFire generated configuration
├── models/
│   └── note_model.dart        # Data model for journal entries
├── services/
│   ├── auth_service.dart      # Firebase Authentication methods & streams
│   └── local_auth_service.dart# Hardware biometric verification methods
├── screens/
│   ├── auth_wrapper.dart       # StreamBuilder router based on auth state
│   ├── login_screen.dart       # Email/Password & Google Sign-In screen
│   ├── lock_screen.dart        # Biometric prompt trigger screen
│   └── journal_home_screen.dart# Main staggered grid view for notes
└── widgets/
    └── note_card.dart         # UI component for individual note display
```

## 🛠️ Tech Stack & Dependencies

- **Framework:** Flutter (Dart)
- **Authentication:** firebase_auth, google_sign_in
- **Core Firebase:** firebase_core
- **Hardware Security:** local_auth
- **UI Components:** flutter_staggered_grid_view, google_fonts

## 🚀 Getting Started

**Prerequisites**
- Flutter SDK (Latest Stable)
- Firebase CLI (firebase-tools) & FlutterFire CLI (flutterfire_cli)
- Android Studio / Xcode (for device/emulator setup with biometric support)


**Setup Instructions**
1. Clone the Repository:

```Bash
git clone [https://github.com/prozuhur96/Biometrics-Vault-Private-Journal.git](https://github.com/prozuhur96/Biometrics-Vault-Private-Journal.git)
cd Biometrics-Vault-Private-Journal
```

2. Install Dependencies:

```Bash
flutter pub get
```

3. Configure Firebase:

```Bash
flutterfire configure
```

4. Run the App:

```Bash
flutter run
```

