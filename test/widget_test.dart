import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pg_findar/main.dart';
import 'package:pg_findar/screens/auth/intro_screen.dart';
import 'package:pg_findar/screens/auth/login_screen.dart';
import 'package:pg_findar/screens/auth/signup_screen.dart';
import 'package:pg_findar/screens/auth/forgot_password_screen.dart';
import 'package:pg_findar/widgets/bottom_nav_bar.dart';
import 'package:pg_findar/screens/dashboard/home_screen.dart';
import 'package:pg_findar/screens/dashboard/saved_screen.dart';
import 'package:pg_findar/screens/dashboard/booking_screen.dart';
import 'package:pg_findar/screens/dashboard/profile_screen.dart';

final List<int> _kTransparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FakeHttpClient();
  }
}

class _FakeHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getUrl || invocation.memberName == #openUrl) {
      return Future<_FakeHttpClientRequest>.value(_FakeHttpClientRequest());
    }
    return super.noSuchMethod(invocation);
  }
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #close) {
      return Future<_FakeHttpClientResponse>.value(_FakeHttpClientResponse());
    }
    return super.noSuchMethod(invocation);
  }
}

class _FakeHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _kTransparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable(<List<int>>[_kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  void setTestScreenSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('App renders Intro Screen initially', (WidgetTester tester) async {
    setTestScreenSize(tester);
    await tester.pumpWidget(const PGFinderApp());
    expect(find.byType(IntroScreen), findsOneWidget);
    expect(find.text('Get start'), findsOneWidget);
  });

  testWidgets('Intro navigation to Login Screen', (WidgetTester tester) async {
    setTestScreenSize(tester);
    await tester.pumpWidget(const PGFinderApp());
    await tester.tap(find.text('Get start'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login to continue'), findsOneWidget);
  });

  testWidgets('Login validation and navigation flow', (WidgetTester tester) async {
    setTestScreenSize(tester);
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Try logging in with empty inputs
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    // Verify error text
    expect(find.text('Please enter your email or username'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);

    // Enter valid email and password
    await tester.enterText(find.byType(TextFormField).first, 'user13');
    await tester.enterText(find.byType(TextFormField).last, '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    // Advance 1s simulated delay
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify BottomNavScreen is displayed
    expect(find.byType(BottomNavScreen), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Booking'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Forgot Password navigation and UI flow', (WidgetTester tester) async {
    setTestScreenSize(tester);
    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordScreen()));

    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);

    // Tap Send Reset Link with empty input
    await tester.tap(find.widgetWithText(ElevatedButton, 'Send Reset Link'));
    await tester.pump();
    expect(find.text('Please enter your email'), findsOneWidget);

    // Enter valid email
    await tester.enterText(find.byType(TextFormField).first, 'user@example.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Send Reset Link'));
    await tester.pump();

    // Fast-forward delay
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
  });

  testWidgets('Sign Up screen form interaction', (WidgetTester tester) async {
    setTestScreenSize(tester);
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text('Sign up to get started'), findsOneWidget);

    // Fill the signup form
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(find.byType(TextFormField).at(1), 'user@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '12345678');
    await tester.enterText(find.byType(TextFormField).at(3), '12345678');

    // Agree to terms
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // Tap Sign Up
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await tester.pump();

    // Fast forward delay
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('Individual Dashboard Screens render accurately', (WidgetTester tester) async {
    setTestScreenSize(tester);

    // Test HomeScreen
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.text('Find your perfect PG'), findsOneWidget);

    // Test SavedScreen
    await tester.pumpWidget(const MaterialApp(home: SavedScreen()));
    expect(find.text('Saved PGs'), findsOneWidget);

    // Test BookingScreen
    await tester.pumpWidget(const MaterialApp(home: BookingScreen()));
    expect(find.text('My Bookings'), findsOneWidget);

    // Test ProfileScreen
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    expect(find.text('User 13'), findsOneWidget);
  });

  testWidgets('BottomNavScreen switches between tabs', (WidgetTester tester) async {
    setTestScreenSize(tester);
    await tester.pumpWidget(const MaterialApp(home: BottomNavScreen()));

    // Starts on Home
    expect(find.text('Find your perfect PG'), findsOneWidget);

    // Switch to Saved
    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();
    expect(find.text('Saved PGs'), findsOneWidget);

    // Switch to Booking
    await tester.tap(find.text('Booking'));
    await tester.pumpAndSettle();
    expect(find.text('My Bookings'), findsOneWidget);

    // Switch to Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('User 13'), findsOneWidget);
  });
}
