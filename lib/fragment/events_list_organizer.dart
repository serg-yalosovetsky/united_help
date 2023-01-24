import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/welcome_button.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/card_screen.dart';
import 'package:united_help/providers/appservice.dart';
import 'package:united_help/services/authenticate.dart';

import '../constants/styles.dart';
import '../screen/contacts_screen.dart';
import '../screen/new_event_choose_help_or_job.dart';
import '../providers/filters.dart';
import '../services/show_nice_time.dart';
import 'get_location_permission.dart';
import 'no_actual_events.dart';
import 'no_internet.dart';
import 'skill_card.dart';
import '../models/events.dart';
import '../services/urls.dart';
import 'package:go_router/go_router.dart';


class EventListOrganizerScreen extends StatefulWidget {
	final String event_query;
	final bool is_listview;
	 EventListOrganizerScreen({
		super.key,
		required this.event_query,
		this.is_listview = true,
	});

	@override
	State<EventListOrganizerScreen> createState() => _EventListOrganizerScreenState();
}

class _EventListOrganizerScreenState extends State<EventListOrganizerScreen> {
	late Future<Events> futureEvents;
	late AppService app_service;
	late Filters filters;

	@override
	void initState() {
		app_service = Provider.of<AppService>(context, listen: false);
		filters = Provider.of<Filters>(context, listen: false);

		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		print('futureEvents');
		futureEvents = fetchEvents(widget.event_query, app_service, filters);

		return Consumer<AppService>(
		  builder: (context, cart, child) {
				return Center(
		  			child: FutureBuilder<Events>(
		  				future: futureEvents,
		  				builder: (context, snapshot) {
		  					if (snapshot.hasData) {

									if (snapshot.data!.count <= 0){
										// return build_no_actual_widgets();
										app_service.organizer_has_no_events = true;
										return NewEventChooseHelpOrJobScreen();
									}
									app_service.organizer_has_no_events = false;
									if (widget.is_listview) {
									  return ListView.builder(
		  								scrollDirection: Axis.vertical,
		  								shrinkWrap: true,
		  								itemCount: snapshot.data!.count,
		  								itemBuilder: (context, index) {
		  									return GestureDetector(
		  											child: card_builder(context, snapshot.data!.list[index], app_service),
		  											onTap: () {
		  												Navigator.of(context).push(
		  													MaterialPageRoute(
		  														builder: (context) => EventScreen(
																		event: snapshot.data!.list[index],
																		skills_names: filters.skills_names,
																	),
		  													),
		  												);
		  											},

		  									);
		  								},
		  							);
									} else {
										var widget_list = List<Widget>.generate(
											snapshot.data!.count,
											(index) {
												return GestureDetector(
													child: card_builder(context, snapshot.data!.list[index], app_service),
													onTap: () {
															setState(() {
																Navigator.of(context).push(
																	MaterialPageRoute(
																		builder: (context) => EventScreen(
																			event: snapshot.data!.list[index],
																			skills_names: filters.skills_names,
																		),
																	),
																);
															});

													},
												);
											},
										);
										return Column(
											children: widget_list,
										);
            }
          } else if (snapshot.hasError) {
		  						return build_no_internet(error: snapshot.error.toString());
		  						// return Text('${snapshot.error}');
		  					}
		  					// return build_get_location_permission();
		  					return const CircularProgressIndicator();

		  				},
		  			),
		  		);
				},
		);
	}
}


Widget card_builder(BuildContext context, Event event, AppService app_service) {

	var card = Container(
		margin: const EdgeInsets.all(10),
		child: Card(
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(20.0),
			),
			child: ClipRRect(
				borderRadius: BorderRadius.circular(20.0),

				child: ConstrainedBox(
					constraints: const BoxConstraints(
						minWidth: 70,
						minHeight: 80,
						maxWidth: double.infinity,
						maxHeight: 450,
					),
					child: Column(
							mainAxisSize: MainAxisSize.min,
							mainAxisAlignment: MainAxisAlignment.start,
							children: [
								Flexible(
									flex: 1,
									child: Image(
											image: CachedNetworkImageProvider(event.image),
											fit: BoxFit.fitWidth,
											// height: 142,
									),
								),
								Flexible(
									flex: 1,

									child: Column(
										mainAxisAlignment: MainAxisAlignment.start,
										mainAxisSize: MainAxisSize.min,
										children: [
											Container(
												margin: const EdgeInsets.fromLTRB(20, 20, 10, 0),
												child: Text(event.name, style: StyleConstant.bold_header,),
											),

											welcome_button_fun(
													text: 'Волонтери ${event.subscribed_members} з ${event.required_members}',
													padding: [0, 14, 0, 0],
													fun: () {
														app_service.bottom_navbar_order = 1;
														// context.go('${APP_PAGE.contacts.to_path}/event_id${event.id}');
														Navigator.push(
															context,
															MaterialPageRoute(
																builder: (context) => ContactsScreen(
																		profiles_query: 'event_id${event.id}',
																		event_name: event.name,
																),
															),
														);

													},
											),
											social_button(
													text: 'Редагувати',
													padding: [0, 12, 0, 19],
													fun: () {
														context.go('${APP_PAGE.new_events.to_path}/${event.id}');
													},
											),
										],
									),
								),
							]),
				),
			),
		),
	);

	return card;
}