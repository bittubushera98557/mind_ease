import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/booking_response_model.dart';
import '../../data/models/therapist_based_available_slots_resp.dart';
import '../../data/models/therapists_list_resp.dart';
import '../../data/repositories/bookings_repository.dart';

export '../../data/repositories/bookings_repository.dart';

/// Provider for tab index in My Appointments (0: Upcoming, 1: Past)
final bookingsTabProvider = StateProvider<int>((ref) => 0);

/// Provider for current booking form draft state
final bookingFormNotifierProvider =
    StateNotifierProvider<BookingFormNotifier, BookingFormState>((ref) {
  return BookingFormNotifier();
});

class BookingFormNotifier extends StateNotifier<BookingFormState> {
  BookingFormNotifier() : super(BookingFormState());

  void updateTherapist(TherapistModel therapist) {
    state = state.copyWith(selectedTherapist: therapist);
  }

  void updateSlotObj(Slot slot) {
    state = state.copyWith(
      selectedSlotObj: slot,
      selectedDate: slot.startsAt,
    );
  }

  void toggleFocusArea(String focusArea) {
    final current = List<String>.from(state.selectedFocusAreas);
    if (current.contains(focusArea)) {
      current.remove(focusArea);
    } else {
      if (current.length < 3) {
        current.add(focusArea);
      }
    }
    state = state.copyWith(selectedFocusAreas: current);
  }

  void updateNotes(String notes) {
    state = state.copyWith(therapistNotes: notes);
  }

  void updateMentalHealthPlan(String option) {
    state = state.copyWith(mentalHealthPlanOption: option);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
      selectedTimeSlot: '',
      selectedSlotObj: null,
    );
  }

  void updateTimeSlot(String slot) {
    state = state.copyWith(selectedTimeSlot: slot);
  }

  void updateMobileNumber(String mobile) {
    state = state.copyWith(mobileNumber: mobile);
  }

  void updatePaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void toggleTelehealthConsent(bool val) {
    state = state.copyWith(telehealthConsent: val);
  }

  void togglePrivacyConsent(bool val) {
    state = state.copyWith(privacyConsent: val);
  }

  void resetForm() {
    state = BookingFormState();
  }
}

/// Provider for managing appointments list (Upcoming and Past)
final appointmentsNotifierProvider =
    StateNotifierProvider<AppointmentsNotifier, List<AppointmentModel>>((ref) {
  return AppointmentsNotifier();
});

class AppointmentsNotifier extends StateNotifier<List<AppointmentModel>> {
  AppointmentsNotifier() : super(const []);

  void setAppointments(List<AppointmentModel> list) {
    state = list;
  }

  void addAppointment(AppointmentModel appointment) {
    state = [appointment, ...state];
  }
}

/// Helper function to convert API BookingItemModel to AppointmentModel
AppointmentModel bookingItemToAppointment(BookingItemModel item, {bool isNext = false}) {
  DateTime? dt;
  if (item.startsAt != null && item.startsAt!.isNotEmpty) {
    dt = DateTime.tryParse(item.startsAt!)?.toLocal();
  }

  final dateStr = dt != null ? _formatDateString(dt) : 'TBD';
  final dateBadgeStr = dt != null ? _formatDateBadge(dt) : 'SESSION';
  final timeStr = dt != null ? _formatTimeString(dt, item.endsAt) : 'TBD';

  AppointmentStatus status = AppointmentStatus.upcoming;
  final stLower = item.status.toLowerCase();
  if (stLower.contains('cancel')) {
    status = AppointmentStatus.cancelled;
  } else if (stLower.contains('complete') || stLower.contains('done')) {
    status = AppointmentStatus.completed;
  } else if (dt != null && dt.isBefore(DateTime.now())) {
    status = AppointmentStatus.completed;
  } else {
    status = AppointmentStatus.upcoming;
  }

  final therapistName = item.therapist?.name.isNotEmpty == true
      ? item.therapist!.name
      : 'Therapist';
  final therapistInitials = _getInitials(therapistName);

  return AppointmentModel(
    id: item.id.isNotEmpty ? item.id : 'bk-${DateTime.now().millisecondsSinceEpoch}',
    therapistName: therapistName,
    therapistRole: 'Clinical Psychologist',
    therapistInitials: therapistInitials,
    dateString: dateStr,
    dateBadge: dateBadgeStr,
    timeString: timeStr,
    duration: '50 min video',
    format: 'Video in MindEase',
    status: status,
    isNextSession: isNext,
    focusAreas: const ['Stress', 'Sleep'],
    totalAmount: item.priceCents > 0 ? item.priceCents / 100.0 : 180.0,
    bookingRef: item.id.isNotEmpty
        ? 'ME-BK-${item.id.substring(0, item.id.length > 6 ? 6 : item.id.length).toUpperCase()}'
        : 'ME-BK-020125',
    therapistNotes: item.notes,
    meetingJwtToken: item.meetingJwtToken,
  );
}

String _formatDateString(DateTime dt) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${weekdays[dt.weekday - 1]} ${dt.day} ${months[dt.month - 1]}';
}

String _formatDateBadge(DateTime dt) {
  const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
  return '${months[dt.month - 1]} ${dt.day}';
}

String _formatTimeString(DateTime dt, String? endsAtStr) {
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'pm' : 'am';
  
  if (endsAtStr != null && endsAtStr.isNotEmpty) {
    final endsDt = DateTime.tryParse(endsAtStr)?.toLocal();
    if (endsDt != null) {
      final endHour = endsDt.hour % 12 == 0 ? 12 : endsDt.hour % 12;
      final endMinute = endsDt.minute.toString().padLeft(2, '0');
      final endPeriod = endsDt.hour >= 12 ? 'pm' : 'am';
      if (period == endPeriod) {
        return '$hour:$minute - $endHour:$endMinute $period';
      } else {
        return '$hour:$minute $period - $endHour:$endMinute $endPeriod';
      }
    }
  }
  return '$hour:$minute $period';
}

String _getInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
    return parts[0].substring(0, parts[0].length > 2 ? 2 : parts[0].length).toUpperCase();
  }
  return 'TH';
}

/// FutureProvider that fetches my bookings GET /me/bookings dynamically
final myBookingsProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final repository = ref.watch(bookingsRepositoryProvider);
  final response = await repository.getBookings();
  final items = response.bookings;

  final apiAppointments = <AppointmentModel>[];
  bool foundNext = false;
  for (final item in items) {
    final isUpcoming = !item.status.toLowerCase().contains('cancel') &&
        !item.status.toLowerCase().contains('complete');
    bool isNext = false;
    if (isUpcoming && !foundNext) {
      isNext = true;
      foundNext = true;
    }
    apiAppointments.add(bookingItemToAppointment(item, isNext: isNext));
  }

  // Include any local items that aren't duplicated in API
  final localAppts = ref.read(appointmentsNotifierProvider);
  for (final local in localAppts) {
    if (!apiAppointments.any((a) => a.id == local.id || a.bookingRef == local.bookingRef)) {
      apiAppointments.insert(0, local);
    }
  }

  ref.read(appointmentsNotifierProvider.notifier).setAppointments(apiAppointments);
  return apiAppointments;
});
