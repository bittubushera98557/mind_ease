import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/appointment_model.dart';
import 'providers/bookings_provider.dart';
import 'providers/focus_areas_provider.dart';

/// 5.03 Book a Session: Step 1 of 3 – Focus Areas & Therapist Selection
class BookingStep1FocusScreen extends ConsumerStatefulWidget {
  const BookingStep1FocusScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookingStep1FocusScreen> createState() =>
      _BookingStep1FocusScreenState();
}

class _BookingStep1FocusScreenState
    extends ConsumerState<BookingStep1FocusScreen> {
  late final TextEditingController _notesController;

  final List<String> _fallbackFocusOptions = const [
    'Stress',
    'Sleep',
    'Anxiety',
    'Low mood',
    'Work and burnout',
    'Relationships',
    'Grief and loss',
    'Life changes',
    'Not sure yet',
  ];

  @override
  void initState() {
    super.initState();
    final formState = ref.read(bookingFormNotifierProvider);
    _notesController = TextEditingController(text: formState.therapistNotes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildFocusChipsWrap(
    List<String> options,
    BookingFormState formState,
    BookingFormNotifier formNotifier,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = formState.selectedFocusAreas.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) {
            formNotifier.toggleFocusArea(option);
          },
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
          backgroundColor: Colors.white,
          selectedColor: AppColors.textPrimary,
          side: BorderSide(
            color: isSelected
                ? AppColors.textPrimary
                : AppColors.inputBorder,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          showCheckmark: false,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(bookingFormNotifierProvider);
    final formNotifier = ref.read(bookingFormNotifierProvider.notifier);
    final focusAreasAsync = ref.watch(focusAreasListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                children: [
                  CircularBackButton(
                    isLightOnDark: false,
                    onPressed: () => context.pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'BOOK A SESSION  •  STEP 1 OF 3',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 12),

              // Step Progress Indicators (3 Bars)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E2DA),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E2DA),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                'What would you like to focus on?',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                "Pick up to 3. We'll match you with a therapist who works in these areas.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Dynamic Focus Chips Wrap
              focusAreasAsync.when(
                data: (focusAreas) {
                  final options = focusAreas.isNotEmpty
                      ? focusAreas.map((f) => f.label).toList()
                      : _fallbackFocusOptions;

                  return _buildFocusChipsWrap(
                    options,
                    formState,
                    formNotifier,
                  );
                },
                loading: () => _buildFocusChipsWrap(
                  _fallbackFocusOptions,
                  formState,
                  formNotifier,
                ),
                error: (_, __) => _buildFocusChipsWrap(
                  _fallbackFocusOptions,
                  formState,
                  formNotifier,
                ),
              ),
              const SizedBox(height: 10),

              // Selection Counter Note
              Text(
                '${formState.selectedFocusAreas.length} of 3 selected  •  pre-filled from your questionnaire',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Optional Notes Text Box
              Text(
                "Anything you'd like your therapist to know? (optional)",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLength: 500,
                maxLines: 4,
                onChanged: (val) => formNotifier.updateNotes(val),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                      'For example: first time seeing someone, things that help, things to avoid',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textPlaceholder,
                  ),
                  filled: true,
                  fillColor: Colors.white,
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
              const SizedBox(height: AppSpacing.lg),

              // Mental Health Treatment Plan Question
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Do you have a Mental Health Treatment Plan from your GP?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: ['Yes', 'No', 'Not sure'].map((option) {
                        final isSelected =
                            formState.mentalHealthPlanOption == option;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: InkWell(
                              onTap: () =>
                                  formNotifier.updateMentalHealthPlan(option),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.textPrimary
                                      : const Color(0xFFF4EFEA),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    option,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "If yes, you'll upload the referral after booking so a Medicare rebate can be processed.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.textTertiary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Lock / Privacy Notice
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Only your assigned therapist sees these answers.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Find My Therapist Button
              AppButton(
                text: 'Find my therapist',
                onPressed: () {
                  context.push(RouteNames.bookingDateTime);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
