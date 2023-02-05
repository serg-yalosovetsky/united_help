import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:united_help/routes/routes.dart';

import '../models/notify.dart';
import '../screen/email_password_confirmation.dart';
import '../providers/appservice.dart';
import '../services/debug_print.dart';
import '../services/notifications.dart';


Widget build_no_push_messages() {
  return Center(
    child: GestureDetector(
      onTap: () async {
        dPrint('tap');

        try {
          dPrint('tap2');
          var counter = await Hive.openBox<int>('counter');
          dPrint(counter.values);
          dPrint('tap3');
        }
        catch (e) {
          dPrint('tap4');
          dPrint(e);
          registerHive();
        }


        dPrint('box.length');
        dPrint(await Hive.boxExists('notifications'));
        dPrint(await Hive.boxExists('volunteer_notifications'));
        dPrint(await Hive.boxExists('organizer_notifications'));
        dPrint(await Hive.boxExists('refugee_notifications'));
        try{
          if (!Hive.isBoxOpen('organizer_notifications')) {
            await Hive.openBox('organizer_notifications');
          }
          Box organizer_box = Hive.box('organizer_notifications');
          dPrint('organizer_box.length');
          dPrint(organizer_box.length);

          if (!Hive.isBoxOpen('volunteer_notifications')) {
            await Hive.openBox('volunteer_notifications');
          }
          Box volunteer_box = Hive.box('volunteer_notifications');
          dPrint('volunteer_box.length');
          dPrint(volunteer_box.length);

          if (!Hive.isBoxOpen('notifications')) {
            await Hive.openBox('notifications');
          }
          Box box = Hive.box('notifications');
          dPrint(box.length);
          dPrint(box.values);

        }
        catch (e) {
          dPrint(e);
        }
        Box<HivePushNotification> box = Hive.box('notifications');
        dPrint(box.length);
        Box<HivePushNotification> volunteer_box = await Hive.openBox('volunteer_notifications');
        dPrint(volunteer_box.values);
        Box<HivePushNotification> refugee_box = await Hive.openBox<HivePushNotification>('refugee_notifications');
        dPrint(refugee_box.values);
        Box<HivePushNotification> organizer_box = await Hive.openBox<HivePushNotification>('organizer_notifications');
        dPrint(organizer_box.values);

      },
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
    ),
  );
}