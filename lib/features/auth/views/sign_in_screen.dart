import 'package:app_core/app_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planify_mobile/app/router.dart';
import 'package:app_core/ui/theme.dart';

import '../../../app/theme_controller.dart';
import '../bloc/auth_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final bloc = context.read<AuthBloc>();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            LoadingDialog.hide(context);
            context.go(Routes.home);
            break;
          case AuthStatus.error:
            LoadingDialog.hide(context);
            AppWarningDialog.show(
              context: context,
              message: state.message ?? '',
            );
            break;
          case AuthStatus.loading:
            LoadingDialog.show(context);
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ThemeToggleButton(
                        themeMode: PlanifyThemeScope.of(context).themeMode,
                        onChanged: PlanifyThemeScope.of(context).setThemeMode,
                      ),
                    ),
                    Separator.spacer(60.h),
                    Center(
                      child: Assets.logo.logoNoBackground.image(width: 200.w),
                    ),
                    Separator.spacer(20.h),
                    Text('Planify', style: context.bold24()),
                    const SizedBox(height: 8),
                    Text(
                      'Plan everything, forget nothing.',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 32),
                    TextFormFieldComponent(
                      titleText: 'SĐT',
                      placeholder: 'Nhập vào số điện thoại',
                      onChanged: (value) => bloc.add(ChangePhone(value)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Số điện thoại không được để trống';
                        }
                        if (!value.isValidPhoneNumber()) {
                          return 'Số điện thoại không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    Separator.spacer(4.h),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return TextFormFieldComponent(
                          titleText: 'Mật khẩu',
                          placeholder: 'Nhập mật khẩu',
                          onChanged: (value) => bloc.add(ChangePassword(value)),
                          isPassword: true,
                          obscureText: state.isObsecure,
                          onToggleObscure: () => bloc.add(ChangeObsecure()),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mật khẩu không được để trống';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    Separator.spacer(10.h),
                    AppButton(
                      onTap: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        bloc.add(AuthPhone());
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10.w,
                        children: [
                          Text(
                            'Đăng nhập',
                            style: context.bold14(color: AppColor.white),
                          ),
                        ],
                      ),
                    ),
                    Separator.spacer(10.h),

                    // AppButton(
                    //   onTap: () => bloc.add(AuthGoogleSignInRequested()),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     mainAxisSize: MainAxisSize.min,
                    //     spacing: 10.w,
                    //     children: [
                    //       Assets.icon.google.svg(width: 20.w),
                    //       Text(
                    //         'Đăng nhập bằng Google',
                    //         style: context.bold14(color: AppColor.white),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                                  context.push(Routes.signUp);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
