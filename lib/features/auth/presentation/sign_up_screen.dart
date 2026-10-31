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

/// 1.03 Sign Up Screen ("Sign Up For Free")
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  // Field validation errors
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _bannerError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    bool isValid = true;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      if (name.isEmpty) {
        _nameError = 'Enter your name.';
        isValid = false;
      } else {
        _nameError = null;
      }

      if (email.isEmpty) {
        _emailError = 'Enter your email address.';
        isValid = false;
      } else if (!emailRegex.hasMatch(email)) {
        _emailError = 'Enter a valid email address.';
        isValid = false;
      } else {
        _emailError = null;
      }

      if (password.isEmpty) {
        _passwordError = 'Enter your password.';
        isValid = false;
      } else if (password.length < 6) {
        _passwordError = 'Use at least 6 characters.';
        isValid = false;
      } else {
        _passwordError = null;
      }

      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Confirm your password.';
        isValid = false;
      } else if (confirmPassword != password) {
        _confirmPasswordError = 'Passwords do not match.';
        isValid = false;
      } else {
        _confirmPasswordError = null;
      }
    });

    return isValid;
  }

  Future<void> _handleSignUp() async {
    setState(() {
      _bannerError = null;
    });

    if (!_validateForm()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await ref.read(authNotifierProvider.notifier).register(
          name: name,
          email: email,
          password: password,
        );

    if (mounted) {
      if (success) {
        context.go(RouteNames.questionnaireIntro, extra: name);
      } else {
        final authState = ref.read(authStateProvider);
        if (authState.status == AuthStatus.error) {
          setState(() {
            if (authState.errorField == 'email' || authState.errorCode == 'email_taken') {
              _emailError = authState.errorMessage;
            } else if (authState.errorField == 'name') {
              _nameError = authState.errorMessage;
            } else if (authState.errorField == 'password') {
              _passwordError = authState.errorMessage;
            } else {
              _bannerError = authState.errorMessage;
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Terracotta Curved Wave Header with Back Button and Logo
            CurvedHeader(
              height: 140,
              onBack: () => context.pop(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),

                    // Screen Title
                    Text(
                      'Sign Up For Free',
                      style: AppTypography.screenTitle,
                    ),
                    const SizedBox(height: 20),

                    // Error Alert Banner
                    if (_bannerError != null) ...[
                      AppBanner.error(
                        message: _bannerError!,
                        onClose: () {
                          setState(() {
                            _bannerError = null;
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                    ],

                    // Your Name field
                    AppTextField(
                      label: 'Your Name',
                      hintText: 'Enter your name',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline_rounded,
                      errorText: _nameError,
                      state: _nameError != null
                          ? AppTextFieldState.error
                          : AppTextFieldState.normal,
                      onChanged: (val) {
                        if (_nameError != null && val.trim().isNotEmpty) {
                          setState(() {
                            _nameError = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Email Address field
                    AppTextField(
                      label: 'Email Address',
                      hintText: 'Enter your email',
                      controller: _emailController,
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                      state: _emailError != null
                          ? AppTextFieldState.error
                          : AppTextFieldState.normal,
                      onChanged: (val) {
                        if (_emailError != null && val.trim().isNotEmpty) {
                          setState(() {
                            _emailError = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Password field
                    AppTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      errorText: _passwordError,
                      state: _passwordError != null
                          ? AppTextFieldState.error
                          : AppTextFieldState.normal,
                      onChanged: (val) {
                        if (_passwordError != null && val.trim().isNotEmpty) {
                          setState(() {
                            _passwordError = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Password Confirmation field
                    AppTextField(
                      label: 'Password Confirmation',
                      hintText: 'Re-enter your password',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      errorText: _confirmPasswordError,
                      state: _confirmPasswordError != null
                          ? AppTextFieldState.error
                          : AppTextFieldState.normal,
                      textInputAction: TextInputAction.done,
                      onChanged: (val) {
                        if (_confirmPasswordError != null && val.trim().isNotEmpty) {
                          setState(() {
                            _confirmPasswordError = null;
                          });
                        }
                      },
                      onSubmitted: (_) => _handleSignUp(),
                    ),
                    const SizedBox(height: 24),

                    // "Sign Up" Button
                    AppButton(
                      text: 'Sign Up',
                      isLoading: isLoading,
                      onPressed: _handleSignUp,
                    ),
                    const SizedBox(height: 16),

                    // "Already have an account? Sign in" Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTypography.footerRegular,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pushReplacement(RouteNames.signIn);
                          },
                          child: Text(
                            'Sign in',
                            style: AppTypography.linkText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
