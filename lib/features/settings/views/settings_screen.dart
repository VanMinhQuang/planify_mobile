import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/theme_controller.dart';
import '../../auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    final themeController = PlanifyThemeScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                value: themeController.themeMode == ThemeMode.dark,
                onChanged: (value) => themeController.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                ),
                title: const Text('Dark theme'),
                secondary: const Icon(Icons.dark_mode_outlined),
              ),
              FutureBuilder<PackageInfo>(
                future: _packageInfo,
                builder: (context, snapshot) {
                  final info = snapshot.data;
                  return ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('App version'),
                    subtitle: Text(
                      info == null
                          ? 'Loading'
                          : '${info.version}+${info.buildNumber}',
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                onTap: () =>
                    context.read<AuthBloc>().add(AuthSignOutRequested()),
              ),
            ],
          );
        },
      ),
    );
  }
}
