import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/get_location_permission.dart';
import 'package:united_help/fragment/no_internet.dart';
import 'package:united_help/models/events.dart';
import 'dart:ui' as ui;

import '../constants/colors.dart';
import '../constants/styles.dart';
import '../fragment/bottom_navbar.dart';
import '../fragment/switch_app_bar.dart';
import '../routes/routes.dart';
import '../providers/appservice.dart';
import '../providers/filters.dart';
import '../services/show_nice_time.dart';
import 'filter_screen.dart';




final Key boxKey = GlobalKey(debugLabel: 'Colored box key');

class ColoredBox extends StatelessWidget {
  ColoredBox({required Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Text('_number.toString(),'),
    );
  }
}

class BoxContainer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: ColoredBox(
        key: boxKey,
      )
    );
  }
}



Future<Uint8List?> getBytesFromAsset({required String path, required int width})async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width
  );
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png))
      ?.buffer.asUint8List();
}

dynamic get_markers(List<Event> events)  {

  Set<Marker> markers = Set();
  for (Event event in events) {
    print(239845);
    print('${event.location_lat}, ${event.location_lon}');
    markers.add(
        Marker( //add first marker
          markerId: MarkerId('first'),
          position: LatLng(event.location_lat, event.location_lon), //position of marker
          infoWindow: InfoWindow( //popup info
            title: event.name,
            snippet: 'lat:${event.location_lat}, lon:${event.location_lon}',
          ),
          // icon: BitmapDescriptor.fromBytes(customMarker!),
          // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan), //Icon for Marker
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ));
  }


  // markers.add(Marker( //add second marker
  //   markerId: MarkerId('second'),
  //   position: LatLng(49.957509, 30.224144), //position of marker
  //   infoWindow: InfoWindow( //popup info
  //     title: 'My Custom Title ',
  //     snippet: 'My Custom Subtitle',
  //   ),
  //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
  // ));
  return markers;
}


class MyMarker extends StatelessWidget {
  // declare a global key and get it trough Constructor

  MyMarker(this.globalKeyMyWidget);
  final GlobalKey globalKeyMyWidget;

  @override
  Widget build(BuildContext context) {
    // wrap your widget with RepaintBoundary and
    // pass your global key to RepaintBoundary
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 180,
            decoration:
            BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          ),
          Container(
              width: 220,
              height: 150,
              decoration:
              BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.accessibility,
                    color: Colors.white,
                    size: 35,
                  ),
                  Text(
                    'Widget',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}



class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(49.958601, 30.227047);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  late AppService _app_service;
  late Filters filters;

  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;


  Future<LocationData?> init_location() async {
    LocationData stub_location_data = LocationData.fromMap({
      'latitude': 50.450001,
      'longitude': 30.523333,
      'accuracy': 0,
      'altitude': 0,
      'speed': 0,
      'speed_accuracy': 0,
      'heading': 0,
    });
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

  void initState() {
    _app_service = Provider.of<AppService>(context, listen: false);
    filters = Provider.of<Filters>(context, listen: false);
    init_location().then(
        (result) {
          print("result: $result");
          setState(() {});
        }
      );
    super.initState();
  }
  late Set<Marker> markers;
  late List<Event> events;
  final GlobalKey globalKey = GlobalKey();
  int current_camera_position = 0;

  @override
  Widget build(BuildContext context) {
    String full_event_query = '';
    if (_app_service.event_query.isNotEmpty)
      full_event_query += '?${_app_service.event_query}';

    Widget map_screen = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: build_switch_app_bar(_app_service,
            fun: () {
              setState(() {
                if (_app_service.list_or_map == SwitchEnum.first){
                  _app_service.list_or_map = SwitchEnum.second;
                  context.go(APP_PAGE.home_map.to_path);
                } else {
                  _app_service.list_or_map = SwitchEnum.first;
                  context.go(APP_PAGE.home_list.to_path);
                }
              });
            },
            to_filters: () {
              // context.go(APP_PAGE.filters.to_path);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FiltersCard(),
                ),
              );
            }),

