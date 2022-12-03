import 'package:flutter/material.dart';

AppBar buildAppBar(Function fun, String title,
    [String? action_text_button, Function? fun_button]) {
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

        action_text_button==null ? Icon(
            Icons.arrow_back_ios,
            color: Colors.white) : Container(),
        action_text_button==null ? const Text(
          'Назад',
          style: TextStyle(color: Colors.white),
        ): GestureDetector(
          child: Text(
            action_text_button,
            style: TextStyle(color: Color(0xFF8E8E93)),
          ),
          onTap: fun_button?.call(),
          // onTap: fun_button != null ? fun_button?() : null,
        ),
      ],
    ),
    backgroundColor: Colors.white,
    foregroundColor: Colors.blue,
  );
}
