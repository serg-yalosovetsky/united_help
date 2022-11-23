import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:united_help/screen/home.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/password_recovery.dart';


void main() => runApp( MyApp());

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
