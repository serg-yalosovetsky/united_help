import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:united_help/services/urls.dart';

import '../constants/colors.dart';
import '../fragment/bottom_navbar.dart';
import '../fragment/build_app_bar.dart';


import '../models/notify.dart';
import '../models/profile.dart';
import '../providers/appservice.dart';


late final FirebaseMessaging _messaging;
PushNotification? _notificationInfo;
late NotificationSettings settings;

// https://blog.logrocket.com/add-flutter-push-notifications-firebase-cloud-messaging/
void registerHive() async {
	print('registerHive');
	final appDocumentDirectory = await getApplicationDocumentsDirectory();
	await Hive.initFlutter(appDocumentDirectory.path);
	Hive.registerAdapter(HivePushNotificationAdapter());
	await Hive.openBox('notifications');
	await Hive.openBox<int>('counter');
}


send_firebase_token_to_server(AppService app_service) async {
	if (!app_service.is_sent_firebase_token) {
		String? token = await FirebaseMessaging.instance.getToken();
		if (token != null) {
			var res = await postFirebaseToken(token, app_service);
			if (res['status_code'] == 200) app_service.is_sent_firebase_token = true;
		}
	}
}


Future store_message(RemoteMessage message) async {
	print('STORED BOX start');

	try {
		if (!Hive.isBoxOpen('counter')) await Hive.openBox<int>('counter');
	}
	catch (e) {
		print(e);
		registerHive();
	}

	if (!Hive.isBoxOpen('counter')) await Hive.openBox<int>('counter');

	var counter = Hive.box<int>('counter');
	late var spec_box;

	int counter_value = counter.get('notify_counter', defaultValue: 0) ?? 0;

	int __counter = 0;
	bool new_notify = true;
	String notification_key = '${message.data["to_profile"].toLowerCase()}_notifications';

	if (!Hive.isBoxOpen(notification_key)) await Hive.openBox<HivePushNotification>(notification_key);

	Box<HivePushNotification> box = Hive.box(notification_key);


	for (HivePushNotification item in box.values) {
		if (item.event_id == int.parse(message.data['event_id']) && item.notify_type == message.data['notify_type']) {

			new_notify = false;
			if (item.event_id != 0 && (item.notify_type == 'subscribe' ||
																 item.notify_type == 'review')) {
			  spec_box = await Hive.openBox('${message.data["to_profile"]}_notifications_${item.notify_type}_${item.event_id}');
			}
			break;
		}
		__counter ++;
	}

	counter_value ++;
	String image = message.data['image'] ?? '';
	if (image.contains('127.0.0.1')) {
		image = image.replaceAll('127.0.0.1', server_address);
	}

		Map<String, String> data = {};
		if (message.data['_data'] != null) {
			var decoded_data = json.decode(message.data['_data']);
			for (String k in decoded_data.keys){
				data[k] = decoded_data[k].toString();
			}
		}

		var notify = HivePushNotification(
			id: counter_value,
			title: message.notification?.title ?? '',
			body: message.notification?.body ?? '',
			to_profile: message.data['notify_type'] ?? '',
			data: data,
			image: image,
			is_read: false,
			notify_type: message.data['notify_type'] ?? '',
			event_id: int.parse(message.data['event_id']),
			event_to: message.data['event_to'] ?? '',
			event_name: message.data['event_name'] ?? '',
			actor_name: message.data['actor_name'] ?? '',
			actor_profile_id: int.parse(message.data['actor_profile_id']),
		);

	try{
			if (new_notify) {
				await box.put(counter_value, notify);
			}
			else {
				await box.put(__counter, notify);
				await spec_box.put(spec_box.length, notify);
			}
	}
	catch (e) {print(e);}

	try{notify.save();}
	catch (e) {print(e);}

	counter.put('notify_counter', counter_value);
	print('STORED BOX finish');
}


Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
	print('_firebaseMessagingBackgroundHandler');

	store_message(message);

	print("Handling a background message: ${message.messageId}");
}


	checkForInitialMessage() async {
		print('checkForInitialMessage');

		RemoteMessage? initialMessage =	await FirebaseMessaging.instance.getInitialMessage();

		if (initialMessage != null) {
			store_message(initialMessage);
		}
	}


	void registerNotification() async {
		print('registerNotification');

		// 1. Initialize the Firebase app
		// await Firebase.initializeApp();
		FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

		// 2. Instantiate Firebase Messaging
		_messaging = FirebaseMessaging.instance;

		// 3. On iOS, this helps to take the user permissions
		settings = await _messaging.requestPermission(
			alert: true,
			badge: true,
			provisional: false,
			sound: true,
		);


	}


	void initNotifications() {
		print('initNotifications');

		registerNotification();
		checkForInitialMessage();

		// if (settings.authorizationStatus == AuthorizationStatus.authorized) {
		// 	print('User accepted permission');
		// } else {
		// 	print('User declined or has not accepted permission');
		// }

		FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
			store_message(message);
			print("Handling a init message: ${message.messageId}");

		});

		FirebaseMessaging.onMessage.listen((RemoteMessage message) {
			print('FirebaseMessaging.onMessage.listen');
			print("Start Handling a message: ${message.messageId}");

			store_message(message);
			print("Handling a message: ${message.messageId}");

		});

	}


void openNotificationsMessageAsync() async {
	print('openNotificationsMessageAsync');

	FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
		store_message(message);
		print("Handling a init message: ${message.messageId}");
	});
}

void notificationsMessageAsync() async {
	print('notificationsMessageAsync');

	FirebaseMessaging.onMessage.listen((RemoteMessage message) {
		print('FirebaseMessaging.onMessage.listen');
		print("Start Handling a message: ${message.messageId}");

		store_message(message);
		print("Handling a message: ${message.messageId}");

	});

}


