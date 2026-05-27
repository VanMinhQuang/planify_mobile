import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: user?.avatarUrl == null
                ? null
                : NetworkImage(user!.avatarUrl!),
            child: user?.avatarUrl == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(height: 16),
          Text(
            user?.name ?? 'Planify user',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(user?.email ?? ''),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () =>
                context.read<AuthBloc>().add(AuthSignOutRequested()),
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
