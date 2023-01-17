import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:united_help/routes/routes.dart';

import '../screen/email_password_confirmation.dart';
import '../services/appservice.dart';


Widget build_no_push_messages() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'images/img_27.png',
          width: 147,
              ),
        Padding(
          padding: const EdgeInsets.fromLTRB(33, 9, 33, 0),
          child: Text(
              'В вас поки що немає сповіщень',
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
  );
}