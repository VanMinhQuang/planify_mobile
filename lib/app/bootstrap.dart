import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planify_mobile/app/app.dart';
import 'package:planify_mobile/app/config.dart';
import 'package:planify_mobile/di/injection.dart';

Future<void> bootstrap({
  required AppConfig config,
  required FirebaseOptions options,
}) async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(options: options);
      await GoogleSignIn.instance.initialize();
      setupDI(config);
      runApp(const PlanifyApp());
    },
    (error, stack) {
      developer.log('Uncaught error: $error', stackTrace: stack);
    },
  );
}
