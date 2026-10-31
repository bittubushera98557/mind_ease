import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../bookings/presentation/bookings_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../programs/presentation/programs_screen.dart';

/// Central Dashboard Screen managing bottom navigation across the 4 main tabs
class DashboardScreen extends StatefulWidget {
  final int initialIndex;

  const DashboardScreen({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProgramsScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE8E2DA), width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            label: 'Home',
            activeIcon: Icons.home_rounded,
            inactiveIcon: Icons.home_outlined,
          ),
          _buildNavItem(
            index: 1,
            label: 'Programs',
            activeIcon: Icons.grid_view_rounded,
            inactiveIcon: Icons.grid_view_rounded,
          ),
          _buildNavItem(
            index: 2,
            label: 'Bookings',
            activeIcon: Icons.calendar_today_rounded,
            inactiveIcon: Icons.calendar_today_outlined,
          ),
          _buildNavItem(
            index: 3,
            label: 'Profile',
            activeIcon: Icons.person_rounded,
            inactiveIcon: Icons.person_outline_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                activeIcon,
                size: 20,
                color: Colors.white,
              ),
            )
          else
            SizedBox(
              height: 36,
              child: Icon(
                inactiveIcon,
                size: 22,
                color: const Color(0xFF8C827A),
              ),
            ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : const Color(0xFF8C827A),
            ),
          ),
        ],
      ),
    );
  }
}
