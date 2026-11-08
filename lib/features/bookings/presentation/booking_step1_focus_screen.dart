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
import '../data/models/therapist_based_available_slots_resp.dart';
import '../data/models/therapists_list_resp.dart';
import 'providers/bookings_provider.dart';
import 'providers/therapists_provider.dart';

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

  final List<String> _focusOptions = const [
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

  String _formatSlotTime(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final monthName = months[date.month - 1];
    final hour =
        date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'pm' : 'am';
    return '${date.day} $monthName, $hour:$minute $period';
  }

  String _formatSlotHour(DateTime date) {
    final hour =
        date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(bookingFormNotifierProvider);
    final formNotifier = ref.read(bookingFormNotifierProvider.notifier);
    final therapistsAsync = ref.watch(therapistsListProvider);

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

              // Focus Chips Wrap
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _focusOptions.map((option) {
                  final isSelected =
                      formState.selectedFocusAreas.contains(option);
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
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

              // Dynamic Therapist & Available Slots Section (Bound to GET /therapists index 0 & GET /therapists/{id}/slots)
          //    _buildDynamicTherapistCard(therapistsAsync, formState, formNotifier),
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

  Widget _buildDynamicTherapistCard(
    AsyncValue<TherapistsListResp> therapistsAsync,
    BookingFormState formState,
    BookingFormNotifier formNotifier,
  ) {
    return therapistsAsync.when(
      data: (therapistsResp) {
        if (therapistsResp.therapists.isEmpty) {
          return const SizedBox.shrink();
        }

        // Show index 0 therapist as requested
        final therapist = therapistsResp.therapists[0];

        // Store selected therapist in state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (formState.selectedTherapist?.id != therapist.id) {
            formNotifier.updateTherapist(therapist);
          }
        });

        final slotsAsync = ref.watch(therapistSlotsProvider(therapist.id));

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MATCHED THERAPIST',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: const Color(0xFFB45309),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Index 0',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  // Avatar Image / Initials
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2EFE0),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: therapist.photoUrl != null &&
                              therapist.photoUrl!.isNotEmpty
                          ? Image.network(
                              therapist.photoUrl!,
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(
                                  therapist.initials,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF26682A),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                therapist.initials,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF26682A),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Therapist Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          therapist.name,
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${therapist.sessionMinutes} min session • ${therapist.formattedPrice}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (therapist.timezone != null &&
                            therapist.timezone!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            therapist.timezone!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              if (therapist.bio != null && therapist.bio!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  therapist.bio!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
              const SizedBox(height: 12),

              // Available Slots Section
              Text(
                'AVAILABLE SLOTS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 10),

              slotsAsync.when(
                data: (slotsResp) {
                  if (slotsResp.slots.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'No available slots found for this therapist.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    );
                  }

                  final morning = slotsResp.slots
                      .where((s) => s.startsAt.hour < 12)
                      .toList();
                  final afternoon = slotsResp.slots
                      .where((s) =>
                          s.startsAt.hour >= 12 && s.startsAt.hour < 17)
                      .toList();
                  final evening = slotsResp.slots
                      .where((s) => s.startsAt.hour >= 17)
                      .toList();

                  Widget buildGroup(String title, List<Slot> groupSlots) {
                    if (groupSlots.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 6),
                          child: Text(
                            title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: groupSlots.map((slot) {
                            final timeStr = _formatSlotTime(slot.startsAt);
                            final isSelected =
                                formState.selectedSlotObj?.startsAt ==
                                    slot.startsAt;

                            return ChoiceChip(
                              label: Text(timeStr),
                              selected: isSelected,
                              onSelected: (_) {
                                formNotifier.updateSlotObj(slot);
                                formNotifier.updateTimeSlot(
                                    _formatSlotHour(slot.startsAt));
                              },
                              selectedColor: AppColors.textPrimary,
                              backgroundColor: const Color(0xFFF4EFEA),
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (morning.isNotEmpty) buildGroup('MORNING', morning),
                      if (afternoon.isNotEmpty)
                        buildGroup('AFTERNOON', afternoon),
                      if (evening.isNotEmpty) buildGroup('EVENING', evening),
                    ],
                  );
                },
                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Loading available slots...',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'Failed to load slots',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
