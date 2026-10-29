import 'package:flutter/material.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_banner.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/circular_back_button.dart';

/// 1.05 Forgot Password Screen
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  bool _isLoading = false;
  // Initially show the success banner from mockup
  bool _showSuccessBanner = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: AppConstants.mockUserEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetLink() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _showSuccessBanner = true;
      });
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
                label: 'Email Address',
                hintText: 'Enter your email',
                controller: _emailController,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleResetLink(),
              ),
              const SizedBox(height: 26),

              // "Resend link  →" Button
              AppButton(
                text: 'Resend link',
                isLoading: _isLoading,
                onPressed: _handleResetLink,
              ),
              const SizedBox(height: 20),

              // "Back to sign in" Footer Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(RouteNames.signIn);
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
