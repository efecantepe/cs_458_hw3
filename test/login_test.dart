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

class MockBuildContext extends Mock implements BuildContext {}


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

    group('Login Handling Tests', () {
      test('Successful Login', () async {
        MockBuildContext mockContext = MockBuildContext();
        // Set up your mock expectations or results
        // Example: Assuming handleLogin changes a state or shows a dialog on successful login

        // Call the asynchronous function and wait for it to complete
        await Login.handleLogin('valid@email.com', 'correctPassword', mockContext);

        // Verify the results or interactions
        // Example: Check if a function on mockContext was called
        // verify(mockContext.someMethod()).called(1);
      });

      test('Login With Incorrect Credentials', () async {
        MockBuildContext mockContext = MockBuildContext();
        // Example setup for failed login attempt
        // when(...) setup for mocking if necessary

        // Call the asynchronous function
        await Login.handleLogin('user@example.com', 'wrongPassword', mockContext);

        // Assertions or verifications for failure case
        // verify(mockContext.someMethod()).called(1);
      });
  });
});

}
