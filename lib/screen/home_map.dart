import 'dart:typed_data';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/get_location_permission.dart';
import 'dart:ui' as ui;

import '../fragment/bottom_navbar.dart';
import '../fragment/switch_app_bar.dart';
import '../routes/routes.dart';
import '../services/appservice.dart';
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

dynamic get_markers()  {

  Set<Marker> markers = Set();
  // final Uint8List? customMarker= await getBytesFromAsset(
  //     path: 'images/img.png',
  //     width: 50 // size of custom image as marker
  // );
  markers.add(
      Marker( //add first marker
        markerId: MarkerId('first'),
        position: LatLng(49.908697, 30.217050), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'My Custom Title ',
          snippet: 'My Custom Subtitle',
        ),
        // icon: BitmapDescriptor.fromBytes(customMarker!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan), //Icon for Marker
      ));

  markers.add(Marker( //add second marker
    markerId: MarkerId('second'),
    position: LatLng(49.957509, 30.224144), //position of marker
    infoWindow: InfoWindow( //popup info
      title: 'My Custom Title ',
      snippet: 'My Custom Subtitle',
    ),
    icon: BitmapDescriptor.defaultMarker, //Icon for Marker
  ));
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
    init_location().then(
        (result) {
          print("result: $result");
          setState(() {});
        }
      );
    super.initState();
  }

  Set<Marker> markers = get_markers();
  final GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {

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
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () async {
        //
        //     BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
        //       ImageConfiguration(),
        //       "images/img.png",
        //     );
        //     // setState(() {
        //     //   markers.add(
        //     //       Marker( //add start location marker
        //     //         markerId: MarkerId('startLocation.toString()'),
        //     //         position: LatLng(49.958601, 30.217047), //position of marker
        //     //         infoWindow: InfoWindow( //popup info
        //     //           title: 'Starting Point ',
        //     //           snippet: 'Start Marker',
        //     //         ),
        //     //         icon: markerbitmap, //Icon for Marker
        //     //       )
        //     //   );
        //     // markers = markers;
        //     // });
        //
        //     print('add marker');
        //     var new_marker = await Marker(
        //         markerId: MarkerId('third'),
        //         position: LatLng(49.988601, 30.217047), //position of marker
        //         infoWindow: InfoWindow( //popup info
        //           title: 'My sadle ',
        //           snippet: 'Msditle',
        //         ),
        //         // icon: await MarkerIcon.downloadResizePictureCircle(
        //         //   // assetPath: 'images/img_ellipse11.png',
        //         //   //   height: 20,
        //         //   //   width: 20,
        //         //     'https://cdn-icons-png.flaticon.com/512/6750/6750242.png',
        //         //     size: 150,
        //         //     addBorder: true,
        //         //     borderColor: Colors.white,
        //         //     borderSize: 15
        //         // ),
        //         // icon: await MarkerIcon.pictureAssetWithCenterText(
        //         //     assetPath: 'images/img_ellipse11.png',
        //         //     text: 'some rfgmpofr text',
        //         //     size: Size.square(300),
        //         //     fontSize: 30,
        //         //     fontColor: Colors.white,
        //         // ),
        //         // icon: await MarkerIcon.widgetToIcon(globalKey),
        //         icon: await MarkerIcon.circleCanvasWithText(size: Size.square(150), circleColor: Colors.white, fontSize: 28, text: 'Text sfdfsdf')
        //     );
        //     setState(()  {
        //       markers.add(new_marker);
        //     });
        //     print('add marker');
        //
        //   },
        // ),
        //
        body: Stack(
          children: [
            // MyMarker(globalKey),
            GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
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
                    build_stack_map_card(),
                    build_stack_map_card(),
                  ],
                )
            ),
          ],
          alignment: AlignmentDirectional.bottomStart,
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

class build_stack_map_card extends StatelessWidget {
  const build_stack_map_card({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 16 - 40,
      margin: EdgeInsets.fromLTRB(0, 0, 11, 18),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 19, 0),
              child: Container(
                height: 91,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                      'images/img_4.png',
                      // width: 100,
                    fit: BoxFit.fill,
                      // height: 91,
                  ),
                ),

              ),

            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 0, 7),
                  child: Text('Гуманітарний штаб',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF002241),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,6,0),
                        child: Icon(Icons.access_time_outlined),
                      ),
                      Text(
                        'Постійна зайнятість',
                          style: TextStyle(
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,6,0),
                      child: Icon(Icons.location_on),
                    ),
                    Text('вул. Валова, 27',
                      style: TextStyle(
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
    );
  }
}