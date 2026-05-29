# app_core

Shared Flutter core library for the Planify mobile app.

This package contains reusable UI widgets, theme constants, models, storage
keys, utility helpers, and service wrappers used by the host app.

## Usage

The host app consumes this package from the repository root:

```yaml
dependencies:
  app_core:
    path: core
```

Import the public barrel where broad access is useful:

```dart
import 'package:app_core/app_core.dart';
```

Or import narrower libraries directly:

```dart
import 'package:app_core/ui/theme.dart';
import 'package:app_core/services/network/network.dart';
```

## Maintenance

Run package checks from this directory:

```bash
flutter pub get
flutter analyze
```

Generated files under `lib/generated/` are produced from the host app assets
and translations.
