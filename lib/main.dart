import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:united_help/screen/home.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/map.dart';
import 'package:united_help/screen/password_recovery.dart';


void main() => runApp( GoogleMapScreen());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // title: _title,
      // home: const HomeScreen(),
      // theme: ThemeData(fontFamily: 'SF Pro'),
      routerConfig: go_router,
    );
  }
}
