part of 'image_action_cubit.dart';

enum ImageActionStatus { init, loading, success, error }

class ImageActionState extends Equatable {
  final ImageActionStatus status;
  final String errorMsg;
  final Object? files;

  const ImageActionState({
    this.status = ImageActionStatus.init,
    this.errorMsg = '',
    this.files,
  });

  @override
  List<Object?> get props => [status, errorMsg, files];

  ImageActionState copyWith({
    ImageActionStatus? status,
    String? errorMsg,
    Object? files,
  }) {
    return ImageActionState(
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      files: files ?? this.files,
    );
  }
}
