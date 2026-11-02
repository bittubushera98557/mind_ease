import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/legal_document_model.dart';

/// Provider for Privacy Policy legal document
final privacyPolicyProvider = Provider<LegalDocument>((ref) {
  return const LegalDocument(
    headerTag: 'PRIVACY',
    title: 'Privacy policy',
    lastUpdated: '17/11/2024',
    reviewStatus: '1.0.1 Legal review completed',
    introText:
        'How MindEase collects, uses and protects your personal and health information.',
    emergencyNotice: 'MindEase is not a crisis service. In an emergency, call 000.',
    sections: [
      LegalSection(
        number: 1,
        title: 'Who we are',
        body:
            'MindEase is operated by [ENTITY NAME / COMPANY NAME]. We are bound by the Privacy Act 1988 (Cth) and the Australian Privacy Principles.',
      ),
      LegalSection(
        number: 2,
        title: 'What we collect',
        bullets: [
          LegalBulletItem(
            prefix: 'Account details: ',
            text:
                'Name, preferred name, email, mobile, date of birth, employer (if accessing via workplace).',
          ),
          LegalBulletItem(
            prefix: 'Program data: ',
            text:
                'Goals, survey responses, reflections, spot checks, progress, check-in history.',
          ),
          LegalBulletItem(
            prefix: 'Booking data: ',
            text:
                'Session dates, notes to your therapist. Mental health cloud health and therapist session records directly held.',
          ),
          LegalBulletItem(
            prefix: 'Payment details: ',
            text: 'Via app store platforms / direct processor.',
          ),
          LegalBulletItem(
            prefix: 'Technical data: ',
            text: 'App version, device type, crash logs.',
          ),
        ],
      ),
      LegalSection(
        number: 3,
        title: 'Health information',
        body:
            'Your answers, reflections, and booking notes are health information, which we collect only with your consent and only use to deliver your program and match you with a therapist.',
      ),
      LegalSection(
        number: 4,
        title: 'How we use it',
        bullets: [
          LegalBulletItem(
            text: 'Personalise your program and suggestions.',
          ),
          LegalBulletItem(
            text: 'Assign a therapist and scheduled sessions.',
          ),
          LegalBulletItem(
            text: 'Send reminders and notifications.',
          ),
          LegalBulletItem(
            text: 'Process payments and refunds.',
          ),
          LegalBulletItem(
            text: 'Product improvement and analytics.',
          ),
        ],
        footerNote: 'We do NOT sell your information or use it for advertising.',
      ),
      LegalSection(
        number: 5,
        title: 'Who we share it with',
        bullets: [
          LegalBulletItem(
            text:
                'Your assigned therapist (your name, mobile, focus areas, triage and DASS21 status).',
          ),
          LegalBulletItem(
            text: 'Witness (only if requested).',
          ),
          LegalBulletItem(
            text: 'Employer (WE DO NOT share individual responses or names).',
          ),
          LegalBulletItem(
            text:
                'Crisis guidance/authorities if there is an urgent risk to your life or safety.',
          ),
        ],
      ),
      LegalSection(
        number: 6,
        title: 'Storage and overseas disclosure',
        body:
            'Data is stored in Australia and encrypted at rest and in transit (128/256-bit AES encryption).',
      ),
      LegalSection(
        number: 7,
        title: 'Your choices',
        bullets: [
          LegalBulletItem(
            text: 'You can access your data in Profile or request a full export.',
          ),
          LegalBulletItem(
            text:
                'Ask for a copy of your data by emailing support@mindease.app.',
          ),
          LegalBulletItem(
            text:
                'Delete your account in Profile. This removes your data, except records we must keep by law (e.g. therapist notes).',
          ),
        ],
      ),
      LegalSection(
        number: 8,
        title: 'Complaints',
        body:
            'Email privacy@mindease.app. We reply within 30 days. If you\'re not satisfied, contact the Office of the Australian Information Commissioner (OAIC) at oaic.gov.au or 1300 363 992.',
      ),
    ],
  );
});

/// Provider for Terms of Use legal document
final termsOfUseProvider = Provider<LegalDocument>((ref) {
  return const LegalDocument(
    headerTag: 'TERMS',
    title: 'Terms of use',
    lastUpdated: '17/11/2024',
    reviewStatus: '1.0.1 Legal review completed',
    introText:
        'The rules for using MindEase and accessing sessions. Please read them before you start.',
    emergencyNotice: 'MindEase is not a crisis service. In an emergency, call 000.',
    sections: [
      LegalSection(
        number: 1,
        title: 'About MindEase',
        body:
            'MindEase is operated by [ENTITY NAME / COMPANY NAME]. It offers a self-guided program based on mental health and CBT principles and optional access to AHPRA registered mental health professionals.',
      ),
      LegalSection(
        number: 2,
        title: 'Not a crisis service',
        body:
            'MindEase can\'t respond to emergencies. If you\'re in immediate danger, call 000 (Australia) or 112.',
      ),
      LegalSection(
        number: 3,
        title: 'Not medical advice',
        body:
            'Program content is for education and self-reflection. It doesn\'t diagnose or treat any condition or illness. It replaces advice from your GP or another health professional.',
      ),
      LegalSection(
        number: 4,
        title: 'Who can use it',
        body:
            'You must be 18 or older and live in Australia to book therapy sessions.',
      ),
      LegalSection(
        number: 5,
        title: 'Your account',
        body:
            'Keep your details accurate and your password secure. You\'re responsible for all activity on your account.',
      ),
      LegalSection(
        number: 6,
        title: 'Therapy sessions',
        bullets: [
          LegalBulletItem(
            text:
                'Sessions are with AHPRA registered or credentialed mental health professionals in Australia.',
          ),
          LegalBulletItem(
            text: 'Your therapist is assigned based on the focus area you choose.',
          ),
          LegalBulletItem(
            text: 'You consent to telehealth when you book.',
          ),
          LegalBulletItem(
            text:
                'If a therapist is not available, we\'ll offer a replacement or refund.',
          ),
        ],
      ),
      LegalSection(
        number: 7,
        title: 'Fees, cancellations and refunds',
        bullets: [
          LegalBulletItem(
            text:
                'Fees displayed in AUD before you pay and charged through the app.',
          ),
          LegalBulletItem(
            text:
                'Free cancellation or rescheduling up to 24 hours before the session.',
          ),
          LegalBulletItem(
            text: 'Within 24 hours, the full fee applies.',
          ),
          LegalBulletItem(
            text:
                'Refunds go back to your original payment method in 5-10 business days.',
          ),
        ],
        footerNote:
            'See Policy / terms for detail on your rights under the Australian Consumer Law.',
      ),
      LegalSection(
        number: 8,
        title: 'Acceptable use',
        body:
            'Don\'t misuse the app, harm sessions or other people, or try to access accounts that aren\'t yours.',
      ),
      LegalSection(
        number: 9,
        title: 'Content',
        body:
            'Program content, design and branding belongs to MindEase or licensors. You may use them for your own personal use only.',
      ),
      LegalSection(
        number: 10,
        title: 'Liability',
        body:
            'To the extent permitted by law, we\'re not liable for indirect losses from using the app. This doesn\'t exclude rights under Australian Consumer Law.',
      ),
      LegalSection(
        number: 11,
        title: 'Changes and ending',
        body:
            'We may update terms. We\'ll tell you if the changes matter before they take effect. You can stop using MindEase and delete your account at any time.',
      ),
      LegalSection(
        number: 12,
        title: 'Law and contact',
        body:
            'Please fall under the governed laws of Victoria, Australia. Questions? Email legal@mindease.app.',
      ),
    ],
  );
});
