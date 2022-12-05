import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../screen/email_password_confirmation.dart';



Future<LocationData?> check_location() async {
  // LocationData stub_location_data = LocationData.fromMap({
  //   'latitude': 50.450001,
  //   'longitude': 30.523333,
  //   'accuracy': 0,
  //   'altitude': 0,
  //   'speed': 0,
  //   'speed_accuracy': 0,
  //   'heading': 0,
  // });
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  print(0);
  _serviceEnabled = await location.serviceEnabled();
  print(1);
  if (!_serviceEnabled) {
    print(2);
    _serviceEnabled = await location.requestService();
    print(3);
    if (!_serviceEnabled) {
      print(4);
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  return location.getLocation();
}


Widget build_get_location_permission() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'images/img_21.png',
          width: 147,
              ),
        Padding(
          padding: const EdgeInsets.fromLTRB(33, 9, 33, 0),
          child: Text(
              'В вас поки що немає сповіщень',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF547FA6),
                fontWeight: FontWeight.w500,
              ),
            textAlign: TextAlign.center,
          ),
        ),

      ],
    ),
  );
}