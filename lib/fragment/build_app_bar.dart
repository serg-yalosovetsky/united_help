import 'package:flutter/material.dart';

AppBar buildAppBar(Function fun, String title,
    [Widget? action_button_widget,]) {
  const TextStyle back_style = TextStyle(color: Colors.blue, fontSize: 17);
  return AppBar(
    automaticallyImplyLeading: false,
    title: Row(

      children: [
        GestureDetector(
          child: Tooltip(
            message: 'Назад',
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios),
                Text(
                  'Назад',
                  style: back_style,
                ),
              ],
            ),
          ),
          onTap: () {
            // app_service.onboarding = false;
            fun();
          },
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              title,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        action_button_widget==null ? Icon(
            Icons.arrow_back_ios,
            color: Colors.white) : Container(),
        action_button_widget==null ? const Text(
          'Назад',
          style: TextStyle(color: Colors.white),
        ): action_button_widget,
      ],
    ),
    backgroundColor: Colors.white,
    foregroundColor: Colors.blue,
  );
}
