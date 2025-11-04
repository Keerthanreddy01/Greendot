# Security Guidelines for GreenDot

## 🔐 Files That Should NEVER Be Committed

### Environment Files
- ❌ `.env` - Contains sensitive API keys and credentials
- ✅ `.env.example` - Template file (safe to commit)

### Firebase Configuration
- ⚠️ `android/app/google-services.json` - **Currently IGNORED** (not in repo)
- ⚠️ `ios/Runner/GoogleService-Info.plist` - **Currently IGNORED** (not in repo)
- ✅ `lib/firebase_options.dart` - Client-side config (safe to commit, protected by Firebase rules)

### API Keys & Secrets
- ❌ Any file containing API keys
- ❌ Service account JSON files
- ❌ Private keys (`.pem`, `.p12`, `.pfx`)
- ❌ Files in `lib/secrets.dart` or similar

### Signing & Release
- ❌ `*.keystore`, `*.jks` - Android signing keys
- ❌ `android/key.properties` - Signing configuration

## ✅ Current Security Status

### Protected Files (in .gitignore)
```
✓ .env and all .env.* files
✓ android/app/google-services.json
✓ ios/Runner/GoogleService-Info.plist
✓ All keystore and signing files
✓ lib/secrets.dart
✓ Service account and private key files
```

### Safe Files (in repository)
```
✓ lib/firebase_options.dart - Client-side Firebase config (protected by Firebase Security Rules)
✓ .env.example - Template without actual keys
✓ All application source code
```

## 🛡️ Firebase Security

Firebase client configuration (`lib/firebase_options.dart`) is **safe to commit** because:
1. It contains only client-side identifiers
2. Actual security is enforced by Firebase Security Rules
3. API keys are restricted in Firebase Console

### What Protects Your Data:
- ✅ Firebase Security Rules (Firestore, Storage, etc.)
- ✅ API key restrictions in Google Cloud Console
- ✅ Authentication requirements
- ❌ NOT the configuration file itself

## 📋 Before Every Push Checklist

1. Run: `git status --ignored` to verify sensitive files are ignored
2. Check for accidentally staged secrets: `git diff --cached`
3. Verify .gitignore is up to date
4. Never use `git add .` without checking `git status` first

## 🚨 If You Accidentally Commit Secrets

1. **DO NOT** just delete the file and commit again (it's still in git history)
2. Immediately rotate/regenerate the exposed credentials
3. Use `git filter-branch` or BFG Repo-Cleaner to remove from history
4. Force push (⚠️ coordinate with team first)
5. Update all affected API keys in their respective consoles

## 📚 Resources

- [GitHub Secret Scanning](https://docs.github.com/en/code-security/secret-scanning)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
