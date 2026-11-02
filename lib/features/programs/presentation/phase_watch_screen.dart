import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/program_detail_response_model.dart';

/// Phase Watch Screen dynamically displaying phase videos
class PhaseWatchScreen extends StatelessWidget {
  final List<PhaseVideoModel>? videos;
  final int phaseNumber;

  const PhaseWatchScreen({
    Key? key,
    this.videos,
    this.phaseNumber = 1,
  }) : super(key: key);

  static const List<_VideoData> _defaultVideos = [
    _VideoData(
      title: "Let's Redefine Mental Health",
      description:
          "Why mental health is something everyone has, not just a label for illness.",
      duration: "1:12",
      status: "Not started",
    ),
    _VideoData(
      title: "You're Not the Only One",
      description: "Struggling is common. A short look at why that matters.",
      duration: "1:05",
      status: "Not started",
    ),
    _VideoData(
      title: "Inner Shields: What Protects You?",
      description: "The everyday things that help protect your wellbeing.",
      duration: "1:24",
      status: "Not started",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final hasDynamicVideos = videos != null && videos!.isNotEmpty;
    final totalVideos = hasDynamicVideos ? videos!.length : _defaultVideos.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: Back button & "PHASE X - WATCH" label
              Row(
                children: [
                  CircularBackButton(
                    isLightOnDark: false,
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'PHASE $phaseNumber - WATCH',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance back button
                ],
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Watch',
                style: AppTypography.screenTitle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),

              // Description
              Text(
                '0 of $totalVideos videos watched. A video counts once you\'ve played 90% of it.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Video Cards
              if (hasDynamicVideos)
                ...List.generate(videos!.length, (index) {
                  final video = videos![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildDynamicVideoCard(
                      context,
                      video,
                      index + 1,
                      videos!.length,
                    ),
                  );
                })
              else
                ...List.generate(_defaultVideos.length, (index) {
                  final video = _defaultVideos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildVideoCard(
                      context,
                      video,
                      index,
                      _defaultVideos.length,
                    ),
                  );
                }),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicVideoCard(
    BuildContext context,
    PhaseVideoModel video,
    int videoNumber,
    int totalVideos,
  ) {
    String durationStr = "1:12";
    if (video.duration > 0) {
      final mins = video.duration ~/ 60;
      final secs = (video.duration % 60).toString().padLeft(2, '0');
      durationStr = '$mins:$secs';
    }

    return GestureDetector(
      onTap: () {
        context.push(
          RouteNames.videoDetail,
          extra: {
            'video': video,
            'videoNumber': videoNumber,
            'totalVideos': totalVideos,
            'videoTitle': video.title,
            'videoDescription': video.description ?? '',
            'duration': durationStr,
            'mediaUrl': video.mediaUrl,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.inputBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Red / Terracotta Video Thumbnail box with play icon & duration
            Container(
              width: 90,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        durationStr,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Video info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.25,
                    ),
                  ),
                  if (video.description != null && video.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      video.description!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    'Not started',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(
    BuildContext context,
    _VideoData video,
    int index,
    int total,
  ) {
    return GestureDetector(
      onTap: () {
        context.push(
          RouteNames.videoDetail,
          extra: {
            'videoNumber': index + 1,
            'totalVideos': total,
            'videoTitle': video.title,
            'videoDescription': video.description,
            'duration': video.duration,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.inputBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.duration,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    video.status,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoData {
  final String title;
  final String description;
  final String duration;
  final String status;

  const _VideoData({
    required this.title,
    required this.description,
    required this.duration,
    required this.status,
  });
}
