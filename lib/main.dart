import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';
import 'core/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Environment Configuration
  EnvConfig.initialize(
    environment: AppEnvironment.dev,
    enableLogging: true,
  );

  // Initialize Stripe SDK
  Stripe.publishableKey = EnvConfig.instance.stripePublishableKey;
  await Stripe.instance.applySettings();

  // Set Transparent Status Bar with Dark Icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: MindEaseApp(),
    ),
  );
}
