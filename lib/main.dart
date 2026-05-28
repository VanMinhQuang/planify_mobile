import 'dart:async';

import 'package:planify_mobile/app/bootstrap.dart';
import 'package:planify_mobile/app/config.dart';
import 'package:planify_mobile/firebase_options.dart';

void main() {
  unawaited(
    bootstrap(
      config: appConfig,
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  );
}
