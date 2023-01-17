import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/models/comments.dart';
import 'package:url_launcher/url_launcher.dart';
import '../fragment/bottom_navbar.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
import '../fragment/no_actual_events.dart';
import '../fragment/no_contacts.dart';
import '../fragment/no_internet.dart';
import '../fragment/skill_card.dart';
import '../fragment/switch_app_bar.dart';
import '../models/profile.dart';
import '../routes/routes.dart';
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
		print('profiles_query ${widget.profiles_query}');
		app_service = Provider.of<AppService>(context, listen: false);
		future_contacts = fetchContacts(widget.profiles_query, app_service);
		super.initState();
  }

	@override
	Widget build(BuildContext context) {
		Roles role = app_service.org_volunteers_or_refugees==SwitchEnum.first ? Roles.volunteer : Roles.refugee;
		return Scaffold(
			appBar: build_switch_app_bar(
				app_service,
				fun: () {
					setState(() {
						if (app_service.org_volunteers_or_refugees == SwitchEnum.first){
							app_service.org_volunteers_or_refugees = SwitchEnum.second;
						} else {
							app_service.org_volunteers_or_refugees = SwitchEnum.first;
						}
					});
				},
				to_filters: null,
				map_or_history: 'contacts',
			),
			backgroundColor: Colors.white,

			body: SafeArea(
					child: Scaffold(
						body: Container(
							margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
							child: FutureBuilder<dynamic>(
								future: future_contacts,
								builder: (context, snapshot){

									if (snapshot.hasData){
										if (snapshot.data.list.length <= 0)
											return build_no_contacts(context, role);
										return ListView.builder(
												shrinkWrap: true,
												itemCount: snapshot.data.list.length,
												itemBuilder: (BuildContext context, int index) {
														UserProfile user = snapshot.data.list[index];
														return Padding(
														  padding: const EdgeInsets.fromLTRB(0, 11, 0, 21),
														  child: Column(
														  	children: [
														  		Row(
														  			mainAxisAlignment: MainAxisAlignment.spaceBetween,
														  			mainAxisSize: MainAxisSize.max,
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
														  						Padding(
														  						  padding: const EdgeInsets.only(left: 13),
														  						  child: Column(
																							mainAxisAlignment: MainAxisAlignment.start,
																							crossAxisAlignment: CrossAxisAlignment.start,
														  						  	children: [
														  						  		Padding(
														  						  		  padding: const EdgeInsets.only(bottom: 1),
														  						  		  child: Text(
																									user.user.username,
																									style: TextStyle(
																										color: Color(0xFF002241),
																										fontSize: 17,
																										fontWeight: FontWeight.w500,
																									),
																								),
														  						  		),
														  						  		GestureDetector(
														  						  		  onTap: () async {
																										late String url;
																										if (user.user.phone != null)
																												url = 'tel:${user.user.phone}';
																										else
																												url = 'mailto:${user.user.email}';

																										if (await canLaunchUrl(Uri.parse(url))) {
																										await launchUrl(Uri.parse(url));
																										} else {
																										throw "Error occured trying to call that number.";
																										}
																									},
																									child: Text(
																									user.user.phone ?? user.user.email,
																									style: TextStyle(
																										color: Color(0xFF748B9F),
																										fontSize: 17,
																										fontWeight: FontWeight.w400,
																									),
																								),
														  						  		),
														  						  	],
														  						  ),
														  						),
														  					],
														  				),
														  				Row(
														  					children: [
														  						user.user.viber_phone!=null ?
														  						GestureDetector(
																						onTap: () async {
																							late String url;
																							if (user.user.viber_phone != null && user.user.viber_phone!.isNotEmpty) {
																								var phone = user.user.viber_phone;
																								if (phone![0] == '+')
																									phone = phone.substring(1);
																								url = 'viber://chat?number=$phone';
                                              } else {
																								var phone = user.user.viber_phone;
																								if (phone![0] == '+')
																									phone = phone.substring(1);
																							  url = 'viber://chat?number=$phone';
																							}
																							print(url);

																							if (await canLaunchUrl(Uri.parse(url))) {
																								await launchUrl(Uri.parse(url));
																							} else {
																								throw "Error occured trying to call that number.";
																							}
																						},
																						child: Image.asset(
														  						  	"images/img_24.png",
														  						  	width: 26.0,
														  						  	semanticLabel: 'viber phone edit',
														  						  ),
														  						) :
														  						Container(),

														  						user.user.telegram_phone!=null || user.user.nickname!=null ?
														  						GestureDetector(
																						onTap: () async {
																							print('telegram');

																							late String url;
																							if (user.user.nickname != null && user.user.nickname!.isNotEmpty)
																								url = 't.me/${user.user.nickname}';
																							else if (user.user.telegram_phone != null && user.user.telegram_phone!.isNotEmpty)
																								url = 't.me/${user.user.telegram_phone}';
																							else
																								url = 't.me/${user.user.phone}';
																							print(url);

																							if (await canLaunchUrl(Uri.parse(url))) {
																								await launchUrl(Uri.parse(url));
																							} else {
																								throw "Error occured trying to call that number.";
																							}
																						},
																						child: Padding(
														  						    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
														  						    child: Icon(
														  						    	Icons.telegram_rounded,
														  						    	color: Color(0xff29b6f6),
														  						    	size: 26,
														  						    ),
														  						  ),
														  						) :
														  						Container(),
														  					],
														  				),

														  			],
														  		),
																	Container(
																	  margin: const EdgeInsets.fromLTRB(0, 21, 0, 0),
																	  child: Divider(height: 20, color: Color(0xFFBDD2E4),  thickness: 1,),
																	)

														  	],
														  ),
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
						bottomNavigationBar: const buildBottomNavigationBar(),

					),

			),

		);
	}
}