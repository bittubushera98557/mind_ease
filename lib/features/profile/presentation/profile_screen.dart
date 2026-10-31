import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/providers/auth_provider.dart';

/// 2.04 Profile Screen
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    final userName = user?.name.isNotEmpty == true ? user!.name : 'Ramsy Saikrishna';
    final userEmail = user?.email.isNotEmpty == true ? user!.email : 'ramsy@hyperiontech.com';
    final userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'R';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header
            _buildHeader(context, userName, userEmail, userInitial),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Points Breakdown Card
                  _buildPointsCard(),
                  const SizedBox(height: 24),

                  // MY ACCOUNT Section
                  _buildSectionHeader('MY ACCOUNT'),
                  const SizedBox(height: 8),
                  _buildCardGroup([
                    _buildListTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Personal information',
                      subtitle: 'Name, email, password',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // MY ASSESSMENT Section
                  _buildSectionHeader('MY ASSESSMENT'),
                  const SizedBox(height: 8),
                  _buildCardGroup([
                    _buildListTile(
                      icon: Icons.auto_awesome_outlined,
                      title: 'View my suggestions',
                      subtitle: 'Completed 24/10/2024, 9:10',
                      onTap: () {
                        context.push(RouteNames.questionnaireResults);
                      },
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
                    _buildListTile(
                      icon: Icons.refresh_rounded,
                      title: 'Retake questionnaire',
                      subtitle: 'Update your answers and focus phases',
                      onTap: () {
                        context.push(RouteNames.questionnaireIntro);
                      },
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // SUPPORT AND PRIVACY Section
                  _buildSectionHeader('SUPPORT AND PRIVACY'),
                  const SizedBox(height: 8),
                  _buildCardGroup([
                    _buildListTile(
                      icon: Icons.support_rounded,
                      title: 'Get help now',
                      subtitle: 'Emergency and 24/7 support lines',
                      onTap: () {
                        context.push(RouteNames.supportOptions);
                      },
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
                    _buildListTile(
                      icon: Icons.shield_outlined,
                      title: 'Privacy policy',
                      onTap: () {},
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
                    _buildListTile(
                      icon: Icons.article_outlined,
                      title: 'Terms of use',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // Privacy Lock Note
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Your reflections and answers are private to your account.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign Out Button
                  _buildCardGroup([
                    _buildListTile(
                      icon: Icons.logout_rounded,
                      title: 'Sign out',
                      titleColor: AppColors.textPrimary,
                      onTap: () {
                        ref.read(authNotifierProvider.notifier).logout();
                        context.go(RouteNames.signIn);
                      },
                    ),
                  ]),
                  const SizedBox(height: 16),

                  // Delete Account Link
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Delete account',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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

  Widget _buildHeader(
    BuildContext context,
    String name,
    String email,
    String initial,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 20,
        24,
        28,
      ),
      child: Column(
        children: [
          // Large Avatar Circle
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Name
          Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            email,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    final pointsList = [
      {'phase': "Phase 1: How's Your Head. Really?", 'pts': '+100'},
      {'phase': 'Phase 2: Check Yourself. Kindly', 'pts': '-'},
      {'phase': 'Phase 3: Safe to Feel. Safe to Speak', 'pts': '-'},
      {'phase': 'Phase 4: Mental Health First Aid', 'pts': '-'},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 20,
                color: Color(0xFFF4A261),
              ),
              const SizedBox(width: 8),
              Text(
                '100 points',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Earned by completing phases',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
          const SizedBox(height: 10),
          ...pointsList.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['phase']!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    item['pts']!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: item['pts'] == '+100'
                          ? const Color(0xFF7EAA83)
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: titleColor ?? AppColors.inputPrefixIcon,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
