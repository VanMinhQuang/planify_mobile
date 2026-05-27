import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUploadService {
  FirebaseUploadService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadFile({
    required File file,
    required String objectPath,
  }) async {
    final task = await _storage.ref(objectPath).putFile(file);
    return task.ref.getDownloadURL();
  }
}
