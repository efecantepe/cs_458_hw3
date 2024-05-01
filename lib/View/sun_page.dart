import 'package:flutter/material.dart';

class SunPage extends StatefulWidget {
  @override
  _SunPageState createState() => _SunPageState();
}

class _SunPageState extends State<SunPage> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

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
                // Add your calculation logic here
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
