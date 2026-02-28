# Domino Score

Production-ready Flutter app for tracking domino game sessions, matches, rounds, and statistics. Uses **Clean Architecture**, **flutter_bloc (Cubit)**, **Firebase Firestore**, **FCM**, and **Cloud Functions** for push notifications on match end.

## Stack

- **Flutter** with Material 3
- **State:** flutter_bloc + Cubit (no Riverpod)
- **DI:** get_it
- **Navigation:** go_router (bottom tabs: Home, Sessions, Stats, Settings)
- **Backend:** Firebase (Firestore + Messaging)
- **Result type:** dartz `Either<Failure, T>`
- **Localization:** Arabic (RTL default) + English

## Project structure (Clean Architecture)

```
lib/
  main.dart
  core/
    di/           # get_it injection
    error/        # failures, exceptions
    theme/
    localization/ # AppLocalizations (ar/en)
    utils/
    widgets/
  features/
    players/      # data + domain + presentation (Cubit)
    teams/
    sessions/
    matches/
    stats/
    settings/
  firebase/
    firebase_init.dart
    firestore_refs.dart
    messaging_service.dart
```

## Firebase setup

1. **Create a Firebase project** at [Firebase Console](https://console.firebase.google.com).

2. **Register the app**
   - Add an Android app (package name e.g. `com.example.domino_score`).
   - Add an iOS app (bundle ID).

3. **Download config files**
   - Android: download `google-services.json` → put in `android/app/`.
   - iOS: download `GoogleService-Info.plist` → add to Xcode (e.g. `ios/Runner/`).

4. **Enable services**
   - **Firestore:** Create Database (start in test mode or set rules; see `firestore.rules`).
   - **Cloud Messaging:** Enable in Project settings → Cloud Messaging.

5. **FlutterFire CLI (recommended)**
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This generates `lib/firebase_options.dart` and config files. If you don’t use it, ensure `Firebase.initializeApp()` is called with the correct options (e.g. default from config files).

## Running the app

```bash
flutter pub get
flutter run
```

- **Seed sample data:** In **Settings**, use the “Seed sample data” button (debug) to create sample players and teams.

## Firestore data model (summary)

- **players** – name, avatarColor, createdAt  
- **teams** – name, playerIds[2], createdAt  
- **settings/global** – targetScore_1v1, targetScore_triple, targetScore_2v2, notifications_matchEnd, notifications_sessionReminders  
- **sessions** – title, date, matchType (1v1/triple/2v2), participantIds, status, createdAt, endedAt  
- **matches** – sessionId, matchType, participantIds, targetScore, status, winnerId, scores, createdAt, endedAt  
- **rounds** – matchId, index, winnerId, pointsDelta, notes, createdAt  
- **devices** – token, platform, updatedAt (FCM tokens keyed by deviceId from SharedPreferences)

## Deploying Cloud Functions

Functions send FCM when a match’s `status` becomes `"ended"` (and `settings/global` has `notifications_matchEnd: true`).

1. **Install Firebase CLI and login**
   ```bash
   npm i -g firebase-tools
   firebase login
   ```

2. **Init in project root (if not already)**
   ```bash
   firebase init
   ```
   Choose Firestore and Functions; use existing `firebase.json` / `functions` if you already have them.

3. **Install and build functions**
   ```bash
   cd functions
   npm install
   npm run build
   ```

4. **Deploy**
   ```bash
   firebase deploy --only functions
   ```

Trigger: `onMatchEnded` on `matches/{matchId}` document update when `status` changes to `"ended"`. It reads `settings/global`, then sends a multicast FCM to all tokens in `devices`.

## Indexes (Firestore)

If you see “index required” errors in the app or console, create the suggested composite indexes in Firestore → Indexes, or add them via `firestore.indexes.json` and deploy. Typical ones:

- **matches:** `sessionId` (asc), `createdAt` (asc)
- **rounds:** `matchId` (asc), `index` (asc)
- **rounds:** `matchId` (asc), `index` (desc) – for “last round” query in undo

## License

Private / none.
