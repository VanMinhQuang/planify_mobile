# Planify Mobile

Flutter mobile client for Planify.

The app uses BLoC for feature state, GoRouter for navigation, Dio for the custom
Node.js API, Socket.IO for realtime plan updates, and Firebase Storage for
cover/avatar uploads.

Run with:

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1 --dart-define=REALTIME_URL=http://10.0.2.2:3000
```

To test local IIS uploads instead of Firebase Storage:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1 --dart-define=REALTIME_URL=http://10.0.2.2:3000 --dart-define=UPLOAD_MODE=iis
```
