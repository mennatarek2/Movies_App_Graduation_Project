# Firebase Setup Instructions

## Prerequisites
1. Create a Firebase project at https://console.firebase.google.com/
2. Enable Authentication (Email/Password) in Firebase Console
3. Enable Cloud Firestore Database in Firebase Console

## Setup Steps

### 1. Install FlutterFire CLI (if not already installed)
```bash
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase for your Flutter app
```bash
flutterfire configure
```

This command will:
- Detect your Firebase projects
- Let you select which project to use
- Generate `firebase_options.dart` file automatically
- Configure Firebase for all platforms (Android, iOS, Web, etc.)

### 3. Update main.dart (Already done)
The Firebase initialization is already added to `main.dart`:
```dart
await Firebase.initializeApp();
```

### 4. Firestore Security Rules
Make sure to set up proper security rules in Firestore Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 5. Authentication Methods
In Firebase Console → Authentication → Sign-in method:
- Enable "Email/Password" provider

## Features Implemented

✅ Email/Password Authentication
✅ User Registration with Firestore
✅ Password Reset
✅ User Session Management
✅ Automatic Login State Persistence

## Firestore Collection Structure

### Users Collection
```
users/{userId}
  - name: string
  - email: string
  - phone: string
  - avatar: string
  - createdAt: timestamp
  - updatedAt: timestamp
```

## Testing

After setup, you can test:
1. Register a new user
2. Login with registered credentials
3. Forgot password functionality
4. User data is saved in Firestore

