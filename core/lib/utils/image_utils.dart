import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_core/ui/widgets/sheet/image_modal/cubit/image_action_cubit.dart';
import 'package:app_core/ui/widgets/sheet/image_modal/image_action_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import '../generated/locale_keys.g.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();
  static const int _maxFileSize = 5 * 1024 * 1024; // 5 MB in bytes

  /// Pick an image from the device camera
  static Future<File?> pickImageFromCamera({int quality = 80}) async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: quality,
        requestFullMetadata: false,
      );

      if (file == null) return null;

      final fileStat = await file.length();
      if (fileStat > _maxFileSize) {
        throw LocaleKeys.file_too_large.tr();
      }

      return await _renameFile(file, 0);
    } catch (e) {
      rethrow;
    } finally {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

  /// Pick an image from the gallery
  static Future<File?> pickImageFromGallery({int quality = 80}) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: quality,
        requestFullMetadata: false,
      );

      if (file == null) return null;
      final fileStat = await file.length();
      if (fileStat > _maxFileSize) {
        throw LocaleKeys.file_too_large.tr();
      }
      return await _renameFile(file, 0);
    } catch (e) {
      print('Gallery error: $e');
      rethrow;
    }
  }

  /// Pick any file
  static Future<File?> pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf', 'gif'],
      );

      if (result != null && result.files.single.path != null) {
        final xFile = XFile(result.files.single.path!);

        return await _renameFile(xFile, 0);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<File>?> pickMultipleImageFromCamera({
    int quality = 80,
  }) async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: quality,
        requestFullMetadata: false,
      );

      if (file == null) return null;

      final renamed = await _renameFile(file, 0);
      return [renamed];
    } catch (e) {
      rethrow;
    } finally {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

  /// Pick multiple images from gallery
  static Future<List<File>> pickMultipleImagesFromGallery({
    int quality = 80,
  }) async {
    try {
      final List<XFile> files = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: quality,
        requestFullMetadata: false,
      );

      return Future.wait(
        files.asMap().entries.map((e) => _renameFile(e.value, e.key)),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Pick multiple files
  static Future<List<File>> pickMultipleFiles() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf', 'gif'],
      );

      if (result != null) {
        final paths = result.files
            .map((file) => file.path)
            .whereType<String>()
            .toList();
        return Future.wait(
          paths.asMap().entries.map((e) => _renameFile(XFile(e.value), e.key)),
        );
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<File> _renameFile(XFile file, int index) async {
    try {
      final fileStat = await file.length();
      if (fileStat > _maxFileSize) {
        throw LocaleKeys.file_too_large.tr();
      }
      final oldFile = File(file.path);
      final fileName = p.basename(file.path);

      if (fileName.length <= 30) {
        return oldFile;
      }

      final appDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ext = p.extension(file.path);
      final newPath = p.join(
        appDir.path,
        index == 0 ? '$timestamp$ext' : '$timestamp ($index)$ext',
      );
      // final newPath = p.join(
      //   appDir.path,
      //   '$timestamp$ext',
      // );

      final newFile = await oldFile.copy(newPath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }

      return newFile;
    } catch (e) {
      rethrow;
    }
  }

  // ===== Permission helpers =====

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    if (Platform.isAndroid) {
      if (status.isPermanentlyDenied) {
        //await openAppSettings();
        return false;
      }

      final result = await Permission.camera.request();
      return result.isGranted;
    } else {
      final request = await Permission.camera.request();

      if (request.isPermanentlyDenied) {
        // await openAppSettings();
        return false;
      }
      return true;
    }
  }

  static Future<bool> requestGalleryPermission() async {
    final status = await Permission.photos.status;
    if (status.isGranted) return true;

    if (Platform.isAndroid) {
      if (status.isPermanentlyDenied) {
        //  await openAppSettings();
        return false;
      }

      final result = await Permission.photos.request();
      return result.isGranted;
    } else {
      return true;
    }
  }

  static Future<File?> openBottomSheetImageFilePicker(
    BuildContext context, {
    required String title,
    bool canPickFile = false,
  }) async {
    // Bước 1: Chỉ show bottom sheet để chọn hành động
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColor.white,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: false,
      constraints: BoxConstraints(
        maxHeight: SizeConfig.height * 0.5,
        minHeight: SizeConfig.height * 0.2,
      ),
      builder: (ctx) {
        return BlocProvider(
          create: (context) => ImageActionCubit(),
          child: ImageActionModal(title: title, canPickFile: canPickFile),
        );
      },
    );

    // Bước 2: Sau khi modal đóng, mới mở camera hoặc gallery
    if (action == 'camera') {
      return await ImagePickerUtil.pickImageFromCamera();
    } else if (action == 'gallery') {
      return await ImagePickerUtil.pickImageFromGallery();
    } else if (action == 'file') {
      return await ImagePickerUtil.pickFile();
    }

    return null;
  }

  static Future<List<File>?> openBottomSheetMultipleImageFilePicker(
    BuildContext context, {
    required String title,
    bool canPickFile = false,
  }) async {
    // Bước 1: Chỉ show bottom sheet để chọn hành động
    final action = await showModalBottomSheet<String>(
      context: context,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: false,
      constraints: BoxConstraints(
        maxHeight: SizeConfig.height * 0.5,
        minHeight: SizeConfig.height * 0.2,
      ),
      builder: (ctx) {
        return BlocProvider(
          create: (context) => ImageActionCubit(),
          child: ImageActionModal(
            title: title,
            canPickFile: canPickFile,
            canMultipleFile: true,
          ),
        );
      },
    );

    // Bước 2: Sau khi modal đóng, mới mở camera hoặc gallery
    if (action == 'camera') {
      return await ImagePickerUtil.pickMultipleImageFromCamera();
    } else if (action == 'gallery') {
      return await ImagePickerUtil.pickMultipleImagesFromGallery();
    } else if (action == 'file') {
      return await ImagePickerUtil.pickMultipleFiles();
    }

    return null;
  }
}
