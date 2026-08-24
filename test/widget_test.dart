// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pg_findar/main.dart';

void main() {
  testWidgets('Login Flow Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PGFinderApp());

    // Verify we are on the Intro Screen
    expect(find.text('Get start'), findsOneWidget);

    // Tap the 'Get start' button
    await tester.tap(find.text('Get start'));
    await tester.pumpAndSettle(); // Wait for navigation transition

    // Verify we are on the Login Screen
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login to continue'), findsOneWidget);

    // Tap Login without entering anything (should trigger validation)
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify validation errors are shown
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);

    // Enter invalid email and short password
    await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
    await tester.enterText(find.byType(TextFormField).last, '123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify correct validation error messages
    expect(find.text('Please enter a valid email address'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);

    // Enter correct credentials
    await tester.enterText(
      find.byType(TextFormField).first,
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Wait for the simulated network delay of 1 second
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify we navigated to the Dashboard
    expect(find.text('PG Finder Dashboard'), findsOneWidget);
    expect(find.text('Welcome to PG Finder!'), findsOneWidget);
  });

  testWidgets('Forgot Password Flow Test', (WidgetTester tester) async {
    await tester.pumpWidget(const PGFinderApp());

    // Tap the 'Get start' button
    await tester.tap(find.text('Get start'));
    await tester.pumpAndSettle();

    // Verify we are on the Login Screen
    expect(find.text('Welcome Back'), findsOneWidget);

    // Tap "Forgot Password?" link
    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    // Verify we are on the Forgot Password Screen
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('We will sent you a password reset link'), findsOneWidget);

    // Tap "Back to login" to verify navigation back
    await tester.tap(find.text('Back to login'));
    await tester.pumpAndSettle();

    // Verify we are back on the Login Screen
    expect(find.text('Welcome Back'), findsOneWidget);

    // Go back to Forgot Password Screen
    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();

    // Tap "Send Reset Link" with empty field
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();

    // Verify validation errors
    expect(find.text('Please enter your email'), findsOneWidget);

    // Enter invalid email
    await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();
    expect(find.text('Please enter a valid email address'), findsOneWidget);

    // Enter valid email
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();

    // Wait for the simulated delay of 1.5 seconds
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Verify we are popped back to Login Screen
    expect(find.text('Welcome Back'), findsOneWidget);
  });

  testWidgets('Sign Up Flow Test', (WidgetTester tester) async {
    // Set a realistic taller device screen size to fit the full form
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PGFinderApp());

    // Tap the 'Get start' button
    await tester.tap(find.text('Get start'));
    await tester.pumpAndSettle();

    // Verify we are on the Login Screen
    expect(find.text('Welcome Back'), findsOneWidget);

    // Tap "Sign Up" link
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    // Verify we are on the Sign Up Screen
    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text('Sign up to get started'), findsOneWidget);

    // Tap "Sign Up" button without entering anything (should trigger validation)
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify validation errors are shown
    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please create a password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
    expect(find.text('You must agree to the Terms & Conditions'), findsOneWidget);

    // Enter name
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    
    // Enter invalid email
    await tester.enterText(find.byType(TextFormField).at(1), 'invalid-email');

    // Enter too short password
    await tester.enterText(find.byType(TextFormField).at(2), '1234567');

    // Enter non-matching confirm password
    await tester.enterText(find.byType(TextFormField).at(3), '12345678');

    // Tap checkbox to agree to terms
    await tester.tap(find.byType(Checkbox));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify correct validation error messages
    expect(find.text('Please enter a valid email address'), findsOneWidget);
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);

    // Fix email and passwords
    await tester.enterText(find.byType(TextFormField).at(1), 'john.doe@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');

    // Tap Sign Up
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Wait for the simulated delay of 1 second
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify we navigated back to LoginPage (should show 'Welcome Back')
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
