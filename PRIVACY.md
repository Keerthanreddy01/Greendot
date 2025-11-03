# Privacy Policy

Last updated: 2025-11-03

GreenDot respects user privacy. This repository contains the app source code only. By default, the app:

- Does not collect sensitive personal data unless explicitly enabled (e.g., analytics/crash reports)
- May access device features (camera, microphone, storage) only with user permission
- May use third-party services (e.g., Firebase) to enable authentication, storage, or analytics

## Data We May Process

- Authentication data (if you sign in): email and basic profile (via Firebase Auth)
- App telemetry (optional): anonymized crash and usage metrics
- Images you choose to scan (processed locally via TFLite where possible)

## Where Data Is Stored

- On-device for local features (offline inference, preferences)
- In Firebase (Firestore/Storage) for cloud-enabled features, per your use

## Your Controls

- You can revoke permissions (camera/microphone/storage) in device settings
- You can request deletion of cloud data by contacting: `keerthanreddy1706@gmail.com`

## Developer Guidance (for Contributors)

- Do not commit secrets (.env, API tokens, private keys); use `.env.example` as a template
- Use environment variables or CI secrets for credentials
- Follow `SECURITY.md` for reporting vulnerabilities

For questions about this policy, contact: `keerthanreddy1706@gmail.com`.