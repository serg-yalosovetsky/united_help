import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:united_help/routes/routes.dart';

import '../services/appservice.dart';

enum SwitchEnum { first,  second }

Map<SwitchEnum, String> list_or_map_text = <SwitchEnum, String>{
  SwitchEnum.first:  'Актуальне',
  SwitchEnum.second:  'На мапі',
};

Map<SwitchEnum, String> actual_or_history_text = <SwitchEnum, String>{
  SwitchEnum.first:  'Мої івенти',
  SwitchEnum.second:  'Історія',
};


AppBar build_switch_app_bar(
    AppService _app_service,
    {required Function fun,
    Function? to_filters,
    bool map_or_history = true,
      }) {
  var switch_enum_map = map_or_history ? list_or_map_text : actual_or_history_text;
  print('switch_enum_map $switch_enum_map');
  return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
            child: Icon(Icons.tune, color: Colors.white, size: 18,),
          ),
          CupertinoSlidingSegmentedControl<SwitchEnum>(
            backgroundColor: Color(0xFFF0F3FF),   //Color(0xFFF0F3FF)
            groupValue: map_or_history ? _app_service.list_or_map : _app_service.actual_or_history,
            onValueChanged: (SwitchEnum? value) {
              if (value != null) {
                fun();
              }
            },
            children: <SwitchEnum, Widget>{
              SwitchEnum.first: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  switch_enum_map[SwitchEnum.first] ?? '',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SwitchEnum.second: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  switch_enum_map[SwitchEnum.second] ?? '',
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
            onTap: to_filters!=null ? () {
              to_filters();
            } : null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
              child: Icon(
                  Icons.tune,
                  color: to_filters!=null ? const Color(0xFF1C1C1E) : Colors.white,
                  size: 18,
              ),
            ),
          ),
        ],
      ),
  //   ),
  // ),
);
}
// }


