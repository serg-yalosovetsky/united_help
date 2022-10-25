import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class OutlinedCardExample extends StatelessWidget {
  const OutlinedCardExample({super.key});
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle timerStyle = TextStyle(fontSize: 18,);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.all(20),
        child: Column(

          children: [
            Container(
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('images/Best-TED-Talks-From-The-Curator-Himself-.jpg'),
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0), bottom: Radius.zero),
                color: Colors.redAccent,
              ),
            ),
            Container(
            height: 180,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: Center(child: Text('TedX UA про волонтерство', style: optionStyle,)),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 8, 12),
                  child: Row(
                    children: [
                      Icon(Icons.access_time),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Text('Постійна зайнятість', style: timerStyle,),
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 8, 30),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Вул. Валова, 27', style: timerStyle,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
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
      // list of booleans
        isSelected: bool_2_list(selected_list),
        // text color of selected toggle
        selectedColor: Colors.black,
        disabledColor: Colors.black,
        // text color of not selected toggle
        color: Colors.grey,
        // fill color of selected toggle
        fillColor: Colors.white,
        // when pressed, splash color is seen
        // splashColor: Colors.red,
        // long press to identify highlight color
        highlightColor: Colors.blue,
        // if consistency is needed for all text style
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        // border properties for each toggle
        renderBorder: true,
        borderColor: Colors.white,
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(10),
        selectedBorderColor: Colors.grey,
        // add widgets for which the users need to toggle
        children: childrens,
        // to select or deselect when pressed
        onPressed: (int newIndex) {
          setState( () {
            selected_list = !selected_list;
          });
        }
    );

    Map<bool, List<Widget>> home_body = {
      true: [
        Spacer(),
        OutlinedCardExample(),
        Spacer(),
        OutlinedCardExample(),
        Spacer(),
        OutlinedCardExample(),
        Spacer(),
      ],
      false: [
        MapSample(),
      ],

    };
    List<Widget> _widgetOptions = <Widget>[
      ListView(
        children: <Widget>[
          Spacer(),
          Center(
            child: toggle_button
          ),
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
    Widget card = Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Outlined Card')),
        ),
      ),
    );
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(selected_index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: home_label,
            // backgroundColor: bottom_tab_color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: event_label,
            // backgroundColor: bottom_tab_color,

            // backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: notify_label,
            // backgroundColor: bottom_tab_color,
            // backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: accaunt_label,
            // backgroundColor: bottom_tab_color,

            // backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: selected_index,
        selectedItemColor: bottom_selected_tab_color,
        unselectedItemColor: bottom_unselected_tab_color,
        onTap: _onItemTapped,
      ),
    );
  }
}
