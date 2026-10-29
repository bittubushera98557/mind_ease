import 'package:flutter_test/flutter_test.dart';
import 'package:mind_ease/app.dart';
import 'package:mind_ease/core/config/env_config.dart';

void main() {
  setUp(() {
    EnvConfig.initialize(
      environment: AppEnvironment.dev,
      enableLogging: false,
    );
  });

  testWidgets('MindEaseApp initializes and renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MindEaseApp());
    expect(find.text('MindEase'), findsOneWidget);
  });
}
