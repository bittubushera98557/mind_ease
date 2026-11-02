import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/legal_content_provider.dart';
import 'widgets/legal_document_view.dart';

/// Terms of Use Screen
class TermsOfUseScreen extends ConsumerWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsOfUse = ref.watch(termsOfUseProvider);
    return LegalDocumentView(document: termsOfUse);
  }
}
