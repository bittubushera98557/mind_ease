import 'dart:async';

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
import '../data/models/therapists_list_resp.dart';
import 'providers/bookings_provider.dart';
import 'providers/therapists_provider.dart';

/// 5.05 Book a Session: Step 3 of 3 – Review and Pay
class BookingStep3ReviewPayScreen extends ConsumerStatefulWidget {
  const BookingStep3ReviewPayScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookingStep3ReviewPayScreen> createState() =>
      _BookingStep3ReviewPayScreenState();
}

class _BookingStep3ReviewPayScreenState
    extends ConsumerState<BookingStep3ReviewPayScreen> {
  late final TextEditingController _mobileController;
  Timer? _holdTimer;
  int _secondsRemaining = 180; // 10 minutes (600 seconds) countdown

  @override
  void initState() {
    super.initState();
    final formState = ref.read(bookingFormNotifierProvider);
    _mobileController = TextEditingController(text: formState.mobileNumber);
    _startHoldTimer();
  }

  void _startHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        _holdTimer?.cancel();
        if (mounted) {
          _showHoldExpiredDialog();
        }
      }
    });
  }

  void _showHoldExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Hold Time Expired',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Your hold time is over, so start a new booking process',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ref.read(bookingFormNotifierProvider.notifier).resetForm();
                context.go(RouteNames.dashboard, extra: 2);
              },
              child: Text(
                'Okay',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _mobileController.dispose();
    super.dispose();
  }

  String get _formattedHoldTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    final secondsStr = seconds.toString().padLeft(2, '0');
    return 'Held $minutes:$secondsStr';
  }

  String _formatFullDate(DateTime date) {
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
    return '$dayName ${date.day} $monthName ${date.year}';
  }

  String _formatShortDate(DateTime date) {
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

  String _formatDateBadge(DateTime date) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatTimeString(BookingFormState formState, TherapistModel? therapist) {
    final tz = (therapist?.timezone != null && therapist!.timezone!.isNotEmpty)
        ? therapist.timezone!
        : 'AEDT';
    if (formState.selectedSlotObj != null) {
      final start = formState.selectedSlotObj!.startsAt;
      final end = formState.selectedSlotObj!.endsAt;
      final startStr = _formatHourMinute(start);
      final endStr = _formatHourMinuteWithPeriod(end);
      return '$startStr - $endStr $tz';
    } else if (formState.selectedTimeSlot.isNotEmpty) {
      return '${formState.selectedTimeSlot} $tz';
    }
    return '10:00 - 10:50 am $tz';
  }

  String _formatTimeStringShort(BookingFormState formState) {
    if (formState.selectedSlotObj != null) {
      final start = formState.selectedSlotObj!.startsAt;
      final end = formState.selectedSlotObj!.endsAt;
      final startStr = _formatHourMinute(start);
      final endStr = _formatHourMinuteWithPeriod(end);
      return '$startStr - $endStr';
    } else if (formState.selectedTimeSlot.isNotEmpty) {
      return formState.selectedTimeSlot;
    }
    return '10:00 - 10:50 am';
  }

  String _formatHourMinute(DateTime date) {
    final hour =
        date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatHourMinuteWithPeriod(DateTime date) {
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

    final therapistName = therapist?.name ?? 'Dr Priya Nair';
    final therapistRole = therapist?.specialties.isNotEmpty == true
        ? therapist!.specialties.map(cleanFocusLabel).where((s) => s.isNotEmpty).join(', ')
        : 'Clinical Psychologist';
    final therapistInitials = therapist?.initials ?? 'PN';
    final therapistPhoto = therapist?.photoUrl;

    final formattedDate = _formatFullDate(formState.selectedDate);
    final formattedTime = _formatTimeString(formState, therapist);
    final focusText = formState.selectedFocusAreas.isEmpty
        ? 'General Therapy'
        : formState.selectedFocusAreas.map(cleanFocusLabel).where((s) => s.isNotEmpty).join(', ');

    final priceCents = therapist?.priceCents ?? 18000;
    final priceAmount = priceCents > 0 ? priceCents / 100.0 : 180.0;
    final formattedSessionFee = '\$${priceAmount.toStringAsFixed(2)}';
    final formattedTotal = '\$${priceAmount.toStringAsFixed(2)} AUD';
    final payButtonText = 'Pay \$${priceAmount.toStringAsFixed(2)} and book';

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
                        'BOOK A SESSION  •  STEP 3 OF 3',
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
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Header Title & Hold Timer Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Review and pay',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Text(
                      _formattedHoldTime,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Summary Card (Therapist & Details)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    // Therapist info row
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE2EFE0),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: therapistPhoto != null &&
                                    therapistPhoto.isNotEmpty
                                ? Image.network(
                                    therapistPhoto,
                                    fit: BoxFit.cover,
                                    width: 44,
                                    height: 44,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Text(
                                        therapistInitials,
                                        style: GoogleFonts.outfit(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF26682A),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      therapistInitials,
                                      style: GoogleFonts.outfit(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF26682A),
                                      ),
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
                                therapistName,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                therapistRole,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Change',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF236539),
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFF236539),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
                    const SizedBox(height: 14),

                    // Details grid
                    _buildSummaryRow('Date', formattedDate),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Time', formattedTime),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Format',
                        'Video in MindEase (${therapist?.sessionMinutes ?? 50} min)'),
                    const SizedBox(height: 8),
                    _buildSummaryRow('Focus', focusText),
                    const SizedBox(height: 14),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF4EFEA)),
                    const SizedBox(height: 14),

                    _buildSummaryRow('Session fee', formattedSessionFee),
                    const SizedBox(height: 8),
                    _buildSummaryRow('GST', 'GST-free'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          formattedTotal,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Mobile Number Input Card
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
                      'Mobile number',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => formNotifier.updateMobileNumber(val),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF7F4F0),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pre-filled from your profile. Your therapist calls this number if video drops.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.textTertiary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // PAYMENT METHOD Section
              Text(
                'PAYMENT METHOD',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Column(
                  children: [
                    // Apple Pay
                    RadioListTile<String>(
                      value: 'Apple Pay',
                      groupValue: formState.paymentMethod,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        if (val != null) formNotifier.updatePaymentMethod(val);
                      },
                      title: Row(
                        children: [
                          const Icon(Icons.apple_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Apple Pay',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF4EFEA)),

                    // Visa card
                    RadioListTile<String>(
                      value: 'Visa •••• 4242',
                      groupValue: formState.paymentMethod,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        if (val != null) formNotifier.updatePaymentMethod(val);
                      },
                      title: Row(
                        children: [
                          const Icon(Icons.credit_card_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Visa  •••• 4242',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF4EFEA)),

                    // Add a card link
                    InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Add a card',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Cancellation Policy Notice
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
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          children: const [
                            TextSpan(
                                text:
                                    'Free to cancel or reschedule up to 24 hours before. Inside 24 hours the full fee applies. '),
                            TextSpan(
                              text: 'Cancellation policy',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Consents Checkboxes
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: formState.telehealthConsent,
                      activeColor: const Color(0xFF236539),
                      onChanged: (val) =>
                          formNotifier.toggleTelehealthConsent(val ?? true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'I consent to telehealth video sessions through MindEase.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: formState.privacyConsent,
                      activeColor: const Color(0xFF236539),
                      onChanged: (val) =>
                          formNotifier.togglePrivacyConsent(val ?? true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                        children: const [
                          TextSpan(text: 'I have read the '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                              text:
                                  ' and agree my booking details are shared with my therapist.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Pay and Book Button
              AppButton(
                text: payButtonText,
                onPressed: () {
                  // Add new appointment
                  final newAppointment = AppointmentModel(
                    id: 'bk-${DateTime.now().millisecondsSinceEpoch}',
                    therapistName: therapistName,
                    therapistRole: therapist?.specialties.isNotEmpty == true
                        ? therapist!.specialties.map(cleanFocusLabel).where((s) => s.isNotEmpty).join(', ')
                        : 'Clinical Psychologist',
                    therapistInitials: therapistInitials,
                    dateString: _formatShortDate(formState.selectedDate),
                    dateBadge: _formatDateBadge(formState.selectedDate),
                    timeString: _formatTimeStringShort(formState),
                    duration: '${therapist?.sessionMinutes ?? 50} min video',
                    format: 'Video in MindEase',
                    status: AppointmentStatus.upcoming,
                    isNextSession: true,
                    focusAreas: formState.selectedFocusAreas,
                    totalAmount: priceAmount,
                    bookingRef:
                        'ME-BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                    therapistNotes: formState.therapistNotes,
                  );

                  ref
                      .read(appointmentsNotifierProvider.notifier)
                      .addAppointment(newAppointment);

                  context.go(RouteNames.bookingConfirmation,
                      extra: newAppointment);
                },
              ),
              const SizedBox(height: 10),

              // Security footer note
              Center(
                child: Text(
                  'Secure payment by Stripe. Card details never touch MindEase servers.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

