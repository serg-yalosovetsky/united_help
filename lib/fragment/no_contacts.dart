import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:united_help/routes/routes.dart';

import '../screen/email_password_confirmation.dart';
import '../services/appservice.dart';


Widget build_no_contacts(BuildContext context, Roles events_for,
    {bool to_event = false}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'images/img_26.png',
          width: 147,
              ),
        Padding(
          padding: const EdgeInsets.fromLTRB(33, 9, 33, 0),
          child: Text(
            !to_event ? 'В вас немає контактів, які записані на ваші івенти'
                      : 'На ваші івенти поки ніхто не записаний',

            style: TextStyle(
                fontSize: 17,
                color: Color(0xFF547FA6),
                fontWeight: FontWeight.w500,
              ),
            textAlign: TextAlign.center,
          ),
        ),
        !to_event ?
        welcome_button(
          text_style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          text: 'Створити івенти',
          padding: const [0, 16, 0, 0],
          fun: () {
            if (events_for == Roles.refugee || events_for == Roles.volunteer)
              context.go('${APP_PAGE.new_events.to_path}/${events_for.toString().substring(6)}');
          },
        ) : Container(),

      ],
    ),
  );
}