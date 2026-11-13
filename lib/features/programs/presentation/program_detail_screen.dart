import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/program_detail_response_model.dart';
import 'providers/programs_provider.dart';

/// Program Detail / Overview Screen matching design screenshots, dynamically bound to GET /programs/{programId}
class ProgramDetailScreen extends ConsumerWidget {
  final String programId;

  const ProgramDetailScreen({
    Key? key,
    this.programId = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (programId.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularBackButton(
              onPressed: () => context.pop(),
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Program ID not provided',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    final detailAsync = ref.watch(programDetailProvider(programId));

    return detailAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (err, stack) => _buildErrorState(context, ref, err.toString()),
      data: (detail) {
        if (!detail.isSuccess) {
          return _buildErrorState(
            context,
            ref,
            detail.error?.message ?? 'Failed to load program detail',
          );
        }

        // Calculate progress metrics across all phases directly from GET /programs/{programId}
        int totalProgramDone = 0;
        int totalProgramTotal = 0;
        int completedPhasesCount = 0;
        int activePhaseNumber = 1;
        bool foundActivePhase = false;
        bool previousPhaseCompleted = true;

        final phases = detail.phases;
        final phaseProgressList = <_PhaseProgressStats>[];

        for (int i = 0; i < phases.length; i++) {
          final phase = phases[i];
          final lessonsDone = phase.lessons.where((l) => l.isRead).length;
          final lessonsTotal = phase.lessons.length;
          final videosDone = phase.videos.where((v) => v.isVideoWatched).length;
          final videosTotal = phase.videos.length;
          final activityDone = phase.activity?.isCompleted == true ? 1 : 0;
          final activityTotal = phase.activity != null ? 1 : 0;
          final quizDone = phase.quiz?.isCompleted == true ? 1 : 0;
          final quizTotal = phase.quiz != null ? 1 : 0;

          final phaseDone = lessonsDone + videosDone + activityDone + quizDone;
          final phaseTotal = lessonsTotal + videosTotal + activityTotal + quizTotal;

          final isUnlocked = i == 0 ||
              phase.unlockRequirements?.previousPhaseCompleted == true ||
              previousPhaseCompleted;

          final isCompleted = (phaseTotal > 0 && phaseDone >= phaseTotal) ||
              phase.quiz?.isCompleted == true;

          previousPhaseCompleted = isCompleted;

          if (isCompleted) {
            completedPhasesCount++;
          } else if (!foundActivePhase && isUnlocked) {
            activePhaseNumber = phase.number > 0 ? phase.number : i + 1;
            foundActivePhase = true;
          }

          totalProgramDone += phaseDone;
          totalProgramTotal += phaseTotal;

          phaseProgressList.add(_PhaseProgressStats(
            phase: phase,
            phaseNumber: phase.number > 0 ? phase.number : i + 1,
            isUnlocked: isUnlocked,
            isCompleted: isCompleted,
            itemsDone: phaseDone,
            itemsTotal: phaseTotal,
          ));
        }

        final double progressRatio = totalProgramTotal > 0
            ? (totalProgramDone / totalProgramTotal)
            : 0.0;
        final int progressPercentage = (progressRatio * 100).toInt();
        final userPoints = _calculateDefaultPoints(detail);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(programDetailProvider(programId).future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Terracotta Header with progress details
                  _buildHeader(
                    context,
                    detail,
                    userPoints: userPoints,
                    activePhaseNumber: activePhaseNumber,
                    progressPercentage: progressPercentage,
                    progressRatio: progressRatio,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Overview description paragraph
                        if ((detail.intro ?? detail.short).isNotEmpty)
                          Text(
                            detail.intro ?? detail.short,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        if ((detail.intro ?? detail.short).isNotEmpty)
                          const SizedBox(height: 24),

                        // WHAT YOU'LL LEARN Card
                        if (detail.learn.isNotEmpty)
                          _buildWhatYouLearnCard(detail.learn)
                        else
                          _buildDefaultWhatYouLearnCard(),

                        const SizedBox(height: 24),

                        // Phases Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phases',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '$completedPhasesCount of ${phases.isNotEmpty ? phases.length : 4} complete',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Render phases dynamically
                        if (phaseProgressList.isNotEmpty)
                          ...List.generate(phaseProgressList.length, (index) {
                            final stats = phaseProgressList[index];

                            if (stats.isUnlocked) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildActivePhaseCard(
                                  context,
                                  stats.phase,
                                  programId: detail.id,
                                  itemsDone: stats.itemsDone,
                                  itemsTotal: stats.itemsTotal,
                                  isCompleted: stats.isCompleted,
                                ),
                              );
                            } else {
                              final prevNumber = index > 0
                                  ? phaseProgressList[index - 1].phaseNumber
                                  : index;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildLockedPhaseCard(
                                  context,
                                  phase: stats.phase,
                                  number: stats.phaseNumber,
                                  title: stats.phase.title,
                                  unlockMessage:
                                      'Complete Phase $prevNumber to unlock Phase ${stats.phaseNumber}.',
                                ),
                              );
                            }
                          })
                        else ...[
                          _buildDefaultActivePhaseCard(context),
                          const SizedBox(height: 12),
                          _buildDefaultLockedPhaseCard(
                            context,
                            number: 2,
                            title: 'Check Yourself, Kindly',
                            unlockMessage:
                                'Complete Phase 1 to unlock Phase 2.',
                          ),
                          const SizedBox(height: 12),
                          _buildDefaultLockedPhaseCard(
                            context,
                            number: 3,
                            title: 'Safe to Feel, Safe to Speak',
                            unlockMessage:
                                'Complete Phase 2 to unlock Phase 3.',
                          ),
                          const SizedBox(height: 12),
                          _buildDefaultLockedPhaseCard(
                            context,
                            number: 4,
                            title: 'Mental Health First Aid',
                            unlockMessage:
                                'Complete Phase 3 to unlock Phase 4.',
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Disclaimer
                        Text(
                          detail.disclaimer ??
                              'This program is educational. It isn’t a diagnosis, a treatment, or an accredited Mental Health First Aid course.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textTertiary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int _calculateDefaultPoints(ProgramDetailResponseModel detail) {
    int totalPts = 0;
    for (var phase in detail.phases) {
      if (phase.pointsAwarded != null) {
        totalPts += phase.pointsAwarded!;
      }
    }
    return totalPts;
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularBackButton(
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.alertErrorIcon,
              ),
              const SizedBox(height: 16),
              Text(
                error,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(programDetailProvider(programId));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ProgramDetailResponseModel detail, {
    required int userPoints,
    required int activePhaseNumber,
    required int progressPercentage,
    required double progressRatio,
  }) {
    final title = detail.title.isNotEmpty
        ? detail.title
        : 'Mental Health First Aid\nSelf-Reflection Program';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 12,
        20,
        28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar: Back button & pts badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircularBackButton(
                isLightOnDark: true,
                onPressed: () => context.pop(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_outline_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$userPoints pts',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          Text(
            'PROGRAM',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 18),

          // Progress text & bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Currently on Phase $activePhaseNumber',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                '$progressPercentage%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressRatio.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatYouLearnCard(List<String> learnItems) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHAT YOU\'LL LEARN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 12),
          ...learnItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: _bulletPoint(item),
              )),
        ],
      ),
    );
  }

  Widget _buildDefaultWhatYouLearnCard() {
    return _buildWhatYouLearnCard(const [
      'What mental health is and how it shows up in your body, thoughts and habits',
      'How to spot early changes in yourself and others',
      'Why feelings get hidden, and safer ways to express them',
      'How to check in with someone and connect them to support',
    ]);
  }

  Widget _bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 5, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivePhaseCard(
    BuildContext context,
    ProgramPhaseModel phase, {
    String? programId,
    int itemsDone = 0,
    int itemsTotal = 8,
    bool isCompleted = false,
  }) {
    final phaseNum = phase.number > 0 ? phase.number : 1;
    final totalDisplay = itemsTotal > 0 ? itemsTotal : 8;
    final progressVal = (totalDisplay > 0 ? (itemsDone / totalDisplay) : 0.0).clamp(0.0, 1.0);

    final statusText = isCompleted
        ? 'Completed'
        : (itemsDone > 0 ? 'In progress' : 'Ready to start');

    return GestureDetector(
      onTap: () => context.push(
        RouteNames.phaseDetail,
        extra: {
          'phase': phase,
          'programId': programId,
          'phaseNumber': phaseNum,
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF88A75E),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$phaseNum',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'PHASE $phaseNum',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFFDFEEDF)
                              : const Color(0xFFFDF1EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          statusText,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: isCompleted
                                ? const Color(0xFF4C7B3B)
                                : AppColors.primary,
                          ),
                        ),
                      ),
                      if (!isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF1EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "You're here",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              phase.title.isNotEmpty ? phase.title : "How's Your Head, Really?",
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$itemsDone of $totalDisplay items done',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressVal,
                minHeight: 5,
                backgroundColor: const Color(0xFFE8E2DA),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultActivePhaseCard(BuildContext context) {
    return _buildActivePhaseCard(
      context,
      const ProgramPhaseModel(
        number: 1,
        title: "How's Your Head, Really?",
      ),
    );
  }

  Widget _buildLockedPhaseCard(
    BuildContext context, {
    ProgramPhaseModel? phase,
    required int number,
    required String title,
    required String unlockMessage,
  }) {
    return GestureDetector(
      onTap: () => context.push(
        RouteNames.phaseDetail,
        extra: {
          if (phase != null) 'phase': phase,
          'phaseNumber': number,
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F2EE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC8BFB6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'PHASE $number',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFECE8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Locked',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 13,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  unlockMessage,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultLockedPhaseCard(
    BuildContext context, {
    required int number,
    required String title,
    required String unlockMessage,
  }) {
    return _buildLockedPhaseCard(
      context,
      number: number,
      title: title,
      unlockMessage: unlockMessage,
    );
  }
}

class _PhaseProgressStats {
  final ProgramPhaseModel phase;
  final int phaseNumber;
  final bool isUnlocked;
  final bool isCompleted;
  final int itemsDone;
  final int itemsTotal;

  const _PhaseProgressStats({
    required this.phase,
    required this.phaseNumber,
    required this.isUnlocked,
    required this.isCompleted,
    required this.itemsDone,
    required this.itemsTotal,
  });
}