        body: FutureBuilder<Events>(
          future: fetchEvents(full_event_query, _app_service, filters),
          builder: (BuildContext context, AsyncSnapshot<Events> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              markers = get_markers(snapshot.data!.list);
              events = snapshot.data!.list;
              return Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  // MyMarker(globalKey),
                  GoogleMap(
                    onMapCreated: (controller) { //method called when map is created
                        setState(() {
                          mapController = controller;
                        });
                      },
                    myLocationEnabled: true,
                    compassEnabled: true,
                    tiltGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          events[current_camera_position].location_lat,
                          events[current_camera_position].location_lon),
                      zoom: 9.0,
                    ),

                    markers: markers,
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 0,
                          ),
                          ...List.generate(
                              events.length,
                              (index) => build_stack_map_card(
                                event: events[index],
                                fun: () {
                                  setState(() {
                                    current_camera_position = index;
                                    mapController?.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(target:
                                                LatLng(
                                                    events[current_camera_position].location_lat,
                                                    events[current_camera_position].location_lon
                                                ),
                                                zoom: 17
                                            ),
                                          //17 is new zoom level
                                        ),
                                    );

                                  });
                                },
                              )
                          ),
                        ],
                      )
                  ),
                ],
              );
            }
            return build_no_internet(error: snapshot.error.toString());
          },
        ),
        bottomNavigationBar: buildBottomNavigationBar(),

      ),
    );


    Widget future =  FutureBuilder<LocationData?>(
      future: init_location(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<LocationData?> snapshot) {
        Widget result;
        if (snapshot.hasData && snapshot.data != null) {
          result = Container();
        } else if (snapshot.hasData && snapshot.data == null) {
          result = build_get_location_permission();

        } else if (snapshot.hasError) {
          result = map_screen;

        } else {
          result = map_screen;

        }
        return result;
      },
    );
 return future;
  }
}


String trim_text(String init_str){
  if (init_str.isEmpty || init_str.split(' ').length <= 2){
    return init_str;
  }
  else {
    List<String> list_str = init_str.split(' ');
    String str_res = '';
    for (int i = 0; i < init_str.split(' ').length; i++) {
      if (list_str.sublist(0, i).join(' ').length < 22){
        str_res = list_str.sublist(0, i).join(' ');
      }
      else {
        return str_res;
      }
    }
    return '${list_str[0]} ${list_str[1]}..';
  }
}

class build_stack_map_card extends StatelessWidget {
  const build_stack_map_card({
    Key? key,
    required this.event,
    this.fun
  }) : super(key: key);
  final Event event;
  final dynamic fun;

  @override
  Widget build(BuildContext context) {
    String employment_string = '';
    if (event.employment == 0)
      employment_string = 'Постійна зайнятість';
    else if (event.employment == 1)
      employment_string = show_nice_time(event.start_time, event.end_time);
    else if (event.employment == 2)
      employment_string = show_nice_time(event.start_time);
    return GestureDetector(
      onTap: () {if (fun!=null) fun();},
      child: Container(
        width: MediaQuery.of(context).size.width - 16 - 40,
        margin: const EdgeInsets.fromLTRB(0, 0, 11, 18),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 19, 0),
                child: Container(
                  height: 91,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      image: CachedNetworkImageProvider(event.image),
                      fit: BoxFit.fill,
                      // height: 142,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 0, 7),
                    child: Text(
                      trim_text(event.name),
                      style: StyleConstant.bold_main,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0,0,6,0),
                          child: Icon(Icons.access_time_outlined),
                        ),
                        Text(
                            employment_string,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Color(0xFF7C7C7C),
                              fontWeight: FontWeight.w400,
                            ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0,0,6,0),
                        child: Icon(Icons.location_on),
                      ),
                      Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xFF7C7C7C),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ],
          ),
      ),
    );
  }
}