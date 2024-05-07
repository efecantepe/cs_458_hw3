// test/sun_page_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'dart:math';
import 'package:cs_458_project3/View/sun_page.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

void main() {
  test('_degreesToRadians should correctly convert degrees to radians', () {
    final sunPageState = SunPageState();

    // Known angle in degrees and expected value in radians
    const double degrees = 180.0;
    const double expectedRadians = pi;

    final result = sunPageState.degreesToRadians(degrees);

    expect(result, expectedRadians);
  });

  // Test for `computeDistance`
  test('computeDistance should correctly calculate the distance between Earth and Sun', () {
    final sunPageState = SunPageState();

    // Example coordinates for the calculation
    const double earthLon = 0.0;
    const double earthLat = 0.0;
    const double sunLon = 0.0;
    const double sunLat = 0.0;

    // Known or approximate expected distance (for example purposes)
    const double expectedDistance = 0.0;

    final result = sunPageState.computeDistance(earthLon, earthLat, sunLon, sunLat);

    expect(result, expectedDistance);
  });
}
