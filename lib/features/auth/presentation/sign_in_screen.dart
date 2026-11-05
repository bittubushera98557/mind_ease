import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_banner.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/curved_header.dart';
import 'providers/auth_provider.dart';
import 'providers/auth_state.dart';

/// 1.04 Sign In Screen ("Sign In To MindEase")
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _localError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    // Dismiss soft/hardware keyboard cleanly before processing submission
    FocusManager.instance.primaryFocus?.unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _localError = 'Please enter both email and password.';
      });
      return;
    }

    setState(() {
      _localError = null;
    });

    final success = await ref.read(authNotifierProvider.notifier).login(
          email: email,
          password: password,
        );

    if (mounted && success) {
      context.go(RouteNames.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final bannerMessage = _localError ??
        (authState.status == AuthStatus.error ? authState.loginErrorMessage : null);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Terracotta Curved Wave Header
            CurvedHeader(
              height: 140,
              onBack: () {
                ref.read(authNotifierProvider.notifier).clearError();
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.welcome);
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    'Sign In To MindEase',
                    style: AppTypography.screenTitle,
                  ),
                  const SizedBox(height: 16),

                  // Error Alert Banner
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: bannerMessage != null
                        ? Padding(
                            key: ValueKey(bannerMessage),
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: AppBanner.error(
                              message: bannerMessage,
                              onClose: () {
                                setState(() {
                                  _localError = null;
                                });
                                ref.read(authNotifierProvider.notifier).clearError();
                              },
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey('emptyBanner')),
                  ),

                  // Email Address field
                  AppTextField(
                    key: const ValueKey('signInEmailField'),
                    label: 'Email Address',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) {
                      if (_localError != null) {
                        setState(() {
                          _localError = null;
                        });
                      }
                      if (authState.status == AuthStatus.error) {
                        ref.read(authNotifierProvider.notifier).clearError();
                      }
                    },
                  ),
                  const SizedBox(height: 14),

                  // Password field
                  AppTextField(
                    key: const ValueKey('signInPasswordField'),
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSignIn(),
                    onChanged: (_) {
                      if (_localError != null) {
                        setState(() {
                          _localError = null;
                        });
                      }
                      if (authState.status == AuthStatus.error) {
                        ref.read(authNotifierProvider.notifier).clearError();
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // "Sign In" Button
                  AppButton(
                    text: 'Sign In',
                    isLoading: isLoading,
                    onPressed: _handleSignIn,
                  ),
                  const SizedBox(height: 18),

                  // "Don't have an account? Sign up"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.footerRegular,
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(authNotifierProvider.notifier).clearError();
                          context.pushReplacement(RouteNames.signUp);
                        },
                        child: Text(
                          'Sign up',
                          style: AppTypography.linkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // "Forgot password" Link
                  GestureDetector(
                    onTap: () {
                      ref.read(authNotifierProvider.notifier).clearError();
                      context.push(RouteNames.forgotPassword);
                    },
                    child: Text(
                      'Forgot password',
                      style: AppTypography.linkText,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
