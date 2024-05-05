import 'package:flutter/material.dart';
import 'package:sweph/sweph.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';




class SunPage extends StatefulWidget {
  @override
  _SunPageState createState() => _SunPageState();
}

class _SunPageState extends State<SunPage> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController distanceController = TextEditingController();


  Future<void> calculateDistance() async{

  await Sweph.init(epheAssets: [
    "packages/sweph/assets/ephe/seas_18.se1", // For house calc
  ]);


    DateTime time = DateTime(2024, 05, 1, 00, 30);
    double jd = Sweph.swe_julday(time.year, time.month, time.day,
      time.hour + time.minute / 60, CalendarType.SE_GREG_CAL);
    
    CoordinatesWithSpeed earthPosition = Sweph.swe_calc(jd, HeavenlyBody.SE_EARTH, SwephFlag.SEFLG_SWIEPH | SwephFlag.SEFLG_SPEED);

    CoordinatesWithSpeed sunPosition = Sweph.swe_calc(
    jd,
    HeavenlyBody.SE_SUN,
    SwephFlag.SEFLG_SWIEPH | SwephFlag.SEFLG_SPEED,
  );



    print(earthPosition.latitude);
    print(earthPosition.longitude);

    print(sunPosition.latitude);
    print(sunPosition.longitude);

    double result = computeDistance(earthPosition.longitude, earthPosition.latitude, sunPosition.longitude, sunPosition.latitude);
    print(result);


     var response = await http.post(

    Uri.http("localhost:3000", "/sun"),
    headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*', // Add this header
        },
      body: jsonEncode(<String, dynamic>{
        'distance' : result,
      })
  );
  debugPrint("${response.statusCode}");


  } 

  
  double computeDistance(double earthLon, double earthLat, double sunLon, double sunLat) {
    const double earthRadius = 149597870.7; // Mean distance from Earth to Sun in kilometers (1 Astronomical Unit - AU)
    // Convert degrees to radians
    double lon1Radians = _degreesToRadians(earthLon);
    double lat1Radians = _degreesToRadians(earthLat);
    double lon2Radians = _degreesToRadians(sunLon);
    double lat2Radians = _degreesToRadians(sunLat);
    // Haversine formula
    double dlon = lon2Radians - lon1Radians;
    double dlat = lat2Radians - lat1Radians;
    double a = pow(sin(dlat / 2), 2) +
        cos(lat1Radians) * cos(lat2Radians) * pow(sin(dlon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sun Page'),
         actions: <Widget>[

          ElevatedButton(
            onPressed: () => {
              Navigator.pushNamed(context, "/seaPage")

            }, 
            child: Text("Go To Sea Page")
          )

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            TextField(
              controller: latitudeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Latitude',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: longitudeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Longitude',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                calculateDistance();
              },
              child: Text('Calculate Distance'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Distance: ${distanceController.text}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
