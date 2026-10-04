import 'package:flutter_test/flutter_test.dart';

import 'package:safe_steps/main.dart';
import 'package:safe_steps/screens/welcome_screen.dart';

void main() {
  testWidgets('Safe Steps app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SafeStepsApp());

    await tester.pump();

    expect(find.byType(SafeStepsApp), findsOneWidget);
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}