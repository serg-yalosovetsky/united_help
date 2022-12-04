import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:united_help/routes/routes.dart';

import '../services/appservice.dart';

enum ListOrMap { list,  map }

Map<ListOrMap, String> list_or_map_text = <ListOrMap, String>{
  ListOrMap.list:  'Актуальне',
  ListOrMap.map:  'На мапі',
};


AppBar build_switch_app_bar(AppService _app_service,
    {required Function fun, required Function to_filters}) {
  return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
            // padding: const EdgeInsets.fromLTRB(9, 0, 19, 0),
            child: Icon(Icons.tune, color: Colors.white, size: 18,),
          ),
          CupertinoSlidingSegmentedControl<ListOrMap>(
            backgroundColor: Color(0xFFF0F3FF),   //Color(0xFFF0F3FF)
            groupValue: _app_service.list_or_map,
            onValueChanged: (ListOrMap? value) {
              if (value != null) {
                fun();
                print(value);
                // setState(() {
                //   _app_service.list_or_map = value;
                // });
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
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
              child: Icon(Icons.tune, color: Color(0xFF1C1C1E), size: 18),
            ),
            onTap: () {
              to_filters();

              // context.go(APP_PAGE.filters.to_path);
            },
          ),
        ],
      ),
  //   ),
  // ),
);
}
// }


