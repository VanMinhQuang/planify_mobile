import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/app_user.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/repository/profile_repository.dart';
import '../../../domain/repository/upload_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileRepository profileRepository,
    required UploadRepository uploadRepository,
  }) : _profileRepository = profileRepository,
       _uploadRepository = uploadRepository,
       super(const ProfileState());

  final ProfileRepository _profileRepository;
  final UploadRepository _uploadRepository;

  Future<void> load(String userId) async {
    if (userId.isEmpty) {
      return;
    }
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final profile = await _profileRepository.getProfile(userId);
      emit(state.copyWith(isLoading: false, profile: profile));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<AppUser?> uploadAvatar(File file) async {
    emit(state.copyWith(isUploadingAvatar: true, error: ''));
    try {
      final avatarUrl = await _uploadRepository.uploadAvatar(file: file);
      final user = await _profileRepository.updateMe(avatarUrl: avatarUrl);
      final profile = state.profile == null
          ? null
          : UserProfile(
              user: user,
              friendship: state.profile!.friendship,
              plans: state.profile!.plans,
            );
      emit(
        state.copyWith(
          isUploadingAvatar: false,
          profile: profile,
          updatedUser: user,
        ),
      );
      return user;
    } catch (error) {
      emit(state.copyWith(isUploadingAvatar: false, error: error.toString()));
      return null;
    }
  }
}
