import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/program_detail_response_model.dart';
import 'providers/programs_provider.dart';

/// Dynamic Phase Activity Screen rendering prompts & response types (text & chips_and_text)
class PhaseActivityScreen extends ConsumerStatefulWidget {
  final PhaseActivityModel? activity;
  final int phaseNumber;
  final String? programId;
  final String? phaseId;

  const PhaseActivityScreen({
    Key? key,
    this.activity,
    this.phaseNumber = 1,
    this.programId,
    this.phaseId,
  }) : super(key: key);

  @override
  ConsumerState<PhaseActivityScreen> createState() =>
      _PhaseActivityScreenState();
}

class _PhaseActivityScreenState extends ConsumerState<PhaseActivityScreen> {
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, Set<String>> _selectedChipsMap = {};

  bool _isSavingDraft = false;
  bool _isCompleting = false;

  late final List<PhaseActivityPromptModel> _prompts;

  @override
  void initState() {
    super.initState();
    if (widget.activity != null && widget.activity!.prompts.isNotEmpty) {
      _prompts = widget.activity!.prompts;
    } else {
      _prompts = const [
        PhaseActivityPromptModel(
          id: 'q1',
          q: "When you're feeling at your best, what do you notice in your body, thoughts and energy?",
          optional: true,
          responseType: 'text',
        ),
        PhaseActivityPromptModel(
          id: 'q2',
          q: 'What everyday things help you feel like yourself?',
          optional: true,
          responseType: 'chips_and_text',
          chips: [
            'Good sleep',
            'Walking outdoors',
            'Connecting with friends',
            'Reading',
            'Music',
            'Quiet time'
          ],
        ),
        PhaseActivityPromptModel(
          id: 'q3',
          q: 'What tends to make things harder for you?',
          optional: true,
          responseType: 'text',
        ),
        PhaseActivityPromptModel(
          id: 'q4',
          q: "What's one small thing you could do this week to look after your wellbeing?",
          optional: true,
          responseType: 'chips_and_text',
          chips: [
            'Set boundaries',
            'Rest more',
            'Drink water',
            'Journaling',
            'Mindful breathing'
          ],
        ),
      ];
    }

    for (int i = 0; i < _prompts.length; i++) {
      final prompt = _prompts[i];
      final savedText = prompt.savedText ?? '';
      final savedChips = prompt.savedChips;

      _controllers[i] = TextEditingController(text: savedText);
      _selectedChipsMap[i] = Set<String>.from(savedChips);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> _buildAnswersPayload() {
    final Map<String, dynamic> answers = {};

    for (int i = 0; i < _prompts.length; i++) {
      final prompt = _prompts[i];
      final qId = prompt.id.isNotEmpty ? prompt.id : 'q${i + 1}';
      final textVal = _controllers[i]?.text.trim() ?? '';
      final chipsList = _selectedChipsMap[i]?.toList() ?? [];

      final Map<String, dynamic> promptAnswer = {};
      if (chipsList.isNotEmpty) {
        promptAnswer['chips'] = chipsList;
      }
      if (textVal.isNotEmpty) {
        promptAnswer['text'] = textVal;
      }

      if (promptAnswer.isNotEmpty) {
        answers[qId] = promptAnswer;
      }
    }

    return answers;
  }

  Future<void> _submitActivity({required bool complete}) async {
    if (_isSavingDraft || _isCompleting) return;

    setState(() {
      if (complete) {
        _isCompleting = true;
      } else {
        _isSavingDraft = true;
      }
    });

    final programId = widget.programId?.isNotEmpty == true
        ? widget.programId!
        : 'mhfa';
    final activityId = widget.activity?.id.isNotEmpty == true
        ? widget.activity!.id
        : 'p1a';

    final answers = _buildAnswersPayload();

    try {
      final response = await ref
          .read(saveActivityNotifierProvider.notifier)
          .saveActivity(
            programId: programId,
            activityId: activityId,
            complete: complete,
            answers: answers,
          );
      debugPrint('Save Activity API Success response: $response');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            complete ? 'Activity completed!' : 'Draft saved',
            style: GoogleFonts.plusJakartaSans(),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      context.pop(complete);
    } catch (e) {
      debugPrint('Save Activity API Exception: $e');
      if (!mounted) return;
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save activity: $errorMessage',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingDraft = false;
          _isCompleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;
    final title = activity?.title.isNotEmpty == true
        ? activity!.title
        : 'What Does Good Mental Health Feel Like to You?';
    final purpose = activity?.purpose?.isNotEmpty == true
        ? activity!.purpose!
        : 'Build a picture of what feeling like yourself looks like, so you can notice when things change.';
    final instructions = activity?.instructions?.isNotEmpty == true
        ? activity!.instructions!
        : 'Answer as much or as little as you like. You can skip any question and come back later.';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar: Back button & "PHASE X · ACTIVITY" label
                    Row(
                      children: [
                        CircularBackButton(
                          isLightOnDark: false,
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'PHASE ${widget.phaseNumber} \u00b7 ACTIVITY',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Draft prompts tag if draft
                    if (activity?.isDraft == true || activity == null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.edit_outlined,
                              size: 12,
                              color: Color(0xFF856404),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'DRAFT PROMPTS',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF856404),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (activity?.isDraft == true || activity == null)
                      const SizedBox(height: 14),

                    // Main Title
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle / Why text
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Why: ',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: purpose,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 13.5, height: 1.45),
                    ),
                    const SizedBox(height: 20),

                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: Color(0xFF5A8F5A),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              instructions,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Question Cards
                    ...List.generate(_prompts.length, (index) {
                      final prompt = _prompts[index];
                      final controller = _controllers[index]!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPromptCard(
                          index + 1,
                          prompt,
                          controller,
                          index,
                        ),
                      );
                    }),

                    const SizedBox(height: 8),

                    // Privacy Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 18,
                            color: Color(0xFF5A8F5A),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Private to you. Reflections are never shared with other users or sent to analytics.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Actions (Save draft & Complete activity)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.inputBorder, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (_isSavingDraft || _isCompleting)
                          ? null
                          : () => _submitActivity(complete: false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.inputBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isSavingDraft
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              ),
                            )
                          : Text(
                              'Save draft',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_isSavingDraft || _isCompleting)
                          ? null
                          : () => _submitActivity(complete: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isCompleting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Complete activity',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
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

  Widget _buildPromptCard(
    int number,
    PhaseActivityPromptModel prompt,
    TextEditingController controller,
    int promptIndex,
  ) {
    final showChips =
        prompt.responseType == 'chips_and_text' || prompt.chips.isNotEmpty;
    final selectedChips = _selectedChipsMap[promptIndex] ?? {};

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header & number
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFECE8),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  prompt.q,
                  style: GoogleFonts.outfit(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Render Chips if responseType is chips_and_text or chips list exists
          if (showChips) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: prompt.chips.map((chipText) {
                final isSelected = selectedChips.contains(chipText);
                return FilterChip(
                  label: Text(chipText),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedChips.add(chipText);
                      } else {
                        selectedChips.remove(chipText);
                      }
                    });
                  },
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                  backgroundColor: AppColors.background,
                  selectedColor: AppColors.primary,
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.inputBorder,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Multiline Text Box
          TextField(
            controller: controller,
            maxLines: 3,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: showChips
                  ? 'Add any additional notes or comments...'
                  : 'Write as much or as little as you like',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            prompt.optional ? 'Optional · you can skip this' : 'Required',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
