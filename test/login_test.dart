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
});

}
