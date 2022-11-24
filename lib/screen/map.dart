import 'dart:typed_data';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;


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


class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  final marker_key = GlobalKey<FormState>();

  final LatLng _center = const LatLng(49.958601, 30.227047);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> markers = get_markers();
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
        ),
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
              icon: await MarkerIcon.widgetToIcon(marker_key),
            );
            setState(()  {
                markers.add(new_marker);
            });
            print('add marker');

          },
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: markers,
        ),
      ),
    );
  }
}