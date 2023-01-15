import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/colors.dart';
import '../fragment/bottom_navbar.dart';
import '../fragment/build_app_bar.dart';


import '../models/notify.dart';
import '../models/profile.dart';
import '../services/appservice.dart';


// https://blog.logrocket.com/add-flutter-push-notifications-firebase-cloud-messaging/


Future store_message(RemoteMessage message) async {
	print('STORED BOX start');

	print(234234);

	try {
		var counter = await Hive.openBox<int>('counter');

	}
	catch (e) {
		print(e);
		final appDocumentDirectory = await getApplicationDocumentsDirectory();
		await Hive.initFlutter(appDocumentDirectory.path);
		Hive.registerAdapter(HivePushNotificationAdapter());

		// Hive.init(appDocumentDirectory.path);
		var counter = await Hive.openBox<int>('counter');

	}
	var counter = await Hive.openBox<int>('counter');


	int? counter_value = 0;
	print(5683);

	counter_value = counter.get('notify_counter', defaultValue: 0);

	print(346346);

	var box = await Hive.openBox('notifications');
	print(3541);

	counter_value ??= 0;
	counter_value ++;
	print(23);

	var notify = HivePushNotification()
		..id = counter_value
		..title = message.notification?.title ?? ''
		..body = message.notification?.body ?? ''
		..data_title = message.data['title'] ?? ''
		..data_body = message.data['body'] ?? '';
	print(2342);
	// box.add(notify);

	try{
			await box.put(counter_value, notify);
	}
	catch (e) {print(e);}

	try{notify.save();}
	catch (e) {print(e);}

	print(536);

	print(468);
	counter.put('notify_counter', counter_value);
	print('STORED BOX');
	print('box.values ${box.values.length} ');
	print('box.length  ${box.length}');
	print('box.isOpen  ${box.isOpen}');
	print('box.path  ${box.path}');
	print('box.name  ${box.name}');
	print('box.getAt(0)  ${box.getAt(0)?.id}');
	// print('box.getAt(1)  ${box.getAt(1)?.id}');
	print('box.keys  ${box.keys}');
	print('box.keyAt(0)  ${box.keyAt(0)}');
	box.close();

	print(442567);
}


Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
	store_message(message);

	print("Handling a background message: ${message.messageId}");
}



class NotificationBadge extends StatelessWidget {
	final int totalNotifications;

	const NotificationBadge({required this.totalNotifications});

	@override
	Widget build(BuildContext context) {
		return Container(
			width: 40.0,
			height: 40.0,
			decoration: new BoxDecoration(
				color: Colors.red,
				shape: BoxShape.circle,
			),
			child: Center(
				child: Padding(
					padding: const EdgeInsets.all(8.0),
					child: Text(
						'$totalNotifications',
						style: TextStyle(color: Colors.white, fontSize: 20),
					),
				),
			),
		);
	}
}



class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
	late int _totalNotifications;
	late final FirebaseMessaging _messaging;
	PushNotification? _notificationInfo;
  late final AppService app_service = Provider.of<AppService>(context);

	// For handling notification when the app is in terminated state
	checkForInitialMessage() async {
		await Firebase.initializeApp();
		RemoteMessage? initialMessage =	await FirebaseMessaging.instance.getInitialMessage();

		if (initialMessage != null) {
			PushNotification notification = PushNotification(
				title: initialMessage.notification?.title,
				body: initialMessage.notification?.body,
				dataTitle: initialMessage.data['title'],
				dataBody: initialMessage.data['body'],
			);
			setState(() {
				_notificationInfo = notification;
				_totalNotifications++;
			});
		}
	}

	void registerNotification() async {
		// 1. Initialize the Firebase app
		await Firebase.initializeApp();

		FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

		// 2. Instantiate Firebase Messaging
		_messaging = FirebaseMessaging.instance;

		// 3. On iOS, this helps to take the user permissions
		NotificationSettings settings = await _messaging.requestPermission(
			alert: true,
			badge: true,
			provisional: false,
			sound: true,
		);


		if (settings.authorizationStatus == AuthorizationStatus.authorized) {
			print('User granted permission');

			FirebaseMessaging.onMessage.listen((RemoteMessage message) {

				if (_notificationInfo != null) {

					PushNotification notification = PushNotification(
						title: message.notification?.title,
						body: message.notification?.body,
						dataTitle: message.data['title'],
						dataBody: message.data['body'],
					);
					showSimpleNotification(
						Text(_notificationInfo!.title!),
						leading: NotificationBadge(totalNotifications: _totalNotifications),
						subtitle: Text(_notificationInfo!.body!),
						background: Colors.cyan.shade700,
						duration: Duration(seconds: 2),
					);

					store_message(message);

					setState(() {
						_notificationInfo = notification;
						_totalNotifications ++;
					});
					// For displaying the notification as an overlay

				}
			});

		} else {
			print('User declined or has not accepted permission');
		}
	}

	@override
	void initState() {
		_totalNotifications = 0;

		registerNotification();

		checkForInitialMessage();
		FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
			PushNotification notification = PushNotification(
				title: message.notification?.title,
				body: message.notification?.body,
				dataTitle: message.data['title'],
				dataBody: message.data['body'],
			);

			store_message(message);

			setState(() {
				_notificationInfo = notification;
				_totalNotifications++;
			});
		});

		super.initState();
	}


	@override
	Widget build(BuildContext context) {
		// app_service = Provider.of<AppService>(context);

		return OverlaySupport(
		  child: MaterialApp(
		  	debugShowCheckedModeBanner: false,
		    home: Scaffold(
		  		appBar: buildAppBar(null, 'Новий івент',),
		  		bottomNavigationBar: const buildBottomNavigationBar(),
		  		backgroundColor: ColorConstant.whiteA700,
		    	body: Column(
		  			mainAxisAlignment: MainAxisAlignment.center,
		  			children: [
		  				GestureDetector(
		  				  onTap: () {
									FirebaseMessaging.instance.getToken().then((value) {
										String? token = value;
										print('token $token');
										print('token  is trying to send');
										if (token != null) postFirebaseToken(token, app_service);

									});
								},
								child: Text(
		  				  	'App for capturing Firebase Push Notifications',
		  				  	textAlign: TextAlign.center,
		  				  	style: TextStyle(
		  				  		color: Colors.black,
		  				  		fontSize: 20,
		  				  	),
		  				  ),
		  				),
		  				SizedBox(height: 16.0),
		  				NotificationBadge(totalNotifications: _totalNotifications),
		  				SizedBox(height: 16.0),
		  				// TODO: add the notification text here
							_notificationInfo != null
									? Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										'TITLE: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}',
										style: TextStyle(
											fontWeight: FontWeight.bold,
											fontSize: 16.0,
										),
									),
									SizedBox(height: 8.0),
									Text(
										'BODY: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}',
										style: TextStyle(
											fontWeight: FontWeight.bold,
											fontSize: 16.0,
										),
									),
								],
							)
									: Container(),
		  			],
		  		),
		  	),
		  ),
		);
	}
}

