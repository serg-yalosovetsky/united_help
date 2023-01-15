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
import '../services/appservice.dart';


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
		var counter = await Hive.openBox<int>('counter');
	}
	catch (e) {
		print(e);
		registerHive();
	}

	var counter = await Hive.openBox<int>('counter');
	var box = await Hive.openBox('notifications');

	int counter_value = 0;

	counter_value = counter.get('notify_counter', defaultValue: 0) ?? 0;

	int __counter = 0;
	bool new_notify = true;
	for (HivePushNotification item in box.values) {
		if (item.event_id == int.parse(message.data['event_id']) &&
				item.notify_type == message.data['notify_type']
				) {
			new_notify = false;
			break;
		}
		__counter ++;
	}
	counter_value ++;
	String image = message.data['image'] ?? '';
	if (image.contains('127.0.0.1')) {
		image = image.replaceAll('127.0.0.1', server_address);
	}
	var notify = HivePushNotification(
		id: counter_value,
		title: message.notification?.title ?? '',
		body: message.notification?.body ?? '',
		data_title: message.data['title'] ?? '',
		data_body: message.data['body'] ?? '',
		image: image,
		is_read: false,
		notify_type: message.data['notify_type'] ?? '',
		event_id: int.parse(message.data['event_id']),
	);
	try{
		print('$new_notify $__counter');
			if (new_notify) {
				await box.put(counter_value, notify);
			}
			else {
				await box.put(__counter, notify);
			}
	}
	catch (e) {print(e);}

	try{notify.save();}
	catch (e) {print(e);}

	counter.put('notify_counter', counter_value);
	print('STORED BOX');
	print('box.values ${box.values.length} ');
	print('box.length  ${box.length}');
	print('box.isOpen  ${box.isOpen}');
	print('box.path  ${box.path}');
	print('box.name  ${box.name}');
	// print('box.getAt(0)  ${box.getAt(0)?.id}');
	// print('box.getAt(${box.length-1})  ${box.getAt(box.length-1)?.id}');
	print('box.keys  ${box.keys}');
	// print('box.keyAt(0)  ${box.keyAt(0)}');
	print("message.data['event_id'] ${message.data['event_id']}");
	print("message.data['image'] ${message.data['image']}");
	// box.close();

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


