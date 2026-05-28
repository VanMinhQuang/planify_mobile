import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planify_mobile/app/router.dart';
import 'package:planify_mobile/app/theme.dart';

import '../bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go(Routes.signIn),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        title: const Text('Dang ky'),
      ),
      body: SafeArea(
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state.status == SignUpStatus.success) {
              context.go(Routes.signIn);
            }
          },
          builder: (context, state) {
            final isLoading = state.status == SignUpStatus.loading;
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text('Tao tai khoan', style: context.bold24()),
                  const SizedBox(height: 8),
                  Text(
                    'Bat dau lap ke hoach thong minh cung Planify.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),
                  TextFormFieldComponent(
                    controller: _nameController,
                    titleText: 'Ho va ten',
                    placeholder: 'Nhap ho va ten',
                    isRequired: true,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Vui long nhap ho va ten'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormFieldComponent(
                    controller: _phoneController,
                    titleText: 'So dien thoai',
                    placeholder: 'Nhap so dien thoai',
                    keyboardType: TextInputType.phone,
                    isRequired: true,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Vui long nhap so dien thoai'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormFieldComponent(
                    controller: _passwordController,
                    titleText: 'Mat khau',
                    placeholder: 'Nhap mat khau',
                    isPassword: true,
                    obscureText: _obscurePassword,
                    isRequired: true,
                    onToggleObscure: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui long nhap mat khau';
                      }
                      if (value.length < 6) {
                        return 'Mat khau phai co it nhat 6 ky tu';
                      }
                      return null;
                    },
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
                  const SizedBox(height: 24),
                  AppButton(
                    onTap: isLoading ? null : _submit,
                    isDisabled: isLoading,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10.w,
                      children: [
                        if (isLoading)
                          SizedBox.square(
                            dimension: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColor.white,
                            ),
                          )
                        else
                          const Icon(
                            LucideIcons.userPlus,
                            color: AppColor.white,
                          ),
                        Text(
                          'Dang ky',
                          style: context.bold14(color: AppColor.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<SignUpBloc>().add(
      SignUpSubmitted(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }
}
