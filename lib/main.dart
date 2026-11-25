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



///Volumes/Untitled/SDKs/flutter_3.38.1/bin/cache/dart-sdk
///dart 3.10.0       // flutter_3.38.1
///rs@rss-Mac-mini ~ % java -version
// openjdk version "17.0.8" 2023-07-18
// OpenJDK Runtime Environment Temurin-17.0.8+7 (build 17.0.8+7)
// OpenJDK 64-Bit Server VM Temurin-17.0.8+7 (build 17.0.8+7, mixed mode, sharing)
// rs@rss-Mac-mini ~ %