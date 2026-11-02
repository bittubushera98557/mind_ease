import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/circular_back_button.dart';
import '../../data/models/legal_document_model.dart';

/// Dynamic View for Legal Documents (Privacy Policy & Terms of Use)
/// Matching exact font colors, sizes, weights, and layout tokens from design mockups.
class LegalDocumentView extends StatefulWidget {
  final LegalDocument document;

  const LegalDocumentView({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  State<LegalDocumentView> createState() => _LegalDocumentViewState();
}

class _LegalDocumentViewState extends State<LegalDocumentView> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    for (final section in widget.document.sections) {
      _sectionKeys[section.number] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int sectionNumber) {
    final key = _sectionKeys[sectionNumber];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Circular Back Button & Centered Header Tag (PRIVACY / TERMS)
              Row(
                children: [
                  CircularBackButton(
                    isLightOnDark: false,
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.document.headerTag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balances circular back button
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Document Main Title
              Text(
                widget.document.title,
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // Metadata Badges Row (Last Updated & Legal Review Status)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildBadge(
                    text: 'Last updated ${widget.document.lastUpdated}',
                    bgColor: const Color(0xFFFFF7E6),
                    borderColor: const Color(0xFFFFEAD0),
                    textColor: const Color(0xFF9A5B00),
                  ),
                  _buildBadge(
                    text: widget.document.reviewStatus,
                    bgColor: const Color(0xFFFEF3C7),
                    borderColor: const Color(0xFFFDE68A),
                    textColor: const Color(0xFFB45309),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Subtitle / Intro Text
              Text(
                widget.document.introText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // CONTENTS Box Card
              _buildContentsCard(),
              const SizedBox(height: AppSpacing.xl),

              // Section Items List
              ...widget.document.sections.map((section) {
                final key = _sectionKeys[section.number];
                return Padding(
                  key: key,
                  padding: const EdgeInsets.only(bottom: 22.0),
                  child: _buildSectionItem(section),
                );
              }),

              const SizedBox(height: 8),

              // Bottom Emergency / Crisis Banner Card
              _buildEmergencyBanner(context),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildContentsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTENTS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: const Color(0xFFD97706),
            ),
          ),
          const SizedBox(height: 10),
          ...widget.document.sections.map((sec) {
            return InkWell(
              onTap: () => _scrollToSection(sec.number),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Row(
                  children: [
                    Text(
                      '${sec.number}. ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.logoGreen,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        sec.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.logoGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionItem(LegalSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          '${section.number}. ${section.title}',
          style: GoogleFonts.outfit(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Body Paragraph
        if (section.body != null) ...[
          Text(
            section.body!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Bullets List
        if (section.bullets != null && section.bullets!.isNotEmpty) ...[
          ...section.bullets!.map((bullet) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•  ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                        children: [
                          if (bullet.prefix != null)
                            TextSpan(
                              text: bullet.prefix,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          TextSpan(text: bullet.text),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
        ],

        // Footer Note
        if (section.footerNote != null) ...[
          const SizedBox(height: 4),
          Text(
            section.footerNote!,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmergencyBanner(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push(RouteNames.supportOptions);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF6ED),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFC5E3C6)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.document.emergencyNotice,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF26682A),
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF26682A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
