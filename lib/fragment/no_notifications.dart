import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../screen/email_password_confirmation.dart';
import '../services/debug_print.dart';



Future<LocationData?> check_location() async {

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