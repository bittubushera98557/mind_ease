import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circular_back_button.dart';

/// Support Options Screen ("You don't have to go through this alone")
class SupportOptionsScreen extends StatelessWidget {
  const SupportOptionsScreen({Key? key}) : super(key: key);

  static const List<_SupportService> _services = [
    _SupportService(
      name: 'Emergency',
      description: 'Police, ambulance, fire. Immediate danger.',
      phoneNumber: '000',
    ),
    _SupportService(
      name: 'Lifeline',
      description: '24/7 crisis support',
      phoneNumber: '13 11 14',
    ),
    _SupportService(
      name: 'Beyond Blue',
      description: '24/7 support line',
      phoneNumber: '1300 22 4636',
    ),
    _SupportService(
      name: '13YARN',
      description: '24/7 support for Aboriginal and Torres Strait Islander people',
      phoneNumber: '13 92 76',
    ),
    _SupportService(
      name: 'Kids Helpline',
      description: '24/7, ages 5 to 25',
      phoneNumber: '1800 55 1800',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: Back button & "GET HELP NOW" label
              Row(
                children: [
                  CircularBackButton(
                    isLightOnDark: false,
                    onPressed: () => context.pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'GET HELP NOW',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                "You don't have to go through this alone",
                style: AppTypography.screenTitle.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Description
              Text(
                "If you or someone else is in immediate danger, call 000. For support any time, these services are free and confidential.",
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Services List
              ..._services.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildServiceCard(service),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Notice Card
              _buildNoticeCard(),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(_SupportService service) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: AppTypography.inputLabel.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  service.description,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 12.5,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            service.phoneNumber,
            style: AppTypography.inputLabel.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4F0),
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              "Australian services. If you're outside Australia, contact your local emergency number. MindEase is not a crisis service.",
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportService {
  final String name;
  final String description;
  final String phoneNumber;

  const _SupportService({
    required this.name,
    required this.description,
    required this.phoneNumber,
  });
}
