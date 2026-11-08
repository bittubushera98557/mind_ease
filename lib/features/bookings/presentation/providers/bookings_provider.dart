import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/therapist_based_available_slots_resp.dart';
import '../../data/models/therapists_list_resp.dart';

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
  AppointmentsNotifier()
      : super(const [
          AppointmentModel(
            id: 'bk-01',
            therapistName: 'Dr Priya Nair',
            therapistRole: 'Clinical Psychologist',
            therapistInitials: 'PN',
            dateString: 'Wed 4 Nov',
            dateBadge: 'NOV 4',
            timeString: '10:00 - 10:30 am',
            duration: '30 min video',
            format: 'Video in MindEase',
            status: AppointmentStatus.upcoming,
            isNextSession: true,
            focusAreas: ['Stress', 'Sleep'],
            totalAmount: 180.0,
            bookingRef: 'ME-BK-020125',
          ),
          AppointmentModel(
            id: 'bk-02',
            therapistName: 'Dr Priya Nair',
            therapistRole: 'Clinical Psychologist',
            therapistInitials: 'PN',
            dateString: 'Wed 18 Nov',
            dateBadge: 'NOV 18',
            timeString: '10:00 am',
            duration: '50 min video',
            format: 'Video in MindEase',
            status: AppointmentStatus.upcoming,
            isNextSession: false,
            focusAreas: ['Stress', 'Sleep'],
            totalAmount: 180.0,
            bookingRef: 'ME-BK-020126',
          ),
          AppointmentModel(
            id: 'bk-03',
            therapistName: 'Dr Priya Nair',
            therapistRole: 'Clinical Psychologist',
            therapistInitials: 'PN',
            dateString: 'Wed 21 Oct',
            dateBadge: 'OCT 21',
            timeString: 'Wed 10:00 am',
            duration: '50 min video',
            format: 'Video in MindEase',
            status: AppointmentStatus.completed,
            isNextSession: false,
            focusAreas: ['Stress'],
            totalAmount: 180.0,
            bookingRef: 'ME-BK-019801',
          ),
          AppointmentModel(
            id: 'bk-04',
            therapistName: 'Dr Priya Nair',
            therapistRole: 'Clinical Psychologist',
            therapistInitials: 'PN',
            dateString: 'Wed 7 Oct',
            dateBadge: 'OCT 7',
            timeString: 'Wed 10:00 am',
            duration: '50 min video',
            format: 'Video in MindEase',
            status: AppointmentStatus.completed,
            isNextSession: false,
            focusAreas: ['Anxiety'],
            totalAmount: 180.0,
            bookingRef: 'ME-BK-019742',
          ),
          AppointmentModel(
            id: 'bk-05',
            therapistName: 'Dr Priya Nair',
            therapistRole: 'Clinical Psychologist',
            therapistInitials: 'PN',
            dateString: 'Wed 30 Sep',
            dateBadge: 'SEP 30',
            timeString: 'Wed 10:00 am',
            duration: '50 min video • Refunded',
            format: 'Video in MindEase',
            status: AppointmentStatus.cancelled,
            isNextSession: false,
            focusAreas: ['Sleep'],
            totalAmount: 180.0,
            bookingRef: 'ME-BK-019500',
          ),
        ]);

  void addAppointment(AppointmentModel appointment) {
    state = [appointment, ...state];
  }
}
