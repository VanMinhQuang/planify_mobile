// ignore_for_file: avoid_print
import 'dart:io';

import 'package:path/path.dart' as path;

import './src/src.dart';

void main() {
  final currentProject = FlutterProjectTemplate();

  const menu = '''
Command Line Interface (CLI) for Flutter Application
  1. Install Tools (Install all nesessary tools - Once)
    - npm install -g firebase-tools
    - dart pub global activate flutterfire_cli
    - dart pub global activate flutter_gen
  2. Install packages
    - Run respectively commands: 4 -> 2 -> 3 -> 7 -> 6
  3. Generate Locale Keys
  4. Generate Assets
  5. flutter pub get
  6. Run dart fix
  7. Build runner
  8. Delete Generated files
  9. Test Core
    - Analyze project structure
  0. Exit
''';

  print(menu);
  stdout.write("Enter your choice: ");
  final choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      installTools();
      break;
    case '2':
      installAll();
      break;
    case '3':
      generateLocaleKeys();
      break;
    case '4':
      generateAssets();
      break;
    case '5':
      runFlutterPubGet();
      break;
    case '6':
      runDartFix();
      break;
    case '7':
      runBuildRunner();
      break;
    case '8':
      deleteGenFiles();
      break;
    case '9':
      testCore(() {
        currentProject.testMethod();
      });
      break;
    case '0':
      exit(0);
    default:
      print("Invalid choice");
      exit(1);
  }
}

/// Command 9
Future<void> testCore(void Function() input) async {
  input();
}

/// Command 8
Future<void> deleteGenFiles() async {
  await runCommand(
    'find . -name "*.g.dart" -o -name "*.gen.dart" -o -name "*.freezed.dart" -type f -delete',
  );
}

/// Command 7
Future<void> runBuildRunner() async {
  const command = 'dart run build_runner build -d';
  final directories = await findChildPubspecDirectories();
  await runCommand(command, directories: directories);
}

/// Command 6
Future<void> runDartFix() async {
  const command = 'dart fix --apply';
  final directories = await findChildPubspecDirectories();
  await runCommand(command, directories: directories);
}

/// Command 5
Future<void> runFlutterPubGet() async {
  const command = 'flutter pub get';
  final directories = await findChildPubspecDirectories();
  await runCommand(command, directories: directories);
}

/// Command 4
Future<void> generateAssets() async {
  await runCommand('fluttergen -c pubspec.yaml');
}

/// Command 3
Future<void> generateLocaleKeys() async {
  final translationsDir = path.join(
    Directory.current.path,
    'assets',
    'translations',
  );
  if (!await validateTranslationsDirectory(translationsDir)) {
    return;
  }
  await generateLocaleFiles(translationsDir);
}

Future<void> generateLocaleFiles(String translationsDir) async {
  const defaultOutputDir = 'core/lib/generated';
  const defaultLocaleKeysFileName = 'locale_keys.g.dart';

  // Must be relative to where the command runs (app_mobile/)
  const relativeTranslationsDir = 'assets/translations';

  await runCommand(
    'dart run easy_localization:generate -f keys -o $defaultLocaleKeysFileName '
    '--source-dir $relativeTranslationsDir --output-dir $defaultOutputDir',
  );
  await runCommand(
    'dart run easy_localization:generate '
    '--source-dir $relativeTranslationsDir --output-dir $defaultOutputDir',
  );
}

/// Command 2
Future<void> installAll() async {
  await deleteGenFiles();
  await runFlutterPubGet();
  await generateLocaleKeys();
  await generateAssets();
  await runBuildRunner();
}

/// Command 1
Future<void> installTools() async {
  const tools = [
    'npm install -g firebase-tools',
    'dart pub global activate flutterfire_cli',
    'dart pub global activate flutter_gen',
  ];
  for (final tool in tools) {
    await runCommand(tool);
  }
}
