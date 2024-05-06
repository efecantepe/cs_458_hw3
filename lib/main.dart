import 'package:cs_458_project3/View/login.dart';
import 'package:cs_458_project3/View/sea_page.dart';
import 'package:cs_458_project3/View/sun_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
      initialRoute: '/',

      routes: {
        '/' :(context) => Login(),
        '/seaPage': (context) => SeaPage(),
        '/sunPage': (context) => SunPage()
      },
      
    );
  }
}
