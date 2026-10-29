import 'package:flutter/material.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/curved_header.dart';

/// 1.03 Sign Up Screen ("Sign Up For Free")
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _isLoading = false;
  String? _nameError = 'Enter your name.'; // Match exact mockup state initially

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController(text: AppConstants.mockUserEmail);
    _passwordController = TextEditingController(text: 'secret123');
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

  Future<void> _handleSignUp() async {
    setState(() {
      if (_nameController.text.trim().isEmpty) {
        _nameError = 'Enter your name.';
      } else {
        _nameError = null;
      }
    });

    if (_nameError != null) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API sign up call
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      // After sign-up, navigate to the personalisation questionnaire
      Navigator.of(context).pushReplacementNamed(
        RouteNames.questionnaireIntro,
        arguments: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Terracotta Curved Wave Header with Back Button and Logo
            CurvedHeader(
              height: 140,
              onBack: () => Navigator.of(context).maybePop(),
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

                    // Your Name field (shows validation state from mockup)
                    AppTextField(
                      label: 'Your Name',
                      hintText: 'Enter your name',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline_rounded,
                      errorText: _nameError,
                      state: _nameError != null ? AppTextFieldState.error : AppTextFieldState.normal,
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
                    ),
                    const SizedBox(height: 14),

                    // Password field (shows validation state from mockup)
                    AppTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      errorText: 'Use at least 8 characters.',
                      state: AppTextFieldState.error,
                    ),
                    const SizedBox(height: 14),

                    // Password Confirmation field
                    AppTextField(
                      label: 'Password Confirmation',
                      hintText: 'Re-enter your password',
                      controller: _confirmPasswordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleSignUp(),
                    ),
                    const SizedBox(height: 24),

                    // "Sign Up  →" Button
                    AppButton(
                      text: 'Sign Up',
                      isLoading: _isLoading,
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
                            Navigator.of(context).pushReplacementNamed(RouteNames.signIn);
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
