# Public Sharing / Hackathon Copy — Sanitization Notes

This copy of the repository has been prepared for public sharing (e.g., hackathons, demos, or third-party review).

What was removed or redacted:
- Firebase credentials and project identifiers in `lib/firebase_options.dart` have been replaced with `REDACTED` placeholders.
- The top-level `firebase.json` has been replaced with a template/example and does not contain real values.
- Local service files such as `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` are intentionally not tracked in this repo's public copy. They should be kept private and never committed.
- Personal contact details were removed from `README.md`.

How to set up the project locally:
1. Create your own Firebase project (Auth, Firestore, Storage) if you need cloud features.
2. Install Flutter and required SDKs.
3. Run `flutter pub get` to install dependencies.
4. Generate Firebase options locally:
   - Install the FlutterFire CLI: `dart pub global activate flutterfire_cli`
   - Run `flutterfire configure` and follow the prompts. This will generate `lib/firebase_options.dart` with values for your Firebase project.
5. Place `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) in their respective platform folders if you use Firebase services.
6. Do NOT commit these files to the public repository. Add them to `.gitignore`.

If you need to share this project with collaborators securely, provide them with a secure link or a private archive containing the needed platform files and a short setup script.

If you want me to help automate local setup (generate env templates, create a sample `lib/firebase_options_private.dart` for local development, or create a CI stub), request the option and I will add it.