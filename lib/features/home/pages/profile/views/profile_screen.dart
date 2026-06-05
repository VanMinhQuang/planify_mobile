import 'dart:io';

import 'package:app_core/ui/widgets/container/app_container.dart';
import 'package:app_core/ui/widgets/circle_app_image.dart';
import 'package:app_core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/router.dart';
import '../../../../auth/bloc/auth_bloc.dart';
import '../bloc/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    if (user != null) {
      context.read<ProfileCubit>().load(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.select((AuthBloc bloc) => bloc.state.user);
    return AppContainer(
      canGoBack: false,
      appBarTitle: 'User',
      iconRight: IconButton(
        tooltip: 'Settings',
        onPressed: () => context.push(Routes.settings),
        icon: const Icon(Icons.settings_outlined),
      ),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) =>
            previous.updatedUser != current.updatedUser,
        listener: (context, state) {
          final user = state.updatedUser;
          if (user != null) {
            context.read<AuthBloc>().add(AuthUserChanged(user));
          }
        },
        builder: (context, state) {
          final profileUser = state.profile?.user ?? authUser;
          return RefreshIndicator(
            onRefresh: () async {
              final user = context.read<AuthBloc>().state.user;
              if (user != null) {
                await context.read<ProfileCubit>().load(user.id);
              }
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAppImage(
                        radius: 48,
                        imageUrl: profileUser?.avatarUrl,
                        name: profileUser?.name,
                        fallbackIcon: Icons.person_outline,
                      ),
                      IconButton.filled(
                        tooltip: 'Change avatar',
                        onPressed: state.isUploadingAvatar
                            ? null
                            : () => _pickAvatar(context),
                        icon: state.isUploadingAvatar
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.camera_alt_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profileUser?.name.isNotEmpty == true
                      ? profileUser!.name
                      : 'Planify user',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  profileUser?.email.isNotEmpty == true
                      ? profileUser!.email
                      : profileUser?.phone ?? '',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.people_outline),
                    title: const Text('Friends'),
                    subtitle: const Text('View friends and requests'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(Routes.friends),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Plans', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if ((state.profile?.plans ?? []).isEmpty)
                  const ListTile(
                    leading: Icon(Icons.map_outlined),
                    title: Text('No visible plans yet'),
                  )
                else
                  ...state.profile!.plans.map(
                    (plan) => Card(
                      child: ListTile(
                        title: Text(plan.title),
                        subtitle: Text(
                          '${plan.startDate?.toDDMMYYYY()} - ${plan.endDate?.toDDMMYYYY()}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.push(Routes.planDetailPath(plan.id)),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (picked == null || !context.mounted) {
      return;
    }
    await context.read<ProfileCubit>().uploadAvatar(File(picked.path));
  }
}
