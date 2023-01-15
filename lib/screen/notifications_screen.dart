import 'package:cached_network_image/cached_network_image.dart';
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
						appBar: buildAppBar(null, 'Сповіщення',),
						bottomNavigationBar: const buildBottomNavigationBar(),
						backgroundColor: ColorConstant.whiteA700,
						body: ValueListenableBuilder<Box>(
							valueListenable: Hive.box('notifications').listenable(),
							builder: (context, box, widget) {
								return ListView.builder(
													itemCount: box.length,
													prototypeItem: Card(
														shape: RoundedRectangleBorder(
															borderRadius: BorderRadius.circular(20.0),
														),
														child: Container(
															decoration: BoxDecoration(
																	border: Border.all(
																		color: Colors.red,
																		// Color(0xFFF0F7FF),
																	),
																	color: Colors.red,
																	borderRadius: BorderRadius.all(Radius.circular(10))),
															// padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
															padding: const EdgeInsets.all(16),
															child: Row(
																mainAxisAlignment: MainAxisAlignment.start,
																children: [
																	LimitedBox(
																		maxHeight: 60,
																		maxWidth: 60,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(8.0),
																			child: Image(
																				image: CachedNetworkImageProvider(box.getAt(0).image),
																				height: 60,
																				width: 60,
																				// height: 142,
																			),
																		),
																	),
																	Flexible(
																		child: Column(
																			crossAxisAlignment: CrossAxisAlignment.start,
																			children: [
																				Text('Новий відsdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffгук'),
																				Text('Андрій Кметfghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhfghfghько залишив відгук до вашого івента про відносини.'),
																			],
																		),
																	),
																],
															),
														),
													),
													itemBuilder: (context, index) {
														return GestureDetector(
														  onTap: () {
																setState(() {
																	box.getAt(index).is_read = true;
																});
																print("box.getAt(index).is_read = ${box.getAt(index).is_read};");
																// box.getAt(index).save();
															},
															onHorizontalDragStart: (e) {box.deleteAt(index);},
															child: Card(
														  	shape: RoundedRectangleBorder(
														  		borderRadius: BorderRadius.circular(12.0),
														  	),
														  	child: Container(
														  		decoration: BoxDecoration(
														  				border: Border.all(
														  					color: box.getAt(index).is_read ? Colors.white : Color(0xFFF0F7FF),
														  					// Color(0xFFF0F7FF),
														  				),
														  				color: box.getAt(index).is_read ? Colors.white : Color(0xFFF0F7FF) ,
														  				borderRadius: BorderRadius.all(Radius.circular(10))),
														  		// padding: const EdgeInsets.all(8),														padding: const EdgeInsets.all(8),
														  		padding: const EdgeInsets.all(16),
														  	  child: Row(
														  	  	children: [
														  				Padding(
														  				  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0,),
														  				  child: ClipRRect(
														  				  	borderRadius: BorderRadius.circular(8.0),
														  				  	child: Image(
														  	  		  	image: CachedNetworkImageProvider(box.getAt(index).image),
														  	  		  	fit: BoxFit.fitWidth,
														  				  	height: 60,
														  				  	width: 60,
														  	  		  	// height: 142,
														  	  		  ),
														  	  		),
														  				),
														  	  		Flexible(
														  	  		  child: Column(
														  	  		  	children: [
														  	  		  		Text(
																								'${box.getAt(index).body.split(' ').take(5).fold('', (p, i) => '$p $i')}',
																								style: TextStyle(
																									fontSize: 16,
																									fontWeight: FontWeight.w600,
																									color: Color(0xFF002241),
																								),
																						),
														  	  		  		Padding(
														  	  		  		  padding: const EdgeInsets.only(top: 4.0),
														  	  		  		  child: Text(
																							'${box.getAt(index).title}',
																							style: TextStyle(
																								fontSize: 14,
																								fontWeight: FontWeight.w400,
																								color: Color(0xFF748B9F),
																							),
																						),
														  	  		  		),
														  	  		  	],
														  	  		  ),
														  	  		),
														  				Icon(
														  					Icons.circle,
														  					color: box.getAt(index).is_read ? Colors.white : Colors.blue,
														  					size: 8,
														  				)
														  	  	],
														  	  ),
														  	),
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

