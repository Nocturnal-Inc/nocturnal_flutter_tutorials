import 'package:flutter_test/flutter_test.dart';
import 'package:nocturnal_onboarding/main.dart';

void main() {
  testWidgets('App renders welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NocturnalOnboardingApp());
    // Use pump with a duration instead of pumpAndSettle, since the amoeba
    // background animation repeats indefinitely.
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Nocturnal'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
