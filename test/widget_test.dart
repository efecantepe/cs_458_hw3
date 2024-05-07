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
  group('Login Screen Responsiveness', () {
    testWidgets('Ensure all widgets are visible and properly aligned on various screen sizes', (WidgetTester tester) async {
      // Define different screen sizes
      var screenSizes = [
        Size(320, 568),  // Small phone
        Size(411, 731),  // Average phone
        Size(1024, 768), // Tablet
      ];

      for (var screenSize in screenSizes) {
        tester.binding.window.physicalSizeTestValue = screenSize;
        tester.binding.window.devicePixelRatioTestValue = 1.0; // Adjust pixel density if needed

        // Build the Login widget
        await tester.pumpWidget(MaterialApp(home: Login()));

        // Check if text fields and buttons are visible and not overlapping
        final Finder emailField = find.byType(TextField).first;
        final Finder passwordField = find.byType(TextField).at(1);
        final Finder loginButton = find.byType(ElevatedButton);

        expect(emailField, findsOneWidget);
        expect(passwordField, findsOneWidget);
        expect(loginButton, findsOneWidget);

        // Optionally, ensure the elements are not overlapping by checking their positions
        final Rect emailRect = tester.getRect(emailField);
        final Rect passwordRect = tester.getRect(passwordField);
        final Rect buttonRect = tester.getRect(loginButton);

        // Ensure text fields are stacked above the button properly
        assert(emailRect.bottom <= passwordRect.top); // Email field is above password field
        assert(passwordRect.bottom <= buttonRect.top); // Password field is above the button

        // Reset the screen size after each test
        tester.binding.window.clearPhysicalSizeTestValue();
      }
    });
  });

  group('Sea Page Responsiveness', () {
    testWidgets('Ensure all widgets are visible and properly aligned on various screen sizes', (WidgetTester tester) async {
      var screenSizes = [
        Size(320, 568),  // Small phone
        Size(411, 731),  // Average phone
        Size(1024, 768), // Tablet
      ];

      for (var screenSize in screenSizes) {
        tester.binding.window.physicalSizeTestValue = screenSize;
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        // Build the SeaPage widget
        await tester.pumpWidget(MaterialApp(home: SeaPage()));

        // Verify key elements are found
        expect(find.text('Get Nearest Sea'), findsOneWidget);  // Checks for button presence
        expect(find.byType(ElevatedButton), findsWidgets);  // Checks if there are any elevated buttons
        // Additional checks could include:
        // - Making sure that text fields do not overlap with buttons
        // - Verifying that the "Get Nearest Sea" button is clickable and positioned at the bottom
        final Finder buttonFinder = find.byType(ElevatedButton).first;
        final Rect buttonRect = tester.getRect(buttonFinder);
        final Size screenSizeWidget = tester.getSize(find.byType(Scaffold));

        assert(buttonRect.bottom <= screenSizeWidget.height); // Ensures the button is within the visible frame

        // Reset the screen size after each test
        tester.binding.window.clearPhysicalSizeTestValue();
      }
    });
  });

  group('Sun Page Responsiveness', () {
    testWidgets('Ensure all widgets are visible and properly aligned on various screen sizes', (WidgetTester tester) async {
      var screenSizes = [
        Size(320, 568),  // Small phone
        Size(411, 731),  // Average phone
        Size(1024, 768), // Tablet
      ];

      for (var screenSize in screenSizes) {
        tester.binding.window.physicalSizeTestValue = screenSize;
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        // Build the SunPage widget
        await tester.pumpWidget(MaterialApp(home: SunPage()));

        // Verify key elements are found
        expect(find.byType(TextField), findsNWidgets(2));  // Checks for the presence of two text fields
        expect(find.text('Calculate Distance'), findsOneWidget);  // Checks for button presence
        
        // Additional checks:
        final Finder latitudeField = find.widgetWithText(TextField, 'Latitude');
        final Finder longitudeField = find.widgetWithText(TextField, 'Longitude');
        final Finder calculateButton = find.text('Calculate Distance');

        // Ensure that text fields and button are visible and not overlapping
        expect(latitudeField, findsOneWidget);
        expect(longitudeField, findsOneWidget);
        expect(calculateButton, findsOneWidget);

        // Optionally, ensure the button is clickable and positioned at the bottom
        final Rect buttonRect = tester.getRect(calculateButton);
        final Size screenSizeWidget = tester.getSize(find.byType(Scaffold));

        assert(buttonRect.bottom <= screenSizeWidget.height); // Ensures the button is within the visible frame

        // Reset the screen size after each test
        tester.binding.window.clearPhysicalSizeTestValue();
      }
    });
  });
}
