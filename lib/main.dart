import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:united_help/fragment/toggle_buttons.dart';
import 'package:united_help/screen/filter_screen.dart';
import 'package:united_help/screen/welcome_role.dart';

import 'fragment/bottom_navbar.dart';
import 'fragment/card_list.dart';
import 'screen/card_screen.dart';
import 'fragment/map.dart';
void main() => runApp( WelcomeRoleScreen());

List<bool> skills_state = [];
List<bool> locations_state = [];
List<bool> employment_state = [];
List<bool> time_start_state = [];
List<bool> time_end_state = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const MyStatefulWidget(),
      theme: ThemeData(fontFamily: 'SF Pro'),
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}


class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int selected_index = 0;
  bool selected_list = true;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const bottom_selected_tab_color = Color.fromRGBO(0, 113, 216, 1);
  static const bottom_unselected_tab_color = Color.fromRGBO(142, 142, 147, 1);

  static const home_label = 'Головна';
  static const event_label = 'Мої івенти';
  static const notify_label = 'Сповіщення';
  static const accaunt_label = 'Аккаунт';
  // List<bool> isSelected = [true, false];


  static const childrens =  [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text('Актуальне', style: TextStyle(fontSize: 18)),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text('На мапі', style: TextStyle(fontSize: 18)),

    ),
  ];


  void _onItemTapped(int index) {
    setState(() {
      selected_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bool_2_list = (bool selected_list) => [selected_list, !selected_list];

    Widget toggle_button = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: const Color(0xFFF0F3FF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              // foregroundColor: Colors.black,
              padding: const EdgeInsets.fromLTRB(16.0, 13.0, 13.0, 13.0),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {},
            child: const Text('Актуальне'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // foregroundColor: Colors.black,
              shape:
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                  ),
              textStyle: const TextStyle(fontSize: 20, color: Colors.black),
              padding: const EdgeInsets.fromLTRB(16.0, 13.0, 13.0, 13.0),
              // backgroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text('На мапі'),
          ),
        ],
      ),
    );

    Map<bool, List<Widget>> home_body = {
      true: [
        const Spacer(),
        GestureDetector(
          child: const card_list(),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const JobCard(),
              ),
            );
          },
        ),
        const Spacer(),
        const card_list(),
        const Spacer(),
        const card_list(),
        const Spacer(),
      ],
      false: [
        Container(
            height: 200,
            width: 200,
            child: MapSample()
        ),
      ],

    };
    List<Widget> _widgetOptions = <Widget>[
      ListView(
        children: <Widget>[
          Spacer(),

          ...home_body[selected_list]!,
        ],
      ),
      Text(
        event_label,
        style: optionStyle,
      ),
      Text(
        notify_label,
        style: optionStyle,
      ),
      Text(
        accaunt_label,
        style: optionStyle,
      ),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      //
      // ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const build_toggle_buttons(),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const FiltersCard(),
                              ),
                          );},
                          child: const Icon(
                              Icons.tune,
                              color: Colors.black,
                          ),
                      ),
                    ],
                  )
              )
            ),
            Expanded(
              child: Center(
                child: _widgetOptions.elementAt(selected_index),
              ),
              flex: 15,
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
