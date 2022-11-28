import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:united_help/screen/card_screen.dart';
import 'package:united_help/services/authenticate.dart';

import 'skill_card.dart';
import '../models/events.dart';
import '../services/urls.dart';


Future<Events> fetchEvents(String event_query) async {
	Requests.password = 'sergey104781';
	Requests.username = 'serg';
	var r = Requests();
	String url = '$server_url$all_events_url/';
	url += event_query;

	final response = await r.get(url);

	if (response['status_code'] == 200) {
		return Events.fromJson(response['result']);
	} else {
		throw Exception('Failed to load Event');
	}
}

class EventListScreeScreen extends StatefulWidget {
	final String event_query;
	const EventListScreeScreen({super.key, required this.event_query});

	@override
	State<EventListScreeScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreeScreen> {
	late Future<Events> futureEvents;

	@override
	void initState() {
		super.initState();
		futureEvents = fetchEvents(widget.event_query);
	}

	@override
	Widget build(BuildContext context) {

		return Center(
					child: FutureBuilder<Events>(
						future: futureEvents,
						builder: (context, snapshot) {
							if (snapshot.hasData) {
								// return Text(snapshot.data!.count.toString());
								return ListView.builder(
									itemCount: snapshot.data!.count,
									// prototypeItem: card_builder(snapshot.data!.list.first),
									itemBuilder: (context, index) {
										return GestureDetector(
												child: card_builder(snapshot.data!.list[index]),
												onTap: () {
													Navigator.of(context).push(
														MaterialPageRoute(
															builder: (context) => EventScreen(event_id: index,),
														),
													);
												},

										);
									},
								);
							} else if (snapshot.hasError) {
								return Text('${snapshot.error}');
							}

							return const CircularProgressIndicator();
						},
					),
				);
	}
}


Widget card_builder(event) {
	// var event = snapshot.data!.list[index];
	print(event.image);
	String employment_string = '';
	if (event.employment == 0)
		employment_string = 'Постійна зайнятість';
	else if (event.employment == 1)
		employment_string = '${event.start_time}-${event.end_time}';
	else if (event.employment == 2)
		employment_string = event.start_time;
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
						maxHeight: 330,
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
												child: Text(event.name, style: optionStyle,),
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