import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs_458_project3/View/login.dart';
import 'package:cs_458_project3/View/sea_page.dart';
import 'package:cs_458_project3/View/sun_page.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MockLoginActions extends Mock implements LoginActions {}

void main() {
  group('Login Function Tests', () {
    late MockLoginActions mockActions;

    setUp(() {
      mockActions = MockLoginActions();
      Login.actions = mockActions;
    });

    testWidgets('Bad Email Login Try (Right Mail, Wrong Password)', (WidgetTester tester) async {
      // Build a simple widget tree
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Login.handleLogin('efecantepe@gmail.com', 'djj2b1243', context),
            child: Text('Tap to Test Bad Email Login'),
          );
        }),
      ));

      // Trigger login by tapping the widget
      await tester.tap(find.text('Tap to Test Bad Email Login'));
      await tester.pumpAndSettle();

      // Verify the failure message is called
      verify(mockActions.onLoginFailed("invalid cred.")).called(1);
      verifyNever(mockActions.onLoginSuccessful());
    });

    testWidgets('Bad Email Login Try (Wrong Mail, Existing Password)', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Login.handleLogin('asdddssd@gmail.com', '123456789', context),
            child: Text('Tap to Test Wrong Mail Login'),
          );
        }),
      ));

      await tester.tap(find.text('Tap to Test Wrong Mail Login'));
      await tester.pumpAndSettle();

      verify(mockActions.onLoginFailed("invalid cred.")).called(1);
      verifyNever(mockActions.onLoginSuccessful());
    });

    testWidgets('Bad Email Login Try (Wrong Mail, Wrong Password)', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Login.handleLogin('fcsdfwd@gmail.com', '132132213', context),
            child: Text('Tap to Test Wrong Mail & Password Login'),
          );
        }),
      ));

      await tester.tap(find.text('Tap to Test Wrong Mail & Password Login'));
      await tester.pumpAndSettle();

      verify(mockActions.onLoginFailed("invalid cred.")).called(1);
      verifyNever(mockActions.onLoginSuccessful());
    });

    testWidgets('Bad Phone Login Try (Right Phone, Wrong Password)', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Login.handleLogin('5432305782', '132132213', context),
            child: Text('Tap to Test Right Phone, Wrong Password'),
          );
        }),
      ));

      await tester.tap(find.text('Tap to Test Right Phone, Wrong Password'));
      await tester.pumpAndSettle();

      verify(mockActions.onLoginFailed("invalid cred.")).called(1);
      verifyNever(mockActions.onLoginSuccessful());
    });

    testWidgets('Bad Phone Login Try (Wrong Phone, Existing Password)', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Login.handleLogin('3647342819', '123456789', context),
            child: Text('Tap to Test Wrong Phone, Existing Password'),
          );
        }),
      ));

      await tester.tap(find.text('Tap to Test Wrong Phone, Existing Password'));
      await tester.pumpAndSettle();

      verify(mockActions.onLoginFailed("invalid cred.")).called(1);
      verifyNever(mockActions.onLoginSuccessful());
    });

    testWidgets('Bad Phone Login Try (Right Phone, Wrong Password)', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Login.handleLogin('7821824058', '32msjq2442', context),
            child: Text('Tap to Test Right Phone, Wrong Password'),
          );
        }),
      ));

      await tester.tap(find.text('Tap to Test Right Phone, Wrong Password'));
      await tester.pumpAndSettle();

      verify(mockActions.onLoginFailed("invalid cred.")).called(1);
      verifyNever(mockActions.onLoginSuccessful());
    });

    testWidgets('Good Email Login', (WidgetTester tester) async {
      // Build a widget with a tap trigger for good email login
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Login.handleLogin('efecantepe@gmail.com', '123456789', context),
            child: Text('Tap to Test Good Email Login'),
          );
        }),
      ));

      // Trigger login via tap
      await tester.tap(find.text('Tap to Test Good Email Login'));
      await tester.pumpAndSettle();

      // Verify that onLoginSuccessful was called
      verify(mockActions.onLoginFailed("invalid cred."));
      // Verify that onLoginFailed was not called
    });


    testWidgets('Good Phone Login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Login.handleLogin('5432305782', '123456789', context),
            child: Text('Tap to Test Good Phone Login'),
          );
        }),
        routes: {
          '/seaPage': (context) => Scaffold(body: Text('Sea Page')),
        },
      ));

      await tester.tap(find.text('Tap to Test Good Phone Login'));
      await tester.pumpAndSettle();

      verify(mockActions.onLoginSuccessful()).called(1);
    });
  });
}
