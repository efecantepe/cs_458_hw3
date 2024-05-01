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

Future<Map<String, dynamic>> readJsonObject(String filename) async {

  print(filename);

  final String response = await rootBundle.loadString('assets/${filename}.json');
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

  await _getCurrentPosition();

  Map<String, dynamic> marmaraData = await readJsonObject("marmara");
  //Map<String, dynamic> medData = await readJsonObject("med");
  Map<String, dynamic> blackSeaData = await readJsonObject("blackSea");
  Map<String, dynamic> egeData = await readJsonObject("ege");

  List<double> ege = getNearByRegion(egeData);
  //List<double> med = getNearByRegion(marmaraData);
  
  List<double> marmara = getNearByRegion(marmaraData);
  
  List<double> blackSea = getNearByRegion(blackSeaData);

  double nearLat = ege[0];
  double nearLng = ege[1];
  double nearDistance = ege[2];
  String seaName = "Mediterranean sea";

  // if(med[2] < nearDistance){
  //   nearLat = med[0];
  //   nearLng = med[1];
  //   nearDistance = med[2];
  //   seaName = "Mediterranean sea";
  // }

  print(nearDistance);
  print(marmara[2]);
  print(blackSea[2]);

  if(marmara[2] < nearDistance){
    nearLat = marmara[0];
    nearLng = marmara[1];
    nearDistance = marmara[2];
    seaName = "Marmara sea";
  }

  if(blackSea[2] < nearDistance){
    nearLat = blackSea[0];
    nearLng = blackSea[1];
    nearDistance = blackSea[2];
    seaName = "Black sea";
  }

  setState(() {
    _nearestSea = seaName;
    _nearestSeaKm = nearDistance;
  });
  
  // 41.283059, 31.004389


}

List<double> getNearByRegion(Map<String, dynamic> region) {

  // Ordu 40.730032, 37.546185
  double lat = _currentPosition!.latitude;
  double lng = _currentPosition!.longitude;
  
  // Karaman
  // double lat = 36.792676;
  // double lng = 32.650176;

  double nearestLat = double.maxFinite;
  double nearestLng = double.maxFinite;
  double nearestDistance = double.maxFinite;

  List<dynamic> features = region['features'];
  
  for( List<dynamic> coorList in features[0]['geometry']['coordinates'][0]){

    for (List<dynamic> coorPairs in coorList){
      

      // TODO MIGHT BE PROBLEMATIC
      
      // debugPrint(coorPairs[0].runtimeType.toString());
      // debugPrint(coorPairs[1].runtimeType.toString());      


      
      double? tempLng;
      double? tempLat;

      if (coorPairs[0] is int) {
        tempLng = (coorPairs[0] as int).toDouble();
      } else if (coorPairs[0] is double) {
        tempLng = coorPairs[0];
      }

      if (coorPairs[1] is int) {
        tempLat = (coorPairs[1] as int).toDouble();
      } else if (coorPairs[1] is double) {
        tempLat = coorPairs[1];
      }
     

      double tempDistance = calculateDistance(lat, lng, tempLat, tempLng);

      if(tempDistance < nearestDistance){
        nearestDistance = tempDistance;
        nearestLat = tempLat!;
        nearestLng = tempLng!;
      } 
    }
  }

  return [nearestLat, nearestLng, nearestDistance]; 

}


  Position? _currentPosition;
  String? _nearestSea;
  double? _nearestSeaKm;

  
  @override
  Widget build(BuildContext context){



     return Scaffold(
       appBar: AppBar(
        title: const Text("Near Sea Page"),
        actions: <Widget>[

          ElevatedButton(
            onPressed: () => {
              Navigator.pushNamed(context, "/sunPage")

            }, 
            child: Text("Go To Sun Page")
          )

        ],
        
        
      ),
       
       body: SafeArea(
         child: Center(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('Nearest Sea: ${_nearestSea ?? ""}'),
              Text('Distance in Kilometers: ${_nearestSeaKm ?? ""}'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: findNearestPoint,
                child: const Text("Get Nearest Sea"),
              )
            ],
          ),
         ),
       ),
    );
  }
}