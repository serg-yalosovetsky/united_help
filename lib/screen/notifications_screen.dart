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


import '../fragment/no_push_messages.dart';
import '../models/notify.dart';
import '../models/profile.dart';
import '../providers/appservice.dart';
import '../services/debug_print.dart';
import '../services/notifications.dart';



class NotificationsScreen extends StatefulWidget {
	final String? box_name;
	const NotificationsScreen({
		super.key,
		this.box_name,
	});
	@override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late AppService app_service;
	List<bool> is_notification_has_item = [];
	@override
	void initState() {
		super.initState();
	}

	Future<bool> future_builder_fun() async {
		app_service = Provider.of<AppService>(context);
		await send_firebase_token_to_server(app_service);
		return true;
	}

	waiting_box_open (String box_name) async {
		try {
			if (!Hive.isBoxOpen(box_name)) await Hive.openBox<HivePushNotification>(box_name);
			var box = Hive.box<HivePushNotification>(box_name);
			is_notification_has_item = List<bool>.generate(box.length, (index) => false);

			for (int index = 0; index < box.length; index++) {
				HivePushNotification? box_item = box.getAt(index);
				if (box_item != null) {
					String subnotifications = '${app_service.role.name.toLowerCase()}_notifications_${box_item.notify_type}_${box_item.event_id}';
					dPrint(subnotifications);
					dPrint(23847578);
					if (await Hive.boxExists(subnotifications)){
						if (!Hive.isBoxOpen(subnotifications)) await Hive.openBox<HivePushNotification>(subnotifications);

						Box<HivePushNotification> subbox = Hive.box<HivePushNotification>(subnotifications);
						if (subbox.length > 0) is_notification_has_item[index] = true;
						dPrint('subbox.length ${subbox.length}');
					}

				}
			}
		}
		catch (e){dPrint('ERROR $e');}
		dPrint(is_notification_has_item);
		return true;
	}

	@override
	Widget build(BuildContext context) {
		app_service = Provider.of<AppService>(context);
		String box_name = widget.box_name ?? '${app_service.role.name.toLowerCase()}_notifications';
			Widget app = MaterialApp(
				debugShowCheckedModeBanner: false,
				home: Scaffold(
					appBar: buildAppBar(
						widget.box_name!=null ? (){
							Navigator.pop(context);
						} : null,
						'Сповіщення',
					),
					bottomNavigationBar: const buildBottomNavigationBar(),
					backgroundColor: ColorConstant.whiteA700,
					body: FutureBuilder(
							future: waiting_box_open(box_name),
							builder: (context, snapshot) {
								if (!snapshot.hasError && snapshot.hasData) {
								  return ValueListenableBuilder<Box<HivePushNotification>>(
										valueListenable: Hive.box<HivePushNotification>(box_name).listenable(),
										builder: (BuildContext context, Box<HivePushNotification> box, _widget) {
											if (box.length <= 0) {
												return build_no_push_messages();
											} else {
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
																				image: CachedNetworkImageProvider(box.getAt(0)!.image),
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
														HivePushNotification? box_item = box.getAt(index);
														if (box_item == null) return Container();
														return GestureDetector(
															onTap: () {
																setState(() {
																	box_item.is_read = true;
																	box_item.save();
																});
																String subnotifications = '${app_service.role.name.toLowerCase()}_notifications_${box_item.notify_type}_${box_item.event_id}';
																dPrint(subnotifications);
																dPrint(54346456);
																if (widget.box_name==null && (box_item.notify_type == 'subscribe' ||
																		box_item.notify_type == 'review' || box_item.notify_type == 'change')) {
																	try {
																		if (is_notification_has_item[index]) {
																			dPrint(subnotifications);
																			Navigator.push(
																				context,
																				MaterialPageRoute(
																					builder: (context) => NotificationsScreen(
																						box_name: subnotifications,
																					),
																				),
																			);
																		}
																	}
																	catch (e) {
																		dPrint(e);
																	}
																}
															},
															onHorizontalDragStart: (e) {box.deleteAt(index);},
															child: Card(
																shape: RoundedRectangleBorder(
																	borderRadius: BorderRadius.circular(12.0),
																),
																child: Container(
																	decoration: BoxDecoration(
																			border: Border.all(
																				color: box_item.is_read ? Colors.white : Color(0xFFF0F7FF),
																				// Color(0xFFF0F7FF),
																			),
																			color: box_item.is_read ? Colors.white : Color(0xFFF0F7FF) ,
																			borderRadius: BorderRadius.all(Radius.circular(10))),
																	padding: const EdgeInsets.all(16),
																	child: Row(
																		children: [
																			Padding(
																				padding: const EdgeInsets.fromLTRB(0, 0, 12, 0,),
																				child: ClipRRect(
																					borderRadius: BorderRadius.circular(8.0),
																					child: Image(
																						image: CachedNetworkImageProvider(box_item.image),
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
																							'${box_item.body.split(' ').take(5).fold('', (p, i) => '$p $i')}',
																							style: TextStyle(
																								fontSize: 16,
																								fontWeight: FontWeight.w600,
																								color: ColorConstant.Black_volonterka,
																							),
																						),
																						Padding(
																							padding: const EdgeInsets.only(top: 4.0),
																							child: Text(
																								'${box_item.title}',
																								style: TextStyle(
																									fontSize: 14,
																									fontWeight: FontWeight.w400,
																									color: ColorConstant.help_text,
																								),
																							),
																						),
																					],
																				),
																			),
																			Icon(
																				Icons.circle,
																				color: box_item.is_read ? Colors.white : Colors.blue,
																				size: 8,
																			)
																		],
																	),
																),
															),
														);
													},
												);
											}
										},
									);
								} else {
								  return build_no_push_messages();
								}

							}
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
