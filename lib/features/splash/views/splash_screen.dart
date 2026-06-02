import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../auth/bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoSlide;
  bool _animationDone = false;
  bool _didNavigate = false;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, .30, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: .78, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, .42, curve: Curves.easeOutBack),
      ),
    );
    _logoSlide = Tween<double>(begin: 0, end: -72).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.42, .78, curve: Curves.easeInOutCubic),
      ),
    );
    _controller.addListener(() {
      if (!_showText && _controller.value >= .58) {
        setState(() => _showText = true);
      }
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationDone = true;
        _goNext(context.read<AuthBloc>().state.status);
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) => _goNext(state.status),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: context.gradients.background),
          child: SafeArea(
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizedBox(
                    width: MediaQuery.sizeOf(context).width - 48,
                    height: 140,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final centerX = constraints.maxWidth / 2;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: Center(
                                child: Transform.translate(
                                  offset: Offset(_logoSlide.value, 0),
                                  child: FadeTransition(
                                    opacity: _logoOpacity,
                                    child: ScaleTransition(
                                      scale: _logoScale,
                                      child: Hero(
                                        tag: AppLogo.planifyLogoHeroTag,
                                        child: Assets.logo.logoNoBackground
                                            .image(
                                              width: 112,
                                              height: 112,
                                              fit: BoxFit.contain,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: centerX + 6,
                              right: 0,
                              top: 43,
                              child: _SplashText(show: _showText),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goNext(AuthStatus status) async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    if (!_animationDone || _didNavigate) {
      return;
    }
    if (status == AuthStatus.unknown || status == AuthStatus.loading) {
      return;
    }
    _didNavigate = true;
    final route = status == AuthStatus.authenticated
        ? Routes.home
        : Routes.signIn;
    context.go(route);
  }
}

class _SplashText extends StatelessWidget {
  const _SplashText({required this.show});

  final bool show;

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedTextKit(
          totalRepeatCount: 1,
          isRepeatingAnimation: false,
          displayFullTextOnTap: false,
          animatedTexts: [
            TyperAnimatedText(
              'Planify',
              speed: const Duration(milliseconds: 70),
              textStyle: context.bold24(
                color: context.colors.onSurface,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedTextKit(
          totalRepeatCount: 1,
          isRepeatingAnimation: false,
          displayFullTextOnTap: false,
          animatedTexts: [
            TyperAnimatedText(
              'Plan your vacation, plan your life',
              speed: const Duration(milliseconds: 34),
              textStyle: context.semiBold14(
                color: context.colors.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
