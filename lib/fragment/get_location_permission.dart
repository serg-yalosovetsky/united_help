import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:united_help/fragment/welcome_button.dart';

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

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
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
          'images/img_19.png',
          width: 147,
              ),
        Padding(
          padding: const EdgeInsets.fromLTRB(33, 9, 33, 0),
          child: Text(
              'Для того, щоб скористатись пошуком івентів на карті, просимо надати доступ до геолокації',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF547FA6),
                fontWeight: FontWeight.w500,
              ),
            textAlign: TextAlign.center,
          ),
        ),
        welcome_button(
          text_style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          text: 'Надати доступ',
          padding: const [0, 16, 0, 0],
          fun: () async { await check_location();},
        ),

      ],
    ),
  );
}