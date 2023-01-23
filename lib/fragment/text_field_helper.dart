import 'package:flutter/material.dart';
import 'package:united_help/providers/appservice.dart';

Widget build_helper_button(String helper, Function fun ){ //AppService app_service
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 11),
        child: Text(
            helper,
            style: TextStyle(fontSize: 17),
        ),
      ),
      onTap: () {
        fun(helper);
        // app_service.helper_city = helper;
      },
    );
}

Widget build_helpers_text(List<String> helpers, Function fun) {

  List<Widget> helper_widget_list = <Widget>[];

  for (var helper in helpers){
    helper_widget_list.add(build_helper_button(helper, fun));
  }
  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      margin: EdgeInsets.fromLTRB(32, 15, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: helper_widget_list,
      ),
    ),
  );
}