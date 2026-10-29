import 'package:flutter/material.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_banner.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/curved_header.dart';

/// 1.04 Sign In Screen ("Sign In To MindEase")
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _isLoading = false;
  // Initially show the exact error banner from the mockup design
  String? _errorMessage =
      "We couldn't find an account with that email. Check it, or sign up.";

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'ramsy@hyperiontech.com');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate/call API
      await Future.delayed(const Duration(milliseconds: 900));

      if (mounted) {
        setState(() {
          _isLoading = false;
          // In real flow or demonstration, if email is invalid show banner
          _errorMessage =
              "We couldn't find an account with that email. Check it, or sign up.";
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Unable to connect. Please try again.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Terracotta Curved Wave Header
            CurvedHeader(
              height: 140,
              onBack: () => Navigator.of(context).maybePop(),
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

                  // Error / Warning Alert Banner
                  if (_errorMessage != null) ...[
                    AppBanner.error(
                      message: _errorMessage!,
                      onClose: () {
                        setState(() {
                          _errorMessage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Email Address field
                  AppTextField(
                    label: 'Email Address',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    prefixIcon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  // Password field (with valid/active green border as in mockup)
                  AppTextField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    state: AppTextFieldState.valid,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSignIn(),
                  ),
                  const SizedBox(height: 24),

                  // "Sign In  →" Button
                  AppButton(
                    text: 'Sign In',
                    isLoading: _isLoading,
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
                          Navigator.of(context).pushReplacementNamed(RouteNames.signUp);
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
                      Navigator.of(context).pushNamed(RouteNames.forgotPassword);
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
