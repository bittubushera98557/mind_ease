import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/circular_back_button.dart';
import '../data/models/therapist_based_available_slots_resp.dart';
import '../data/models/therapists_list_resp.dart';
import 'providers/bookings_provider.dart';
import 'providers/therapists_provider.dart';

/// 5.04 Book a Session: Step 2 of 3 – Pick a Date and Time with Dynamic Calendar & Slots
class BookingStep2DateTimeScreen extends ConsumerStatefulWidget {
  const BookingStep2DateTimeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookingStep2DateTimeScreen> createState() =>
      _BookingStep2DateTimeScreenState();
}

class _BookingStep2DateTimeScreenState
    extends ConsumerState<BookingStep2DateTimeScreen> {
  late DateTime _displayedMonth;

  final List<String> _monthNames = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    final selected = ref.read(bookingFormNotifierProvider).selectedDate;
    _displayedMonth = DateTime(selected.year, selected.month, 1);
  }

  void _previousMonth() {
    final now = DateTime.now();
    final prevMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    final isBeforeCurrent = prevMonth.year < now.year ||
        (prevMonth.year == now.year && prevMonth.month < now.month);

    if (!isBeforeCurrent) {
      setState(() {
        _displayedMonth = prevMonth;
      });
    }
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

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

  String _formatSlotTime(DateTime date) {
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

    final therapist = formState.selectedTherapist ??
        (therapistsAsync.valueOrNull?.therapists.isNotEmpty == true
            ? therapistsAsync.valueOrNull!.therapists[0]
            : null);

    if (formState.selectedTherapist == null && therapist != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          formNotifier.updateTherapist(therapist);
        }
      });
    }

    final therapistId = therapist?.id ?? '';
    final slotsAsync = ref.watch(therapistSlotsProvider(therapistId));

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

              // Scrollable Therapists Selector Section
              _buildTherapistsSelectorSection(
                context,
                ref,
                therapistsAsync,
                therapist,
                formNotifier,
                formState.selectedFocusAreas,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Fully Dynamic Calendar Card
              _buildDynamicCalendarCard(selectedDate, formNotifier),
              const SizedBox(height: AppSpacing.xl),

              // Dynamic Slots Section for Selected Date (No Dummy Slots)
              _buildDynamicSlotsSection(
                selectedDate,
                formattedDateStr,
                slotsAsync,
                selectedSlot,
                formNotifier,
              ),
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
                text: selectedSlot.isNotEmpty
                    ? 'Continue - $formattedDateStr, $selectedSlot'
                    : 'Continue - $formattedDateStr',
                fontSize: 10,
                onPressed: selectedSlot.isNotEmpty
                    ? () {
                        context.push(RouteNames.bookingReviewPay);
                      }
                    : null,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicCalendarCard(
    DateTime selectedDate,
    BookingFormNotifier formNotifier,
  ) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final isCurrentMonth =
        _displayedMonth.year == now.year && _displayedMonth.month == now.month;

    final daysInMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final firstDayWeekday =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday;
    final startingOffset = firstDayWeekday - 1; // 1 = Monday
    final totalGridItems = startingOffset + daysInMonth;

    final monthTitle =
        '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          // Month & Year Navigation Header (< Month Year >)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: isCurrentMonth ? null : _previousMonth,
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: isCurrentMonth
                      ? AppColors.inputBorder
                      : AppColors.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                monthTitle,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Days of Week Row (M, T, W, T, F, S, S)
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

          // Dynamic Interactive Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalGridItems,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < startingOffset) {
                return const SizedBox.shrink();
              }

              final dayNum = index - startingOffset + 1;
              final dateForDay = DateTime(
                _displayedMonth.year,
                _displayedMonth.month,
                dayNum,
              );

              final isPast = dateForDay.isBefore(todayStart);

              final isSelected = selectedDate.year == _displayedMonth.year &&
                  selectedDate.month == _displayedMonth.month &&
                  selectedDate.day == dayNum;

              final isToday = dateForDay.year == now.year &&
                  dateForDay.month == now.month &&
                  dateForDay.day == now.day;

              return InkWell(
                onTap: isPast
                    ? null
                    : () {
                        formNotifier.updateDate(dateForDay);
                      },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: (!isSelected && isToday)
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNum',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : (isToday ? FontWeight.w700 : FontWeight.w500),
                        color: isSelected
                            ? Colors.white
                            : (isPast
                                ? AppColors.textPlaceholder
                                : AppColors.textPrimary),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicSlotsSection(
    DateTime selectedDate,
    String formattedDateStr,
    AsyncValue<TherapistBasedAvailableSlotsResp> slotsAsync,
    String selectedSlot,
    BookingFormNotifier formNotifier,
  ) {
    return slotsAsync.when(
      data: (slotsResp) {
        final apiSlots = slotsResp.slots;

        // Filter slots specifically for the selected date
        final daySlots = apiSlots.where((slot) =>
            slot.startsAt.year == selectedDate.year &&
            slot.startsAt.month == selectedDate.month &&
            slot.startsAt.day == selectedDate.day).toList();

        if (daySlots.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.event_busy_rounded,
                  size: 28,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: 8),
                Text(
                  'No slots available on $formattedDateStr',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please pick another date on the calendar above.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }

        final morningSlots =
            daySlots.where((s) => s.startsAt.hour < 12).toList();
        final afternoonSlots = daySlots
            .where((s) => s.startsAt.hour >= 12 && s.startsAt.hour < 17)
            .toList();
        final eveningSlots =
            daySlots.where((s) => s.startsAt.hour >= 17).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (morningSlots.isNotEmpty)
              _buildSlotSection(
                '${formattedDateStr.toUpperCase()}  •  MORNING',
                morningSlots,
                selectedSlot,
                formNotifier,
              ),
            if (afternoonSlots.isNotEmpty)
              _buildSlotSection(
                'AFTERNOON',
                afternoonSlots,
                selectedSlot,
                formNotifier,
              ),
            if (eveningSlots.isNotEmpty)
              _buildSlotSection(
                'EVENING',
                eveningSlots,
                selectedSlot,
                formNotifier,
              ),
          ],
        );
      },
      loading: () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (err, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Failed to load available slots',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildSlotSection(
    String title,
    List<Slot> slots,
    String selectedSlot,
    BookingFormNotifier formNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((slot) {
            final slotTimeStr = _formatSlotTime(slot.startsAt);
            final isSelected = selectedSlot == slotTimeStr;

            return InkWell(
              onTap: () {
                formNotifier.updateSlotObj(slot);
                formNotifier.updateTimeSlot(slotTimeStr);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.inputBorder,
                  ),
                ),
                child: Text(
                  slotTimeStr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTherapistsSelectorSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<TherapistsListResp> therapistsAsync,
    TherapistModel? selectedTherapist,
    BookingFormNotifier formNotifier,
    List<String> selectedFocusAreas,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SELECT YOUR THERAPIST',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: const Color(0xFFB45309),
              ),
            ),
            therapistsAsync.when(
              data: (resp) => Text(
                '${resp.therapists.length} available',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(height: 10),
        therapistsAsync.when(
          data: (resp) {
            final therapistsList = resp.therapists;
            if (therapistsList.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Text(
                  'No therapists found matching your focus areas.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            return SizedBox(
              height: 125,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: therapistsList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final t = therapistsList[index];
                  final isSelected = selectedTherapist?.id == t.id;

                  return GestureDetector(
                    onTap: () {
                      formNotifier.updateTherapist(t);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 250,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primarySubtle
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.inputBorder,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE2EFE0),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: t.photoUrl != null &&
                                          t.photoUrl!.isNotEmpty
                                      ? Image.network(
                                          t.photoUrl!,
                                          fit: BoxFit.cover,
                                          width: 42,
                                          height: 42,
                                          errorBuilder: (_, __, ___) => Center(
                                            child: Text(
                                              t.initials,
                                              style: GoogleFonts.outfit(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF26682A),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            t.initials,
                                            style: GoogleFonts.outfit(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF26682A),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.name,
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${t.sessionMinutes} min video • ${t.formattedPrice}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11.5,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            t.specialties.isNotEmpty
                                ? 'Specialties: ${t.specialties.join(", ")}'
                                : 'Matched on selected focus areas',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => SizedBox(
            height: 125,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => Container(
                width: 250,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          error: (err, stack) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: AppColors.alertErrorText, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Failed to load therapists list.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: AppColors.alertErrorText,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.invalidate(therapistsListProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
