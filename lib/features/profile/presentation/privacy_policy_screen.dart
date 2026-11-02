import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/legal_content_provider.dart';
import 'widgets/legal_document_view.dart';

/// Privacy Policy Screen
class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyPolicy = ref.watch(privacyPolicyProvider);
    return LegalDocumentView(document: privacyPolicy);
  }
}
