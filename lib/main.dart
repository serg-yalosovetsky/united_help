import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'bottom_navbar.dart';
import 'card_list.dart';
import 'card_screen.dart';
import 'map.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
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
    ToggleButtons toggle_button = ToggleButtons(
        isSelected: bool_2_list(selected_list),
        selectedColor: Colors.black,
        disabledColor: Colors.black,
        color: Colors.grey,
        fillColor: Colors.white,
        highlightColor: Colors.blue,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        renderBorder: true,
        borderColor: Colors.white,
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(10),
        selectedBorderColor: Colors.grey,
        children: childrens,
        onPressed: (int newIndex) {
          setState( () {
            selected_list = !selected_list;
          });
        }
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
              child: Center(
                  child: toggle_button
              ),
              flex: 1
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
