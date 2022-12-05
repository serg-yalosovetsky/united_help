import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../screen/email_password_confirmation.dart';


Widget build_no_events() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'images/img_20.png',
          width: 147,
              ),
        Padding(
          padding: const EdgeInsets.fromLTRB(33, 9, 33, 0),
          child: Text(
              'В вас немає івентів, на які ви записані',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF547FA6),
                fontWeight: FontWeight.w500,
              ),
            textAlign: TextAlign.center,
          ),
        ),
        welcome_button(
          text_style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          text: 'Шукати івенти',
          padding: const [0, 16, 0, 0],
          fun: () { },
        ),

      ],
    ),
  );
}