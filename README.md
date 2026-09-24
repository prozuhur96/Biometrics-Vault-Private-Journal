# My Private Journal 🔒✍️

A Flutter-based private journal application that allows authenticated users to create, edit, and manage personal journal entries stored securely in Firebase Cloud Firestore.

The application uses Firebase Authentication for user accounts and associates journal entries with the authenticated user's Firebase UID. Individual journal entries can also be protected with an optional 4–6 digit PIN.


## Features

### 🔐 Firebase Authentication
The application uses **Firebase Authentication with Email/Password** for user accounts.

Users can:
- Create an account
- Sign in with their email and password
- Access their own journal entries after authentication

Authentication is handled through the application's authentication service.

## 📝 Journal Entries

Authenticated users can create and manage journal entries.

Journal data is stored in **Cloud Firestore** and associated with the authenticated user's Firebase UID.

## 🔢 Optional Entry PIN Protection

Individual journal entries can optionally be protected with a **4–6 digit PIN**.

The PIN protection applies to an **individual journal entry**, not to the entire journal application.

PIN-related functionality is handled by:

```text
lib/services/pin_service.dart
```

## Firebase

The application uses Firebase Authentication and Cloud Firestore.

### Firebase Authentication

Firebase Authentication provides:

- Email/password account creation
- Email/password sign-in
- User identity through the Firebase UID

The authenticated user's UID is used when working with their journal data.

### Cloud Firestore

Cloud Firestore stores the application's journal entries.

Each user's entries are associated with their authenticated Firebase UID.

### Security & Data Isolation

Journal entries are associated with the authenticated user's Firebase UID.

Individual journal entries can also have optional PIN protection for an additional layer of protection within the application.

## Project Structure

The main application code is contained inside the `lib/` directory.

```text
lib/
├── models/
│   └── journal_entry.dart
│
├── screens/
│   ├── entry_editor_screen.dart
│   ├── journal_home_screen.dart
│   ├── login_screen.dart
│   └── signup_screen.dart
│
├── services/
│   ├── auth_service.dart
│   ├── journal_service.dart
│   └── pin_service.dart
│
├── firebase_options.dart
└── main.dart
```

## Project Files

### `lib/main.dart`

The main entry point of the Flutter application.

It initializes the application and starts the Flutter UI.

## Models

### `lib/models/journal_entry.dart`

Contains the `JournalEntry` model used to represent journal entries within the application.

## Screens

### `lib/screens/login_screen.dart`

Provides the login interface for existing users.

Users authenticate using their Firebase email and password.

### `lib/screens/signup_screen.dart`

Provides the account registration interface.

Users can create a Firebase Authentication account using an email address and password.

### `lib/screens/journal_home_screen.dart`

The main journal screen for authenticated users.

It provides access to the user's journal entries and journal-related functionality.

### `lib/screens/entry_editor_screen.dart`

Provides the interface for creating and editing journal entries.

It is also involved when working with the optional PIN protection for individual entries.

## Services

### `lib/services/auth_service.dart`

Handles authentication-related functionality using Firebase Authentication.

### `lib/services/journal_service.dart`

Handles journal-related data operations involving Cloud Firestore.

Journal entries are associated with the authenticated user's Firebase UID.

### `lib/services/pin_service.dart`

Handles PIN-related functionality for individual journal entries.

The application's PIN protection uses:

4–6 digit PINs
Salted SHA-256 hashing

The PIN feature is optional and applies to individual entries rather than the entire journal.

## Firebase Configuration

### `lib/firebase_options.dart`

Contains the Firebase configuration used by the Flutter application.

This configuration is used when initializing Firebase for the supported platforms.

Firebase configuration can be generated or updated using:

```bash
flutterfire configure
```

## Getting Started

### Prerequisites

Before running the project, make sure you have:

- Flutter installed
- Dart installed through Flutter
- A Firebase project
- Firebase Authentication enabled
- Cloud Firestore configured

You can verify the Flutter installation with:

```bash
flutter doctor
```

##

### Installation
### 1. Clone the repository

```bash
git clone https://github.com/prozuhur96/My-Private-Journal.git
cd My-Private-Journal
```

##

### 2. Install Dependencies

Run:

```bash
flutter pub get
```

This installs the dependencies defined by the Flutter project.

##

### 3. Configure Firebase

Configure the project with FlutterFire:

```bash
flutterfire configure
```

This connects the Flutter application to the selected Firebase project and provides the Firebase configuration used by the application.

##

### 4. Configure Firebase Authentication

In the Firebase Console:

1. Open the project used by the application.
2. Open Authentication.
3. Open the Sign-in method section.
4. Enable Email/Password authentication.

The application uses email/password authentication for account creation and sign-in.

##

### 5. Configure Cloud Firestore

Create or enable a Cloud Firestore database in the Firebase project.

Journal entries use the following structure:

    users/
    └── {uid}/
        └── entries/
            └── {entryId}

The {uid} corresponds to the authenticated Firebase user's UID.

##

### 6. Run the Application

Run the application with:

```bash
flutter run
```

To run the application specifically in Chrome:

```bash
flutter run -d chrome
```

##

### Testing & Static Analysis
### Analyze the Project

Run Flutter's static analysis with:

```bash
flutter analyze
```

Run Tests

Run the project's tests with:

```bash
flutter test
```

### Check the Flutter Environment

Run:

```bash
flutter doctor
```

##

### Application Flow

The general application flow is:

        Start Application
            │
            ▼

        Login / Sign Up
            │
            ▼
        Firebase Authentication
            │
            ▼
        Authenticated User
            │
            ▼
        Journal Home
            │
            ├───────────────┐
            ▼               ▼
        Create Entry      Open Entry
            │               │
            ▼               ▼
        Save Entry       Optional PIN
            │               │
            └───────┬───────┘
                    ▼
                Cloud Firestore

Journal data is associated with the authenticated user's Firebase UID.

##

### Firestore Data Structure

Journal entries are organized under each authenticated user:

    users
    └── {uid}
        └── entries
            ├── {entryId}
            ├── {entryId}
            └── {entryId}

Where:

`{uid}` is the Firebase Authentication user ID.
`{entryId}` identifies an individual journal entry.

This structure allows journal entries to remain associated with the user account that owns them.


## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Application framework |
| Dart | Programming language |
| Firebase Authentication | Email/password authentication |
| Cloud Firestore | Journal data storage |
| FlutterFire | Firebase integration and configuration |
| SHA-256 | PIN hashing |
| Git | Source control |


## Author
**Prozuhur96**

GitHub repository:

https://github.com/prozuhur96/My-Private-Journal.git


##
Verification code:
WTC-DCLB43NB
