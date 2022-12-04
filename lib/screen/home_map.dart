import 'dart:typed_data';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
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
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
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

  void initState() {
    _app_service = Provider.of<AppService>(context, listen: false);
  }

  Set<Marker> markers = get_markers();
  final GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: build_switch_app_bar(_app_service,
                fun: () {
                  setState(() {
                    if (_app_service.list_or_map == ListOrMap.list){
                      _app_service.list_or_map = ListOrMap.map;
                      context.go(APP_PAGE.home_map.to_path);
                    } else {
                      _app_service.list_or_map = ListOrMap.list;
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {

            BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(),
              "images/img.png",
            );
            // setState(() {
            //   markers.add(
            //       Marker( //add start location marker
            //         markerId: MarkerId('startLocation.toString()'),
            //         position: LatLng(49.958601, 30.217047), //position of marker
            //         infoWindow: InfoWindow( //popup info
            //           title: 'Starting Point ',
            //           snippet: 'Start Marker',
            //         ),
            //         icon: markerbitmap, //Icon for Marker
            //       )
            //   );
              // markers = markers;
            // });

            print('add marker');
            var new_marker = await Marker(
              markerId: MarkerId('third'),
              position: LatLng(49.988601, 30.217047), //position of marker
              infoWindow: InfoWindow( //popup info
                title: 'My sadle ',
                snippet: 'Msditle',
              ),
              // icon: await MarkerIcon.downloadResizePictureCircle(
              //   // assetPath: 'images/img_ellipse11.png',
              //   //   height: 20,
              //   //   width: 20,
              //     'https://cdn-icons-png.flaticon.com/512/6750/6750242.png',
              //     size: 150,
              //     addBorder: true,
              //     borderColor: Colors.white,
              //     borderSize: 15
              // ),
              // icon: await MarkerIcon.pictureAssetWithCenterText(
              //     assetPath: 'images/img_ellipse11.png',
              //     text: 'some rfgmpofr text',
              //     size: Size.square(300),
              //     fontSize: 30,
              //     fontColor: Colors.white,
              // ),
              // icon: await MarkerIcon.widgetToIcon(globalKey),
              icon: await MarkerIcon.circleCanvasWithText(size: Size.square(150), circleColor: Colors.white, fontSize: 28, text: 'Text sfdfsdf')
            );
            setState(()  {
                markers.add(new_marker);
            });
            print('add marker');

          },
        ),
        body: Stack(
          children: [
            // MyMarker(globalKey),
            GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: markers,
          ),
          Card(),
          ],
        ),
        bottomNavigationBar: buildBottomNavigationBar(),

      ),
    );
  }
}