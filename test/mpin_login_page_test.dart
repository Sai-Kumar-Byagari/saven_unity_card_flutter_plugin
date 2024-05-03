import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saven_unity_card_flutter_plugin/src/screens/mpin_login_page.dart';

void main() {
  testWidgets('Check if "Enter M-PIN" text is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MPinLoginPage()));

    expect(find.text('Enter M-PIN'), findsOneWidget);
  });

  testWidgets('Check if "Enter your M-PIN for a secure entry to your card" text is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MPinLoginPage()));

    expect(find.text('Enter your M-PIN for a secure entry to your card'), findsOneWidget);
  });

  testWidgets('Check if login button is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MPinLoginPage()));

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Check if input fields for M-PIN entry are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MPinLoginPage()));

    expect(find.byType(TextField), findsNWidgets(4));
  });

}
