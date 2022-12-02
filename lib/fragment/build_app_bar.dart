import 'package:flutter/material.dart';

AppBar buildAppBar(Function fun, String title,
    [String? action_text_button, Function? fun_button]) {
  const TextStyle back_style = TextStyle(color: Colors.blue, fontSize: 17);
  return AppBar(
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

        Icon(Icons.arrow_back_ios, color: Colors.white),
        const Text(
          'Назад',
          style: TextStyle(color: Colors.white),
        ),

      ],
    ),
    backgroundColor: Colors.white,
    foregroundColor: Colors.blue,
  );
}
