import 'package:flutter_test/flutter_test.dart';
import 'package:fixu_app/main.dart';

void main() {
  testWidgets('FixUApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FixUApp());
    expect(find.text('FixU'), findsWidgets);
  });
}
