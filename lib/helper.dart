
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';



class Helper{

  static String getPlatformUri(){

    if(kIsWeb){
      return "http://localhost/3000";
    }

    if(defaultTargetPlatform == TargetPlatform.android){
      return "http://10.0.2.2:3000";
    }

    return "http://0.0.0.0/3000";
  }
  
  static String loginPhoneNumber = "${getPlatformUri()}/loginPhoneNumber";
  static String loginEmail = "${getPlatformUri()}/loginEmail";
}