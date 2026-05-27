import 'dart:io';

Future<bool> validateTranslationsDirectory(String translationsDir) async {
  final dir = Directory(translationsDir);

  if (!await dir.exists()) {
    print('Error: The "assets/translations" directory does not exist.');
    return false;
  }

  final files = dir.listSync();
  if (files.isEmpty) {
    print('Warning: The "assets/translations" directory is empty.');
    // You might want to return false or true depending on your requirements.
    // For example, you could return false to prevent generating empty files:
    // return false;
    // Or you can return true, knowing that it will generate empty output.
  }
  return true;
}
