import 'package:app_core/app_core.dart';
import 'package:app_core/utils/image_utils.dart';

part 'image_action_state.dart';

class ImageActionCubit extends Cubit<ImageActionState> {
  ImageActionCubit() : super(const ImageActionState());

  Future<void> onPickImageFromCamera({required bool isMultiple}) async {
    try {
      emit(state.copyWith(status: ImageActionStatus.loading));

      if (isMultiple) {
        final files = await ImagePickerUtil.pickMultipleImageFromCamera();
        emit(state.copyWith(status: ImageActionStatus.success, files: files));
      } else {
        final file = await ImagePickerUtil.pickImageFromCamera();
        emit(state.copyWith(status: ImageActionStatus.success, files: file));
      }
    } catch (e) {
      emit(
        state.copyWith(status: ImageActionStatus.error, errorMsg: e.toString()),
      );
    }
  }

  Future<void> onPickImageFromGallery({required bool isMultiple}) async {
    try {
      emit(state.copyWith(status: ImageActionStatus.loading));

      if (isMultiple) {
        final files = await ImagePickerUtil.pickMultipleImagesFromGallery();
        emit(state.copyWith(status: ImageActionStatus.success, files: files));
      } else {
        final file = await ImagePickerUtil.pickImageFromGallery();
        emit(state.copyWith(status: ImageActionStatus.success, files: file));
      }
    } catch (e) {
      emit(
        state.copyWith(status: ImageActionStatus.error, errorMsg: e.toString()),
      );
    }
  }

  Future<void> onPickFile({required bool isMultiple}) async {
    try {
      emit(state.copyWith(status: ImageActionStatus.loading));

      if (isMultiple) {
        final files = await ImagePickerUtil.pickMultipleFiles();
        emit(state.copyWith(status: ImageActionStatus.success, files: files));
      } else {
        final file = await ImagePickerUtil.pickFile();
        emit(state.copyWith(status: ImageActionStatus.success, files: file));
      }
    } catch (e) {
      emit(
        state.copyWith(status: ImageActionStatus.error, errorMsg: e.toString()),
      );
    }
  }
}
