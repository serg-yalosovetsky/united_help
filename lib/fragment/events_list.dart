import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:united_help/models/profile.dart';
import 'package:united_help/screen/card_screen.dart';
import 'package:united_help/providers/appservice.dart';
import 'package:united_help/services/authenticate.dart';

import '../constants/styles.dart';
import '../providers/filters.dart';
import '../services/debug_print.dart';
import '../services/show_nice_time.dart';
import 'get_location_permission.dart';
import 'no_actual_events.dart';
import 'no_internet.dart';
import 'skill_card.dart';
import '../models/events.dart';
import '../services/urls.dart';


class EventListScreen extends StatefulWidget {
	final String event_query;
	final bool is_listview;
	 EventListScreen({
		super.key,
		required this.event_query,
		this.is_listview = true,
	});

	@override
	State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
	late Future<Events?> futureEvents;
	late AppService app_service;
	late Filters filters;
	@override
	void initState() {

		app_service = Provider.of<AppService>(context, listen: false);
		filters = Provider.of<Filters>(context, listen: false);
		futureEvents = fetchEvents(widget.event_query, app_service, filters);
		super.initState();
	}

	push_event_screen(AsyncSnapshot<Events> snapshot, int index) async {
		// Profile owner = await fetchProfile('${snapshot.data!.list[index].owner}/', app_service);
		Navigator.of(context).push(
			MaterialPageRoute(
				builder: (context) => EventScreen(
					event: snapshot.data!.list[index],
					skills_names: filters.skills_names,
					title: snapshot.data!.list[index].name,
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		dPrint('events_list');

		return Consumer<AppService>(
		  builder: (context, cart, child) {
				return FutureBuilder<Events?>(
					future: futureEvents,
					builder: (BuildContext context, AsyncSnapshot<Events?> snapshot) {
						if (snapshot.hasData) {

									if (snapshot.data!.count <= 0){
										return build_no_actual_widgets();
									}

							if (widget.is_listview) {
							  return ListView.builder(
									scrollDirection: Axis.vertical,
									shrinkWrap: true,
									itemCount: snapshot.data!.count,
									itemBuilder: (context, index) {
										return GestureDetector(
												child: card_builder(snapshot.data!.list[index]),
												onTap: () {
																Navigator.of(context).push(
																	MaterialPageRoute(
																		builder: (context) => EventScreen(
																			event: snapshot.data!.list[index],
																			skills_names: filters.skills_names,
																			title: snapshot.data!.list[index].name,
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
													child: card_builder(snapshot.data!.list[index]),
													onTap: () {
															Navigator.of(context).push(
																MaterialPageRoute(
																	builder: (context) => EventScreen(
																		event: snapshot.data!.list[index],
																		skills_names: filters.skills_names,
																		title: snapshot.data!.list[index].name,
																	),
																),
															);
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
				);
				},
		);
	}
}


Widget card_builder(event) {
	String employment_string = '';
	if (event.employment == 0)
		employment_string = 'Постійна зайнятість';
	else if (event.employment == 1)
		employment_string = show_nice_time(event.start_time, event.end_time);
	else if (event.employment == 2)
		employment_string = show_nice_time(event.start_time);


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
						maxHeight: 370,
					),
					child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								Flexible(
									flex: 1,
									child: Image(
											image: CachedNetworkImageProvider(event.image),
											fit: BoxFit.fitWidth
									),
								),
								Flexible(
									flex: 1,

									child: Column(
										children: [
											Container(
												margin: const EdgeInsets.fromLTRB(20, 20, 10, 0),
												child: Text(
													event.name,
													style: StyleConstant.bold_header,
													maxLines: 2,
												),
											),
											const Spacer(),
											Container(
												margin: const EdgeInsets.fromLTRB(20, 0, 8, 12),
												child: Row(
													children: [
														const Icon(Icons.access_time),
														Padding(
															padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
															child: Text(
																employment_string,
																style: timerStyle,),
														),
													],
												),
											),
											Container(
												margin: const EdgeInsets.fromLTRB(20, 0, 8, 26),
												child: Row(
													children: [
														const Icon(Icons.location_on),
														Padding(
															padding: const EdgeInsets.symmetric(horizontal: 8.0),
															child: Text(event.location, style: timerStyle,),
														),
													],
												),
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