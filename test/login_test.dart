// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs_458_project3/View/login.dart';
import 'package:cs_458_project3/View/sea_page.dart';
import 'package:cs_458_project3/View/sun_page.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



// Mock classes
class MockLoginActions extends Mock implements LoginActions {}

void main() {
  group('Phone Validation Tests', () {
    test('Empty Phone Number', () {
      var result = Login.isValidPhone('');
      expect(result, false);
    });

    test('Valid Phone Number', () {
      var result = Login.isValidPhone('1234567890');
      expect(result, true);
    });

    test('Invalid Phone Number', () {
      var result = Login.isValidPhone('12345');
      expect(result, false);
    });
    test('Char Inside Phone Number', () {
      var result = Login.isValidPhone('1a2345');
      expect(result, false);
    });
    test('Char Inside Phone Number and Right Length', () {
      var result = Login.isValidPhone('12345b7890');
      expect(result, false);
    });
  });

  group("Network Connection", (){
    test('Network Access Test', () async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');
      expect(response.statusCode, 200);
    } catch (e) {
      print('Error during network request: $e');
    }
  });
  });
  group('Email Validation Tests', () {
    test('Empty Email', () {
      var result = Login.isValidEmail('');
      expect(result, false);
    });

    test('Valid Email', () {
      var result = Login.isValidEmail('example@test.com');
      expect(result, true);
    });

    test('Invalid Email', () {
      var result = Login.isValidEmail('example.com');
      expect(result, false);
    });
    test('Long TLD', () {
      var result = Login.isValidEmail('example@test.exampleexampleexample');
      expect(result, false);
    });

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
  });
});

}
