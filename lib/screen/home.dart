import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/appservice.dart';

enum ListOrMap { list,  map }

Map<, Color> skyColors = <Sky, Color>{
  Sky.midnight: const Color(0xff191970),
  Sky.viridian: const Color(0xff40826d),
  Sky.cerulean: const Color(0xff007ba7),
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  late AppService _app_service;
  ListOrMap _selectedSegment = ListOrMap.list;

  @override
  void initState() {
    _app_service = Provider.of<AppService>(context, listen: false);
    _selectedSegment = _app_service.list_or_map;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CupertinoSlidingSegmentedControl<ListOrMap>(
            backgroundColor: Color(0xfF0F3FF),
            groupValue: _selectedSegment,
            onValueChanged: (ListOrMap? value) {
              if (value != null) {
                print(value);
                _app_service.list_or_map = value;
                setState(() {
                  _selectedSegment = value;
                });
              }
            },
            children: const <ListOrMap, Widget>{
              ListOrMap.list: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'List',
                  style: TextStyle(color: Colors.black),
                ),
              ),

              ListOrMap.map: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Map',
                  style: TextStyle(color: Colors.black),

                ),
              ),
            },
          ),
        ),
      ),
    );
      // CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(
      //   middle:

    //   ),
    //   child: Center(
    //     child: Text(
    //       'Selected Segment: ${_selectedSegment.name}',
    //       // style: const TextStyle(color: CupertinoColors.white),
    //     ),
    //   ),
    // );
  }
}


