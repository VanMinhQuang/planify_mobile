import 'package:app_core/app_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planify_mobile/app/router.dart';
import 'package:planify_mobile/app/theme.dart';

import '../../../app/theme_controller.dart';
import '../bloc/auth_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ThemeToggleButton(
                      themeMode: PlanifyThemeScope.of(context).themeMode,
                      onChanged: PlanifyThemeScope.of(context).setThemeMode,
                    ),
                  ),
                  const Spacer(),
                  Text('Planify', style: context.bold24()),
                  const SizedBox(height: 8),
                  Text(
                    'Plan everything, forget nothing.',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10.w,
                      children: [
                        Icon(LucideIcons.phone, color: AppColor.white),
                        Text(
                          'Đăng nhập bằng Số điện thoại',
                          style: context.bold14(color: AppColor.white),
                        ),
                      ],
                    ),
                  ),
                  Separator.spacer(10.h),
                  AppButton(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10.w,
                      children: [
                        Assets.icon.google.svg(width: 20.w),
                        Text(
                          'Đăng nhập bằng Google',
                          style: context.bold14(color: AppColor.white),
                        ),
                      ],
                    ),
                  ),

                  if (state.message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      state.message!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],

                  Separator.spacer(15.h),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Bạn chưa có tài khoản? ",
                            style: context.normal12(),
                          ),
                          TextSpan(
                            text: 'Đăng ký',
                            style: context.semiBold14(
                              color: AppColor.planifyLavender,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go(Routes.signUp);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
