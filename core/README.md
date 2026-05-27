# app_core — Flutter Project CLI

A command-line tool for managing the `app_mobile` Flutter project. It automates common tasks like installing packages, generating assets, locale keys, and running build tools.

## Prerequisites

- [Dart SDK](https://dart.dev/get-dart) installed and on your `PATH`
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and on your `PATH`
- Run from the `app_mobile/` directory

## Running the CLI

```bash
cd app_mobile
dart run app_core
```

This opens an interactive menu:

```
Command Line Interface (CLI) for Flutter Application
  1. Install Tools
  2. Install packages
  3. Generate Locale Keys
  4. Generate Assets
  5. flutter pub get
  6. Run dart fix
  7. Build runner
  8. Delete Generated files
  9. Test Core
  0. Exit
```

Enter the number of the command you want to run and press Enter.

---

## Commands

### 1 — Install Tools
Installs global tools required by the project. Run this **once** on a new machine.

Installs:
- `firebase-tools` via npm
- `flutterfire_cli` via dart pub global
- `flutter_gen` via dart pub global

```bash
# Requires Node.js and npm to be installed
dart run app_core  # then enter: 1
```

---

### 2 — Install Packages
Runs a full project setup in the correct order:

1. Deletes all generated files
2. Runs `flutter pub get` in all packages
3. Generates locale keys
4. Generates assets
5. Runs build runner

Use this when setting up the project for the first time or after a major dependency change.

---

### 3 — Generate Locale Keys
Generates `locale_keys.g.dart` from translation files located at:

```
app_mobile/assets/translations/
```

Output is written to:

```
app_mobile/core/lib/generated/
```

> **Note:** Translation JSON files must exist in `assets/translations/` before running this command.

---

### 4 — Generate Assets
Runs `fluttergen` to generate strongly-typed asset references from `pubspec.yaml`.

```bash
dart run app_core  # then enter: 4
```

---

### 5 — Flutter Pub Get
Runs `flutter pub get` across all packages in the project that contain a `pubspec.yaml`.

---

### 6 — Run Dart Fix
Runs `dart fix --apply` across all packages to automatically fix lints and deprecations.

---

### 7 — Build Runner
Runs `dart run build_runner build -d` across all packages to generate code (e.g. Freezed, json_serializable).

---

### 8 — Delete Generated Files
Deletes all files matching:
- `*.g.dart`
- `*.gen.dart`
- `*.freezed.dart`

Useful before a clean rebuild.

---

### 9 — Test Core
Analyzes and validates the project structure using the internal `FlutterProjectTemplate`.

---

### 0 — Exit
Exits the CLI.

---

## Manual Fallback Commands

If a CLI option is not working, run the equivalent commands manually from `app_mobile/`:

### Command 1 — Install Tools
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
dart pub global activate flutter_gen
```

### Command 3 — Generate Locale Keys
```bash
dart run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations --output-dir core/lib/generated
dart run easy_localization:generate --source-dir assets/translations --output-dir core/lib/generated
```

### Command 4 — Generate Assets
```bash
fluttergen -c pubspec.yaml
```

### Command 5 — Flutter Pub Get
```bash
# Run in each package directory that has a pubspec.yaml
flutter pub get
```

### Command 6 — Run Dart Fix
```bash
dart fix --apply
```

### Command 7 — Build Runner
```bash
dart run build_runner build -d
```

### Command 8 — Delete Generated Files
```bash
# Windows (PowerShell)
Get-ChildItem -Recurse -Include "*.g.dart","*.gen.dart","*.freezed.dart" | Remove-Item

# macOS / Linux
find . -name "*.g.dart" -o -name "*.gen.dart" -o -name "*.freezed.dart" -type f -delete
```

---

## Recommended First-Time Setup Order

```
4 → 2 → 3 → 7 → 6
```

Or simply run command **2 (Install packages)** which handles all of these steps automatically.

---

## Project Structure

```
app_mobile/
├── assets/
│   └── translations/       # Locale JSON files (input for command 3)
└── core/
    ├── bin/
    │   └── app_core.dart   # CLI entry point
    ├── lib/
    │   └── generated/      # Auto-generated files (locale keys, assets)
    └── pubspec.yaml
```
