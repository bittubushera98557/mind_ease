import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import 'providers/bookings_provider.dart';

/// 5.04 Book a Session: Step 2 of 3 – Pick a Date and Time
class BookingStep2DateTimeScreen extends ConsumerStatefulWidget {
  const BookingStep2DateTimeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookingStep2DateTimeScreen> createState() =>
      _BookingStep2DateTimeScreenState();
}

class _BookingStep2DateTimeScreenState
    extends ConsumerState<BookingStep2DateTimeScreen> {
  final List<String> _morningSlots = const ['9:00 am', '10:00 am', '11:00 am'];
  final List<String> _afternoonSlots = const ['1:00 pm', '2:00 pm', '4:00 pm'];
  final List<String> _eveningSlots = const ['6:00 pm'];

  String _formatDate(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '$dayName ${date.day} $monthName';
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(bookingFormNotifierProvider);
    final formNotifier = ref.read(bookingFormNotifierProvider.notifier);

    final selectedDate = formState.selectedDate;
    final selectedSlot = formState.selectedTimeSlot;

    final formattedDateStr = _formatDate(selectedDate);

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
                        'BOOK A SESSION  •  STEP 2 OF 3',
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
              const SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                'Pick a date and time',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // YOUR THERAPIST Card
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
                      'YOUR THERAPIST',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE2EFE0),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'PN',
                              style: GoogleFonts.outfit(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF26682A),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr Priya Nair',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Clinical Psychologist • 50 min video (FEE)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Matched on ${formState.selectedFocusAreas.join(", ")}. Assigned automatically.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Calendar Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    // Month Navigation Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.textSecondary,
                        ),
                        Text(
                          'November 2024',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Days of Week Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                        return SizedBox(
                          width: 32,
                          child: Center(
                            child: Text(
                              day,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),

                    // Days Grid (Interactive)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 30,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        final dayNum = index + 1;
                        final isSelected = selectedDate.day == dayNum;

                        return InkWell(
                          onTap: () {
                            formNotifier.updateDate(
                              DateTime(2024, 11, dayNum),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$dayNum',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Time Slots Header
              _buildSlotSectionHeader(
                  '${formattedDateStr.toUpperCase()}  •  MORNING'),
              const SizedBox(height: 8),
              _buildSlotRow(_morningSlots, selectedSlot, formNotifier),
              const SizedBox(height: 16),

              _buildSlotSectionHeader('AFTERNOON'),
              const SizedBox(height: 8),
              _buildSlotRow(_afternoonSlots, selectedSlot, formNotifier),
              const SizedBox(height: 16),

              _buildSlotSectionHeader('EVENING'),
              const SizedBox(height: 8),
              _buildSlotRow(_eveningSlots, selectedSlot, formNotifier),
              const SizedBox(height: AppSpacing.xl),

              // Hold Time Note Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Times shown in AEDT (your device time zone). We hold your slot for 10 minutes while you finish booking.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Continue Button
              AppButton(
                text: 'Continue - $formattedDateStr, $selectedSlot',
                fontSize: 10,
                onPressed: () {
                  context.push(RouteNames.bookingReviewPay);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlotSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.textTertiary,
      ),
    );
  }

  Widget _buildSlotRow(
    List<String> slots,
    String selectedSlot,
    BookingFormNotifier formNotifier,
  ) {
    return Row(
      children: slots.map((slot) {
        final isSelected = slot == selectedSlot;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: () => formNotifier.updateTimeSlot(slot),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.inputBorder,
                  ),
                ),
                child: Center(
                  child: Text(
                    slot,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
