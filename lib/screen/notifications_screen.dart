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
import '../services/notifications.dart';



//
// class NotificationBadge extends StatelessWidget {
// 	final int totalNotifications;
//
// 	const NotificationBadge({required this.totalNotifications});
//
// 	@override
// 	Widget build(BuildContext context) {
// 		return Container(
// 			width: 40.0,
// 			height: 40.0,
// 			decoration: new BoxDecoration(
// 				color: Colors.red,
// 				shape: BoxShape.circle,
// 			),
// 			child: Center(
// 				child: Padding(
// 					padding: const EdgeInsets.all(8.0),
// 					child: Text(
// 						'$totalNotifications',
// 						style: TextStyle(color: Colors.white, fontSize: 20),
// 					),
// 				),
// 			),
// 		);
// 	}
// }



class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
	late int _totalNotifications;
	late final FirebaseMessaging _messaging;
	PushNotification? _notificationInfo;
  late AppService app_service;

	// For handling notification when the app is in terminated state


	@override
	void initState() {
		registerHive();
		super.initState();
		// app_service = Provider.of<AppService>(context);
		// send_firebase_token_to_server(app_service);
	}

	Future<bool> future_builder_fun() async {
		app_service = Provider.of<AppService>(context);
		await send_firebase_token_to_server(app_service);
		return true;
	}

	@override
	Widget build(BuildContext context) {


			//
			Widget app = OverlaySupport(
				child: MaterialApp(
					debugShowCheckedModeBanner: false,
					home: Scaffold(
						appBar: buildAppBar(null, 'Новий івент',),
						bottomNavigationBar: const buildBottomNavigationBar(),
						backgroundColor: ColorConstant.whiteA700,
						body: ValueListenableBuilder<Box>(
							valueListenable: Hive.box('notifications').listenable(),
							builder: (context, box, widget) {
								return ListView.builder(
													itemCount: box.length,
													prototypeItem: Card(
														child: Row(
															mainAxisAlignment: MainAxisAlignment.start,
															children: [
																Flexible(
																	child: Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			Text('${box.getAt(0).body}'),
																			Text('${box.getAt(0).body}'),
																		],
																	),
																),
															],
														),
													),
													itemBuilder: (context, index) {
														return Card(
															child: Row(
																children: [
																	Flexible(
																	  child: Column(
																	  	children: [
																	  		Text('${box.getAt(index).body}'),
																	  		Text('${box.getAt(index).title}'),
																	  	],
																	  ),
																	),
																],
															),
														);
													},
											);
							},
						),


							// Text("{Hive.box('notifications').length}"),


						// ),
				),
			),
		);
			Widget fb = FutureBuilder(
					future: future_builder_fun(),
					builder: (context, snapshot) {
						return app;
					}
			);

			return fb;
	}
}

