part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.isLoading = false,
    this.isUploadingAvatar = false,
    this.profile,
    this.updatedUser,
    this.error = '',
  });

  final bool isLoading;
  final bool isUploadingAvatar;
  final UserProfile? profile;
  final AppUser? updatedUser;
  final String error;

  ProfileState copyWith({
    bool? isLoading,
    bool? isUploadingAvatar,
    UserProfile? profile,
    AppUser? updatedUser,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      profile: profile ?? this.profile,
      updatedUser: updatedUser ?? this.updatedUser,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isUploadingAvatar,
    profile,
    updatedUser,
    error,
  ];
}
