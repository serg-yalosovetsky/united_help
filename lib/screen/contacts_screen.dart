import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:united_help/models/comments.dart';
import '../fragment/bottom_navbar.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
import '../fragment/no_actual_events.dart';
import '../fragment/no_internet.dart';
import '../fragment/skill_card.dart';
import '../models/profile.dart';
import '../services/appservice.dart';
import '../services/authenticate.dart';
import '../models/events.dart';
import '../services/show_nice_time.dart';
import '../services/urls.dart';


class ContactsScreen extends StatefulWidget {
	final String profiles_query;
	const ContactsScreen({super.key, required this.profiles_query});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {

	static const TextStyle timerStyle = TextStyle(
		fontSize: 18,
	);

	Widget return_skills_card(List skills, [int skill_in_row = 2]) {
		List<Widget> columns = [];
		int i = 0;
		while (i <= skills.length/2.ceil()) {
			List<Widget> rows = [];
			if (i < skills.length) rows.add(buildCityCard(title: skills[i], id: 0));
			if (i + 1 < skills.length) rows.add(buildCityCard(title: skills[i+1], id: 0));
			Widget row_widget = Row(
				children: rows,
			);
			columns.add(row_widget);
			i = i +2;
		}
		return Column(children: columns);
	}

	Widget build_description(String text) {
		return Container(
			margin: const EdgeInsets.fromLTRB(20, 0, 8, 30),
			child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 8.0),
					child: Text(text, style: timerStyle,)
			),
		);
	}
	Widget build_location(String text, IconData icon, {Color? text_color}) {
		return Container(
			margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: [
					Icon(icon),
					Padding(
						padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
						child: Text(
							text,
							style: text_color!=null ? TextStyle(
								fontSize: 18,
								color: text_color,
							) : timerStyle,
						),
					),
				],
			),
		);
	}

	late AppService app_service;
	late Future<dynamic> future_contacts;
	@override
  void initState() {
		app_service = Provider.of<AppService>(context, listen: false);
		future_contacts = fetchContacts(widget.profiles_query, app_service);
		super.initState();
  }

	@override
	Widget build(BuildContext context) {
		String title = 'Contacts';
		return Scaffold(
			appBar: buildAppBar(
			() {
				Navigator.pop(context);
			},
				title,
			),
			backgroundColor: Colors.white,

			body: SafeArea(
					child: Scaffold(
						body: Container(
							margin: EdgeInsets.all(10),
							child: FutureBuilder<dynamic>(
								future: future_contacts,
								builder: (context, snapshot){

									if (snapshot.hasData){
										return ListView.builder(
												shrinkWrap: true,
												itemCount: snapshot.data.list.length,
												itemBuilder: (BuildContext context, int index) {
														UserProfile user = snapshot.data.list[index];
														return Column(
															children: [
																Row(
																	children: [
																		ClipRRect(
																			borderRadius: BorderRadius.circular(20.0),
																			child: Image(
																					image: CachedNetworkImageProvider(user.profile.image ?? ''),
																					fit: BoxFit.fitWidth,
																					width: 50,
																			),
																		),
																		Column(
																			children: [
																				Text(user.user.username),
																				Text(user.user.phone ?? user.user.email),
																			],
																		),
																		user.user.telegram_phone!=null || user.user.nickname!=null ?
																				Icon(Icons.telegram_rounded) :
																				Container(),
																		user.user.viber_phone!=null ?
																				Image.asset(
																						"images/img_24.png",
																						width: 26.0,
																						semanticLabel: 'viber phone edit',
																				) :
																				Container(),

																	],
																)
															],
														);
												},
									);
									} else if (snapshot.hasError) {
										return build_no_internet(error: snapshot.error.toString());
									}
									return const CircularProgressIndicator();
								},
							),
						),
						bottomNavigationBar: buildBottomNavigationBar(),

					),

			),

		);
	}
}