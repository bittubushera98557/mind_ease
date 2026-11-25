import 'therapist_based_available_slots_resp.dart';
import 'therapists_list_resp.dart';

enum AppointmentStatus {
  upcoming,
  completed,
  cancelled,
}

/// Data model representing a booked therapy appointment
class AppointmentModel {
  final String id;
  final String therapistName;
  final String therapistRole;
  final String therapistInitials;
  final String dateString;
  final String dateBadge;
  final String timeString;
  final String duration;
  final String format;
  final AppointmentStatus status;
  final bool isNextSession;
  final List<String> focusAreas;
  final double totalAmount;
  final String bookingRef;
  final String? therapistNotes;
  final String? paymentToken;
  final String? paymentMethod;
  final String? meetingJwtToken;

  const AppointmentModel({
    required this.id,
    required this.therapistName,
    required this.therapistRole,
    required this.therapistInitials,
    required this.dateString,
    required this.dateBadge,
    required this.timeString,
    required this.duration,
    required this.format,
    required this.status,
    this.isNextSession = false,
    this.focusAreas = const [],
    required this.totalAmount,
    required this.bookingRef,
    this.therapistNotes,
    this.paymentToken,
    this.paymentMethod,
    this.meetingJwtToken,
  });

  AppointmentModel copyWith({
    String? id,
    String? therapistName,
    String? therapistRole,
    String? therapistInitials,
    String? dateString,
    String? dateBadge,
    String? timeString,
    String? duration,
    String? format,
    AppointmentStatus? status,
    bool? isNextSession,
    List<String>? focusAreas,
    double? totalAmount,
    String? bookingRef,
    String? therapistNotes,
    String? paymentToken,
    String? paymentMethod,
    String? meetingJwtToken,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      therapistName: therapistName ?? this.therapistName,
      therapistRole: therapistRole ?? this.therapistRole,
      therapistInitials: therapistInitials ?? this.therapistInitials,
      dateString: dateString ?? this.dateString,
      dateBadge: dateBadge ?? this.dateBadge,
      timeString: timeString ?? this.timeString,
      duration: duration ?? this.duration,
      format: format ?? this.format,
      status: status ?? this.status,
      isNextSession: isNextSession ?? this.isNextSession,
      focusAreas: focusAreas ?? this.focusAreas,
      totalAmount: totalAmount ?? this.totalAmount,
      bookingRef: bookingRef ?? this.bookingRef,
      therapistNotes: therapistNotes ?? this.therapistNotes,
      paymentToken: paymentToken ?? this.paymentToken,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      meetingJwtToken: meetingJwtToken ?? this.meetingJwtToken,
    );
  }
}

/// State model tracking booking flow form state
class BookingFormState {
  final List<String> selectedFocusAreas;
  final String therapistNotes;
  final String mentalHealthPlanOption; // "Yes", "No", "Not sure"
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final String mobileNumber;
  final String paymentMethod; // "Apple Pay", "Visa •••• 4242"
  final bool telehealthConsent;
  final bool privacyConsent;
  final TherapistModel? selectedTherapist;
  final Slot? selectedSlotObj;

  BookingFormState({
    this.selectedFocusAreas = const ['stress', 'sleep'],
    this.therapistNotes = '',
    this.mentalHealthPlanOption = 'No',
    DateTime? selectedDate,
    this.selectedTimeSlot = '10:00 am',
    this.mobileNumber = '04',
    this.paymentMethod = 'Apple Pay',
    this.telehealthConsent = true,
    this.privacyConsent = true,
    this.selectedTherapist,
    this.selectedSlotObj,
  }) : selectedDate = selectedDate ?? DateTime.now();

  BookingFormState copyWith({
    List<String>? selectedFocusAreas,
    String? therapistNotes,
    String? mentalHealthPlanOption,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    String? mobileNumber,
    String? paymentMethod,
    bool? telehealthConsent,
    bool? privacyConsent,
    TherapistModel? selectedTherapist,
    Slot? selectedSlotObj,
  }) {
    return BookingFormState(
      selectedFocusAreas: selectedFocusAreas ?? this.selectedFocusAreas,
      therapistNotes: therapistNotes ?? this.therapistNotes,
      mentalHealthPlanOption:
          mentalHealthPlanOption ?? this.mentalHealthPlanOption,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      telehealthConsent: telehealthConsent ?? this.telehealthConsent,
      privacyConsent: privacyConsent ?? this.privacyConsent,
      selectedTherapist: selectedTherapist ?? this.selectedTherapist,
      selectedSlotObj: selectedSlotObj ?? this.selectedSlotObj,
    );
  }
}
