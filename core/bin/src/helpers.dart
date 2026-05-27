// ignore_for_file: avoid_print

import 'dart:collection';
import 'dart:io';

import 'package:path/path.dart' as path;

/// Helper function to execute a process and print results
Future<void> _executeProcess(String executable, List<String> arguments) async {
  final result = await Process.run(
    executable,
    arguments,
    runInShell: true,
    workingDirectory: Directory.current.path,
  );
  print(result.stdout);
  print(result.stderr);
}

/// Executes a command in specified directories (absolute paths).
///
/// This function allows you to run a command in multiple directories, specified by
/// their absolute paths.
///
/// Example usage:
/// ```dart
/// import 'dart:io';
///
/// await runCommand('dart fix --apply', directories: [
///   '/path/to/core',
///   Directory.current.path,
///   '/path/to/modules/module1',
///   '/path/to/packages/package1',
/// ]);
/// ```
///
/// This will execute `dart fix --apply` in the specified absolute paths.
///
/// Parameters:
///   - `command`: The command to execute as a string.
///   - `directories`: A list of absolute paths where the command should be executed.
///     Defaults to an empty list.
///   - `dryRun`: A boolean flag indicating whether to perform a dry run. If `true`, the command will not be executed,
///     and only the command and target directory will be printed. Defaults to `false`.
///
/// Usage:
/// ```dart
/// import 'dart:io';
///
/// runCommand('dart run build_runner -d', directories: [
///   '/path/to/core',
///   Directory.current.path,
///   '/path/to/modules/module1',
///   '/path/to/packages/package1',
/// ]);
/// ```
///
/// The function iterates through the `directories` list, executing the command
/// in each specified absolute path.
///
/// If `dryRun` is `true`, the command will not be executed, and only the command and the
/// target directory will be printed.
///
/// If a specified directory does not exist, an error message is printed.
///
/// The function returns `Future<void>` to indicate asynchronous execution.
Future<void> runCommand(
  String command, {
  List<String> directories = const ['.'],
  bool dryRun = false,
}) async {
  final rootPath = Directory.current.path;

  for (final dir in directories) {
    if (Directory(dir).existsSync()) {
      Directory.current = dir;
      print("Running in directory: ${Directory.current.path}");
      if (!dryRun) {
        await _executeProcess(
          command.split(' ').first,
          command.split(' ').skip(1).toList(),
        );
      } else {
        print("Dry run: $command");
      }
    } else {
      print("Directory $dir does not exist.");
    }
  }

  Directory.current = rootPath;
}

Future<List<String>> findChildPubspecDirectories() async {
  final rootPath = Directory.current.path;
  final parentPath = Directory(rootPath).parent.path;
  print('Analyzing directories - rootPath: $rootPath, parentPath: $parentPath');
  final resultDirectories = <String>[];
  final queue = Queue<String>();

  queue.addAll([parentPath, rootPath]);

  // Directories to skip
  const skipDirs = {
    'build',
    'ios',
    'android',
    '.dart_tool',
    'ephemeral', // ← skips .plugin_symlinks infinite loop
    '.plugin_symlinks', // ← explicitly skip symlinks folder
    '.symlinks',
    'windows',
    'linux',
    'macos',
    'web',
    '.flutter-plugins',
  };

  while (queue.isNotEmpty) {
    final currentPath = queue.removeFirst();
    final dir = Directory(currentPath);

    if (!dir.existsSync()) continue;

    final stat = dir.statSync();
    if (stat.type == FileSystemEntityType.link) continue;

    List<FileSystemEntity> entities;

    try {
      entities = dir.listSync(followLinks: false);
    } catch (e) {
      continue;
    }

    for (final entity in entities) {
      if (entity is File && path.basename(entity.path) == 'pubspec.yaml') {
        resultDirectories.add(dir.path);
        break;
      }
    }

    // ALWAYS continue traversing children
    for (final entity in entities) {
      if (entity is Directory) {
        final dirName = path.basename(entity.path);

        if (!skipDirs.contains(dirName) && !dirName.startsWith('.')) {
          queue.add(entity.path);
        }
      }
    }
  }
  print('Directories with pubspec.yaml: $resultDirectories');

  final uniqueDirectories = resultDirectories.toSet().toList();

  return uniqueDirectories;
}
