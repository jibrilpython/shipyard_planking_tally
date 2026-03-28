// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipyard_planking_tally/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Provide initial values for SharedPreferences.
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(preferences: preferences));

    // Simple check to see if the app loads.
    expect(find.text('SHIPYARD'), findsOneWidget);
  });
}
