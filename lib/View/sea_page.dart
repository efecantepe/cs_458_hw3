import 'dart:io';
import 'dart:convert';
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:postgres/legacy.dart';

import 'package:flutter/services.dart' show rootBundle;


class SeaPage extends StatefulWidget{

  @override
  State<SeaPage> createState() => _SeaPageState();
}

class _SeaPageState extends State<SeaPage> {

  String? _currentAddress;
  Position? _currentPosition;
  String? _nearestSea;

   Future<bool> _handleLocationPermission() async {
    
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {   
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }

    return true;
  }

  Future<void> _getCurrentPosition() async {

    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getNearestSea() async {

    await _getCurrentPosition();
    Position currentPosition = _currentPosition!;
    
    double lat = currentPosition.latitude;
    double long = currentPosition.longitude;

    //Position nearestSeaPoint = _getNearestSeaPoint(lat, long);


  }

Future<Map<String, dynamic>> readJsonObject() async {
  final String response = await rootBundle.loadString('assets/data.json');
  return json.decode(response);
}

double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a)); // in meters
}


Future<void> findNearestPoint() async {

  Map<String, dynamic> data = await readJsonObject();

  List<dynamic> features = data['features'];

  print(features[0]['geometry']['coordinates'][0].length);

  /*
      36.792676, 32.650176
  */


  double lat = 36.792676;
  double lng = 32.650176;

  double nearestLat = double.maxFinite;
  double nearestLng = double.maxFinite;
  double nearestDistance = double.maxFinite;


  for( List<dynamic> coorList in features[0]['geometry']['coordinates'][0]){

    for (List<dynamic> coorPairs in coorList){
      

      // TODO MIGHT BE PROBLEMATIC
      double tempLng = coorPairs[0];
      double tempLat = coorPairs[1];
     

      double tempDistance = calculateDistance(lat, lng, tempLat, tempLng);

      if(tempDistance < nearestDistance){
        nearestDistance = tempDistance;
        nearestLat = tempLat;
        nearestLng = tempLng;
      } 
    }
  }

  print(nearestDistance);
  print(nearestLat);
  print(nearestLng);

  // 41.283059, 31.004389

  try{
      List<Placemark> placemarks = await placemarkFromCoordinates(41.283059, 31.004389);

      debugPrint(placemarks[0].toString());

  }catch(e){
    debugPrint(e.toString());
  }


}   

  

  @override
  Widget build(BuildContext context){

    findNearestPoint();


     return Scaffold(
       appBar: AppBar(title: const Text("Location Page")),
       body: SafeArea(
         child: Center(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('ADDRESS: ${_currentAddress ?? ""}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _getCurrentPosition,
                child: const Text("Get Current Location"),
              )
            ],
          ),
         ),
       ),
    );
  }
}