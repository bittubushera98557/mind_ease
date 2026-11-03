import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_banner.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/circular_back_button.dart';
import 'providers/auth_provider.dart';

/// 1.05 Forgot Password Screen dynamically calling POST /auth/password-reset
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  bool _isLoading = false;
  bool _showSuccessBanner = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address.';
        _showSuccessBanner = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _showSuccessBanner = false;
    });

    final success = await ref
        .read(authNotifierProvider.notifier)
        .sendPasswordResetEmail(email);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        setState(() {
          _showSuccessBanner = true;
          _errorMessage = null;
        });
      } else {
        final authState = ref.read(authStateProvider);
        setState(() {
          _showSuccessBanner = false;
          _errorMessage = authState.loginErrorMessage ??
              'Failed to send reset link. Please check your email and try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Circular Back Button at Top-Left
              CircularBackButton(
                isLightOnDark: false,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Forgot Password',
                style: AppTypography.screenTitle,
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                "Enter the email you signed up with and we'll send you a reset link.",
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Error Notification Banner
              if (_errorMessage != null) ...[
                AppBanner.error(
                  message: _errorMessage!,
                  onClose: () {
                    setState(() {
                      _errorMessage = null;
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Success Notification Banner
              if (_showSuccessBanner) ...[
                AppBanner.success(
                  message:
                      "If an account exists for that email, a reset link is on its way. Check your spam folder if it doesn't arrive in a few minutes.",
                  onClose: () {
                    setState(() {
                      _showSuccessBanner = false;
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Email Address Field
              AppTextField(
                key: const ValueKey('forgotPasswordEmailField'),
                label: 'Email Address',
                hintText: 'Enter your email',
                controller: _emailController,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleResetLink(),
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() {
                      _errorMessage = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 26),

              // "Send link / Resend link" Button
              AppButton(
                text: _showSuccessBanner ? 'Resend link' : 'Send link',
                isLoading: _isLoading,
                onPressed: _handleResetLink,
              ),
              const SizedBox(height: 20),

              // "Back to sign in" Footer Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.pushReplacement(RouteNames.signIn);
                  },
                  child: Text(
                    'Back to sign in',
                    style: AppTypography.linkText,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
