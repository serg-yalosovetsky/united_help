import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/appservice.dart';

enum ListOrMap { list,  map }

Map<ListOrMap, String> list_or_map_text = <ListOrMap, String>{
  ListOrMap.list:  'Актуальне',
  ListOrMap.map:  'На мапі',
};

class build_switch_app_bar extends StatefulWidget {
  const build_switch_app_bar({Key? key}) : super(key: key);

  @override
  State<build_switch_app_bar> createState() => _build_switch_app_barState();
}


class _build_switch_app_barState extends State<build_switch_app_bar> {
  late AppService _app_service;

  @override
  void initState() {
    _app_service = Provider.of<AppService>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(9, 0, 19, 0),
                child: Icon(Icons.tune, color: Colors.white, size: 18,),
              ),
              CupertinoSlidingSegmentedControl<ListOrMap>(
                backgroundColor: Color(0xFFF0F3FF),   //Color(0xFFF0F3FF)
                groupValue: _app_service.list_or_map,
                onValueChanged: (ListOrMap? value) {
                  if (value != null) {
                    print(value);
                    setState(() {
                      _app_service.list_or_map = value;
                    });
                  }
                },
                children: <ListOrMap, Widget>{
                  ListOrMap.list: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      list_or_map_text[ListOrMap.list] ?? '',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  ListOrMap.map: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      list_or_map_text[ListOrMap.map] ?? '',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                      ),

                    ),
                  ),
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(9, 0, 19, 0),
                child: Icon(Icons.tune, color: Color(0xFF1C1C1E), size: 18),
              ),
            ],
          ),
        ),
      ),
    );

  }
}


