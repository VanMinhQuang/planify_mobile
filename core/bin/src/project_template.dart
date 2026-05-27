import 'dart:io';

import 'package:path/path.dart' as path;

import 'helpers.dart';

class FlutterProjectTemplate {
  FlutterProjectTemplate({this.rootProject = '.'});

  final String rootProject;

  String get pubCacheDefaultPath => '\$HOME/.pub-cache';

  Directory get android => Directory(path.join(rootProject, 'android'));

  Directory get ios => Directory(path.join(rootProject, 'ios'));

  Directory get assets => Directory(path.join(rootProject, 'assets'));

  Directory get lib => Directory(path.join(rootProject, 'lib'));

  File get pubspecYaml => File(path.join(rootProject, 'pubspec.yaml'));

  Directory get appCore => Directory(path.join(rootProject, 'app_core'));

  Directory get modules => Directory(path.join(rootProject, 'modules'));

  Directory get packages => Directory(path.join(rootProject, 'packages'));

  Directory get test => Directory(path.join(rootProject, 'test'));

  // Methods to analyze the project structure
  Map<String, dynamic> analyzeProject({String? projectPath}) {
    final projectRoot = projectPath ?? rootProject;
    final analysisResult = <String, dynamic>{};

    print('Analyzing project structure in: $projectRoot');

    analysisResult['android'] = _analyzeDirectory(
      'android',
      Directory(path.join(projectRoot, 'android')),
    );
    analysisResult['ios'] = _analyzeDirectory(
      'ios',
      Directory(path.join(projectRoot, 'ios')),
    );
    analysisResult['assets'] = _analyzeDirectory(
      'assets',
      Directory(path.join(projectRoot, 'assets')),
    );
    analysisResult['lib'] = _analyzeDirectory(
      'lib',
      Directory(path.join(projectRoot, 'lib')),
    );
    analysisResult['pubspec.yaml'] = _analyzeFile(
      'pubspec.yaml',
      File(path.join(projectRoot, 'pubspec.yaml')),
    );
    analysisResult['app_core'] = _analyzeDirectory(
      'app_core',
      Directory(path.join(projectRoot, 'app_core')),
    );
    analysisResult['modules'] = _analyzeDirectory(
      'modules',
      Directory(path.join(projectRoot, 'modules')),
    );
    analysisResult['packages'] = _analyzeDirectory(
      'packages',
      Directory(path.join(projectRoot, 'packages')),
    );
    analysisResult['test'] = _analyzeDirectory(
      'test',
      Directory(path.join(projectRoot, 'test')),
    );

    print('Analysis complete.');
    return analysisResult;
  }

  Map<String, dynamic> _analyzeDirectory(String name, Directory dir) {
    final result = <String, dynamic>{};
    if (dir.existsSync()) {
      result['found'] = true;
      try {
        final files = dir.listSync();
        result['fileCount'] = files.whereType<File>().length;
        result['dirCount'] = files.whereType<Directory>().length;
      } catch (e) {
        result['error'] = e.toString();
      }
    } else {
      result['found'] = false;
    }
    return result;
  }

  Map<String, dynamic> _analyzeFile(String name, File file) {
    final result = <String, dynamic>{};
    if (file.existsSync()) {
      result['found'] = true;
      try {
        if (name == 'pubspec.yaml') {
          result['pubspec'] = _analyzePubspec(file);
        }
      } catch (e) {
        result['error'] = e.toString();
      }
    } else {
      result['found'] = false;
    }
    return result;
  }

  Map<String, dynamic> _analyzePubspec(File file) {
    final result = <String, dynamic>{};
    try {
      final content = file.readAsStringSync();
      final lines = content.split('\n');
      result['dependenciesFound'] = lines.any(
        (line) => line.trim().startsWith('dependencies:'),
      );
      result['devDependenciesFound'] = lines.any(
        (line) => line.trim().startsWith('dev_dependencies:'),
      );
    } catch (e) {
      result['error'] = e.toString();
    }
    return result;
  }

  Future<void> createTemplateProject() async {
    stdout.writeln('Creating Flutter project template...');
    stdout.writeln('Enter your organization name (default: com.aegona): ');
    String orgName = stdin.readLineSync() ?? 'com.aegona';
    stdout.writeln('Enter your app name (default: my_app): ');
    String appName = stdin.readLineSync() ?? 'my_app';
    stdout.writeln(
      'Application platforms default are Android - Kotlin and iOS - Swift. If you plan to create a web app or desktop app, you can add them later by "flutter create ." command.',
    );
    stdout.writeln('Running command:');
    stdout.writeln(
      'flutter create --org $orgName --platforms android,ios -a kotlin -i swift $appName',
    );
    await runCommand(
      'flutter create --org $orgName --platforms android,ios -a kotlin -i swift $appName',
    );
    stdout.writeln('Changeing directory to $appName');
    final newRootProjectPath = path.join(rootProject, appName);
    Directory.current = Directory(newRootProjectPath);

    stdout.writeln('Coppying template app_core ...');
    await _copyTemplateAppCore(newRootProjectPath);

    stdout.writeln('Project created successfully.');
  }

  Future<void> testMethod() async {
    stdout.writeln('Testing _copyTemplateAppCore method...');
    // Add your test logic here
    await _copyTemplateAppCore(Directory.current.path);
  }

  Future<void> _copyTemplateAppCore(String rootProject) async {
    String pubcacheDirPath = Platform.environment['PUB_CACHE'] ?? '';
    if (pubcacheDirPath.isEmpty) {
      stdout.write(
        'PUB_CACHE environment variable is not set. Using default path: $pubCacheDefaultPath',
      );
      pubcacheDirPath = pubCacheDefaultPath;
    } else {
      stdout.write('Found PUB_CACHE environment variable: $pubcacheDirPath');
    }
    final appCoreTemplatePath = path.join(
      pubcacheDirPath,
      'git/flutter-core-df253cd0b93569dcad3a31b086faa3a170175c09/app_core',
    );
    // Copy the app_core template to the current project
    await runCommand('cp -r $appCore $appCoreTemplatePath');
  }
}
