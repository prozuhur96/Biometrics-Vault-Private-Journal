# Biometric Vault & Private Journal 🔒✍️

A secure, cross-platform mobile journal application built with **Flutter**, **Firebase**, and **AES-256 Field-Level Encryption**. Designed to safeguard personal thoughts through hardware-backed biometric protection and real-time cloud synchronization.

---

## 🔑 Security & Architecture

1. **Biometric Vault & Lifecycle Locking**
   - Protected via `local_auth` integration (Fingerprint / Face ID / Passcode).
   - Enforces automatic session re-locking whenever the application is paused, backgrounded, or minimized.

2. **Field-Level Encryption (AES-256)**
   - All entry titles and content are encrypted client-side using `encrypt` prior to transmitting over the network.
   - Raw database entries stored in Cloud Firestore remain unreadable cipher text to unauthorized third parties.

3. **Data Isolation & Security Rules**
   - User collections are partitioned by unique Firebase Authentication UID (`users/{uid}/entries/{entryId}`).
   - Cloud Firestore security rules strictly restrict document reads and writes to authenticated document owners.

4. **Non-Blocking Persistence & Client-Side Search**
   - Optimistic non-blocking asynchronous updates ensure instantaneous UI responsiveness even during network latency.
   - Client-side decrypted stream filtering powers real-time search without exposing plaintext keys to cloud database indexes.

---

## 🛠️ Tech Stack

- **Framework**: Flutter / Dart
- **Authentication**: Firebase Auth (Email/Password)
- **Database**: Cloud Firestore
- **Security**: `local_auth` (Biometrics), `encrypt` (AES-256)

---

## 📂 Project Structure

```text
Biometric_Vault_Journal/
├── android/
├── ios/
├── lib/
│   ├── models/
│   │   └── journal_entry.dart
│   ├── screens/
│   │   ├── biometric_lock_screen.dart
│   │   ├── entry_editor_screen.dart
│   │   ├── journal_home_screen.dart
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── biometric_service.dart
│   │   ├── encryption_service.dart
│   │   └── journal_service.dart
│   ├── firebase_options.dart
│   └── main.dart
├── test/
├── .gitignore
├── pubspec.yaml
└── README.md
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (`>=3.0.0`)
- Firebase Project configured for Flutter (`flutterfire configure`)

### Installation & Run

1. Clone the repository:
```bash
  git clone [https://github.com/prozuhur96/Biometrics-Vault-Private-Journal.git](https://github.com/prozuhur96/Biometrics-Vault-Private-Journal.git)
```

2. Install Dependencies:

```bash
flutter pub get
```

3. Configure Firebase:

```bash
flutterfire configure
```

4. Run the App:

```bash
flutter run
```

## 🧪 Testing & Static Analysis
To run project diagnostics and code analysis:

```Bash
flutter analyze
```