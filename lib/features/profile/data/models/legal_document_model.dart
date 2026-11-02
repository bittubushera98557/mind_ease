/// Bullet item representation for legal document sections
class LegalBulletItem {
  final String? prefix;
  final String text;

  const LegalBulletItem({
    this.prefix,
    required this.text,
  });
}

/// Section inside a legal document (Privacy Policy or Terms of Use)
class LegalSection {
  final int number;
  final String title;
  final String? body;
  final List<LegalBulletItem>? bullets;
  final String? footerNote;

  const LegalSection({
    required this.number,
    required this.title,
    this.body,
    this.bullets,
    this.footerNote,
  });
}

/// Dynamic Model representing a Legal Document
class LegalDocument {
  final String headerTag;
  final String title;
  final String lastUpdated;
  final String reviewStatus;
  final String introText;
  final List<LegalSection> sections;
  final String emergencyNotice;

  const LegalDocument({
    required this.headerTag,
    required this.title,
    required this.lastUpdated,
    required this.reviewStatus,
    required this.introText,
    required this.sections,
    required this.emergencyNotice,
  });
}
