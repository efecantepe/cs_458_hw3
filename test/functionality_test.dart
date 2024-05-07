import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cs_458_project3/View/sea_page.dart';
import 'package:flutter/material.dart';

// Create a class to mock the Geolocator
class MockGeolocator extends Mock implements GeolocatorPlatform {
  @override
  Future<bool> isLocationServiceEnabled() {
    return super.noSuchMethod(
      Invocation.method(#isLocationServiceEnabled, []),
      returnValue: Future.value(true), // Return a default value for initialization
      returnValueForMissingStub: Future.value(false)); // Return false when not stubbed
  }

  @override
  Future<LocationPermission> checkPermission() {
    return super.noSuchMethod(
      Invocation.method(#checkPermission, []),
      returnValue: Future.value(LocationPermission.denied),
      returnValueForMissingStub: Future.value(LocationPermission.deniedForever));
  }
  
  @override
  Future<LocationPermission> requestPermission() {
    return super.noSuchMethod(
      Invocation.method(#requestPermission, []),
      returnValue: Future.value(LocationPermission.whileInUse),
      returnValueForMissingStub: Future.value(LocationPermission.denied));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SeaPage Tests', () {
     late MockGeolocator mockGeolocator;

    setUp(() {
      mockGeolocator = MockGeolocator();

      // Set default behaviors
      when(mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
      when(mockGeolocator.checkPermission()).thenAnswer((_) async => LocationPermission.denied);
      when(mockGeolocator.requestPermission()).thenAnswer((_) async => LocationPermission.whileInUse);
    });

    testWidgets('_handleLocationPermission handles disabled service', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SeaPage()));
      await tester.tap(find.text('Get Nearest Sea'));
      await tester.pumpAndSettle(); // Ensure SnackBar has time to display

      expect(find.text('Location services are disabled. Please enable the services'), findsOneWidget);
    });

    testWidgets('_handleLocationPermission handles permission denied forever', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SeaPage()));
      await tester.tap(find.text('Get Nearest Sea'));
      await tester.pumpAndSettle(); // Ensure SnackBar has time to display

      expect(find.text('Location permissions are permanently denied, we cannot request permissions.'), findsOneWidget);
    });

    testWidgets('_getCurrentPosition fetches and displays location', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SeaPage()));

      // Tap the 'Get Nearest Sea' button which should trigger _getCurrentPosition
      await tester.tap(find.text('Get Nearest Sea'));
      await tester.pumpAndSettle();  // Wait for all animations and async calls to complete.

      // Check if the latitude and longitude are displayed
      expect(find.textContaining('LAT:'), findsOneWidget);
      expect(find.textContaining('LNG:'), findsOneWidget);
    });

    testWidgets('_getNearestSea fetches and displays nearest sea', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SeaPage()));

      // Tap the 'Get Nearest Sea' button which should trigger _getNearestSea
      await tester.tap(find.text('Get Nearest Sea'));
      await tester.pumpAndSettle();  // Wait for all animations and async calls to complete.

      // Check if the latitude and longitude are displayed
      expect(find.textContaining('Nearest Sea:'), findsOneWidget);
      expect(find.textContaining('Distance in Kilometers:'), findsOneWidget);
    });
  });
}