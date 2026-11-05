import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/support_resources_response_model.dart';
import 'providers/support_provider.dart';

/// Support Options Screen ("You don't have to go through this alone")
class SupportOptionsScreen extends ConsumerWidget {
  const SupportOptionsScreen({Key? key}) : super(key: key);

  static const List<SupportResourceItemModel> _defaultServices = [
    SupportResourceItemModel(
      id: 'emergency',
      name: 'Emergency',
      description: 'Police, fire, ambulance',
      number: '000',
    ),
    SupportResourceItemModel(
      id: 'lifeline',
      name: 'Lifeline',
      description: '24/7 crisis support',
      number: '13 11 14',
    ),
    SupportResourceItemModel(
      id: 'beyondblue',
      name: 'Beyond Blue',
      description: 'Support for anxiety and depression',
      number: '1300 22 4636',
    ),
    SupportResourceItemModel(
      id: '13yarn',
      name: '13YARN',
      description: 'Crisis support for Aboriginal and Torres Strait Islander people',
      number: '13 92 76',
    ),
    SupportResourceItemModel(
      id: 'kidshelpline',
      name: 'Kids Helpline',
      description: 'Support for young people aged 5 to 25',
      number: '1800 55 1800',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportAsync = ref.watch(supportResourcesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: supportAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(supportResourcesProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              child: _buildBody(
                context,
                resources: _defaultServices,
                note: null,
              ),
            ),
          ),
          data: (response) {
            final resources = response.resources.isNotEmpty
                ? response.resources
                : _defaultServices;

            return RefreshIndicator(
              onRefresh: () async {
                return ref.refresh(supportResourcesProvider.future);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                child: _buildBody(
                  context,
                  resources: resources,
                  note: response.note,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required List<SupportResourceItemModel> resources,
    String? note,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar: Back button & "GET HELP NOW" label
        Row(
          children: [
            CircularBackButton(
              isLightOnDark: false,
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.dashboard);
                }
              },
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
        ...resources.map(
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
    );
  }

  Widget _buildServiceCard(SupportResourceItemModel service) {
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
            service.number,
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
