import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/mind_ease_logo.dart';
import '../../auth/presentation/providers/auth_provider.dart';

/// 1.01 Splash Screen with Auto Login Check via SharedPreferences
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();

    // Check local authentication in SharedPreferences and navigate after initial frame build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAuthAndNavigate();
    });
  }

  Future<void> _initAuthAndNavigate() async {
    final startTime = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    final savedAccessToken = prefs.getString(AppConstants.keyAuthToken);

    debugPrint('Splash savedAccessToken: $savedAccessToken');

    final hasToken =
        savedAccessToken != null && savedAccessToken.trim().isNotEmpty;

    if (hasToken) {
      // Load user profile into Riverpod state
      await ref.read(authNotifierProvider.notifier).checkAuthStatus();
    }

    // Ensure logo animation displays for at least 1.8 seconds
    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    final remaining = 1800 - elapsed;
    if (remaining > 0) {
      await Future.delayed(Duration(milliseconds: remaining));
    }

    if (!mounted) return;

    if (hasToken) {
      context.go(RouteNames.dashboard);
    } else {
      context.go(RouteNames.welcome);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _skip() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAccessToken = prefs.getString(AppConstants.keyAuthToken);
    final hasToken =
        savedAccessToken != null && savedAccessToken.trim().isNotEmpty;

    if (!mounted) return;

    if (hasToken) {
      context.go(RouteNames.dashboard);
    } else {
      context.go(RouteNames.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: _skip,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const MindEaseLogo(
                  size: 96,
                  showText: true,
                  showSubtitle: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
