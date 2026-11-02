import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/appointment_model.dart';

/// 5.10 In-Session Video Call Screen
class BookingInSessionScreen extends StatefulWidget {
  final AppointmentModel? appointment;

  const BookingInSessionScreen({
    Key? key,
    this.appointment,
  }) : super(key: key);

  @override
  State<BookingInSessionScreen> createState() => _BookingInSessionScreenState();
}

class _BookingInSessionScreenState extends State<BookingInSessionScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    final appt = widget.appointment ??
        const AppointmentModel(
          id: 'bk-01',
          therapistName: 'Dr Priya Nair',
          therapistRole: 'Clinical Psychologist',
          therapistInitials: 'PN',
          dateString: 'Wed 4 Nov',
          dateBadge: 'NOV 4',
          timeString: '10:00 - 10:30 am',
          duration: '50 min',
          format: 'Video',
          status: AppointmentStatus.upcoming,
          totalAmount: 180.0,
          bookingRef: 'ME-BK-020125',
        );

    return Scaffold(
      backgroundColor: const Color(0xFF231B17),
      body: SafeArea(
        child: Stack(
          children: [
            // Therapist Main Video Feed Canvas
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2EFE0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        appt.therapistInitials,
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF26682A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appt.therapistName,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Top Bar Overlay (Timer & Connection)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '26:12',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF236539),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          appt.therapistName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Picture-in-Picture Inset Self View (Bottom Right)
            Positioned(
              right: 16,
              bottom: 100,
              child: Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF382E28),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 32,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),

            // Bottom Floating Controls Bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Mute
                    IconButton(
                      icon: Icon(
                        _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                      },
                    ),

                    // Camera
                    IconButton(
                      icon: Icon(
                        _isVideoOff
                            ? Icons.videocam_off_rounded
                            : Icons.videocam_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isVideoOff = !_isVideoOff;
                        });
                      },
                    ),

                    // Flip camera
                    IconButton(
                      icon: const Icon(
                        Icons.cameraswitch_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),

                    // Notes / Chat
                    IconButton(
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),

                    // End Call (Red Button)
                    GestureDetector(
                      onTap: () {
                        context.go(RouteNames.bookingSessionEnded,
                            extra: appt);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call_end_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
