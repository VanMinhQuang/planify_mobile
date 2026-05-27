# Planify Mobile

Flutter mobile client for Planify.

The app uses BLoC for feature state, GoRouter for navigation, Dio for the custom
Node.js API, Socket.IO for realtime plan updates, and backend-managed R2 uploads
for cover/avatar images.

Run with:

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1 --dart-define=REALTIME_URL=http://10.0.2.2:3000
```

R2 is the default upload mode. To test local IIS uploads instead:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1 --dart-define=REALTIME_URL=http://10.0.2.2:3000 --dart-define=UPLOAD_MODE=iis
```
