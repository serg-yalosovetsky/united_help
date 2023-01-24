import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:united_help/routes/routes.dart';

import '../models/notify.dart';
import '../screen/email_password_confirmation.dart';
import '../providers/appservice.dart';
import '../services/notifications.dart';


Widget build_no_push_messages() {
  return Center(
    child: GestureDetector(
      onTap: () async {
        print('tap');

        try {
          print('tap2');
          var counter = await Hive.openBox<int>('counter');
          print(counter.values);
          print('tap3');
        }
        catch (e) {
          print('tap4');
          print(e);
          registerHive();
        }


        print('box.length');
        print(await Hive.boxExists('notifications'));
        print(await Hive.boxExists('volunteer_notifications'));
        print(await Hive.boxExists('organizer_notifications'));
        print(await Hive.boxExists('refugee_notifications'));
        print(3245);
        try{
          if (!Hive.isBoxOpen('organizer_notifications')) {
            await Hive.openBox('organizer_notifications');
          }
          Box organizer_box = Hive.box('organizer_notifications');
          print('organizer_box.length');
          print(organizer_box.length);

          if (!Hive.isBoxOpen('volunteer_notifications')) {
            await Hive.openBox('volunteer_notifications');
          }
          Box volunteer_box = Hive.box('volunteer_notifications');
          print('volunteer_box.length');
          print(volunteer_box.length);

          if (!Hive.isBoxOpen('notifications')) {
            print(2323);
            await Hive.openBox('notifications');
            print(65234);
          }
          Box box = Hive.box('notifications');
          print(box.length);
          print(box.values);

        }
        catch (e) {
          print(e);
        }
        print(3245);
        Box<HivePushNotification> box = Hive.box('notifications');
        print(3245);
        print(box.length);
        Box<HivePushNotification> volunteer_box = await Hive.openBox('volunteer_notifications');
        print(volunteer_box.values);
        Box<HivePushNotification> refugee_box = await Hive.openBox<HivePushNotification>('refugee_notifications');
        print(refugee_box.values);
        Box<HivePushNotification> organizer_box = await Hive.openBox<HivePushNotification>('organizer_notifications');
        print(organizer_box.values);

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