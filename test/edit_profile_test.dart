import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pg_findar/screens/user/user_profile_screen.dart';

void main() {
  testWidgets('Edit profile full flow updates user profile on ProfileScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    expect(find.text('Hi , User'), findsOneWidget);
    expect(find.text('user@gmail.com'), findsOneWidget);

    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();

    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
    expect(find.text('save'), findsOneWidget);

    final nameField = find.widgetWithText(TextField, 'User');
    await tester.enterText(nameField, 'Dharmik Rathod');

    final emailField = find.widgetWithText(TextField, 'user@gmail.com');
    await tester.enterText(emailField, 'dharmik@example.com');

    await tester.tap(find.widgetWithText(ElevatedButton, 'save'));
    await tester.pumpAndSettle();

    expect(find.text('Hi , User'), findsOneWidget);
    expect(find.text('user@gmail.com'), findsOneWidget);
  });
}
