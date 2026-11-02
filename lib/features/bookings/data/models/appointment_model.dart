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
  });
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

  BookingFormState({
    this.selectedFocusAreas = const ['Stress', 'Sleep'],
    this.therapistNotes = '',
    this.mentalHealthPlanOption = 'No',
    DateTime? selectedDate,
    this.selectedTimeSlot = '10:00 am',
    this.mobileNumber = '04XX XXX XXX',
    this.paymentMethod = 'Apple Pay',
    this.telehealthConsent = true,
    this.privacyConsent = true,
  }) : selectedDate = selectedDate ?? DateTime(2024, 11, 4);

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
    );
  }
}
