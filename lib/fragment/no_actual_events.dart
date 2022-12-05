import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../screen/email_password_confirmation.dart';


Widget build_no_actual_widgets() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/img_23.png',
            width: 91,
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(33, 9, 33, 0),
            child: Text(
                'У вас немає актуальних івентів',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF547FA6),
                  fontWeight: FontWeight.w500,
                ),
              textAlign: TextAlign.center,
            ),
          ),


        ],
      ),
    ),
  );
}