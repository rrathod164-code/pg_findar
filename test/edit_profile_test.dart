import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pg_findar/screens/dashboard/profile_screen.dart';
import 'package:pg_findar/services/api_service.dart';

void main() {
  testWidgets('Edit profile full flow updates user profile on ProfileScreen', (
    WidgetTester tester,
  ) async {
    // 1. Reset ApiService state for test
    final api = ApiService();
    api.userNameNotifier.value = 'User';
    api.userEmailNotifier.value = 'user@gmail.com';

    // 2. Launch ProfileScreen
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    expect(find.text('Hi , User'), findsOneWidget);
    expect(find.text('user@gmail.com'), findsOneWidget);

    // 3. Tap on "Edit profile"
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();

    // Verify EditProfileScreen is shown with all required fields
    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
    expect(find.text('save'), findsOneWidget);

    // 4. Change Name & Email
    final nameField = find.widgetWithText(TextField, 'User');
    await tester.enterText(nameField, 'Dharmik Rathod');

    final emailField = find.widgetWithText(TextField, 'user@gmail.com');
    await tester.enterText(emailField, 'dharmik@example.com');

    // 5. Tap the 'save' button
    await tester.tap(find.widgetWithText(ElevatedButton, 'save'));
    await tester.pumpAndSettle();

    // 6. Verify that we are back on ProfileScreen and the changes are reflected!
    expect(find.text('Hi , Dharmik Rathod'), findsOneWidget);
    expect(find.text('dharmik@example.com'), findsOneWidget);
  });
}
