import 'package:flutter_test/flutter_test.dart';
import 'package:spotti/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SpottiApp());
    expect(find.byType(SpottiApp), findsOneWidget);
  });
}
