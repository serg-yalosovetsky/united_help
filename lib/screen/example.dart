import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:united_help/services/authenticate.dart';

import '../fragment/skill_card.dart';
import '../services/urls.dart';

Future<Events> fetchEvents() async {
	Requests.password = 'sergey104781';
	Requests.username = 'serg';
	var r = Requests();

	final response = await r.get(
			'$server_url$all_events_url'
	);

	if (response['status_code'] == 200) {
		return Events.fromJson(response['result']);
	} else {
		throw Exception('Failed to load Event');
	}
}

class Event {
	final int userId;
	final int id;
	final String name;
	final bool enabled;
	final String description;
	final String reg_date;
	final String start_time;
	final String end_time;
	final String image;
	final int city;
	final String location;
	final int employment;
	final int owner;
	final int required_members;

	const Event({
		required this.userId,
		required this.id,
		required this.name,
		required this.enabled,
		required this.description,
		required this.reg_date,
		required this.start_time,
		required this.end_time,
		required this.image,
		required this.city,
		required this.location,
		required this.employment,
		required this.owner,
		required this.required_members,
	});

	factory Event.fromJson(Map<String, dynamic> json) {
		return Event(
			userId: json['owner'],
			id: json['id'],
			name: json['name'],
			enabled: json['enabled'],
			description: json['description'],
			reg_date: json['reg_date'],
			start_time: json['start_time'],
			end_time: json['end_time'],
			image: json['image'],
			city: json['city'],
			location: json['location'],
			employment: json['employment'],
			owner: json['owner'],
			required_members: json['required_members'],
		);
	}
}

class Events {
	final int count;
	final String? next;
	final String? previous;
	final List<Event> list;

	const Events({
		required this.count,
		required this.list,
		required this.next,
		required this.previous,
	});

	factory Events.fromJson(Map<String, dynamic> json) {
		var results = <Event>[];
		for (var event in json['results']) {
			results.add(Event.fromJson(event)) ;
		}
		return Events(
			count: json['count'],
			list: results,
			previous: json['previous'],
			next: json['next'],
		);
	}
}

// void main() => runApp(const MyApp());

class ExampleScreen extends StatefulWidget {
	const ExampleScreen({super.key});

	@override
	State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
	late Future<Events> futureEvents;

	@override
	void initState() {
		super.initState();
		futureEvents = fetchEvents();
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Fetch Data Example',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: Scaffold(
				appBar: AppBar(
					title: const Text('Fetch Data Example'),
				),
				body: Center(
					child: FutureBuilder<Events>(
						future: futureEvents,
						builder: (context, snapshot) {
							if (snapshot.hasData) {
								// return Text(snapshot.data!.count.toString());
								return ListView.builder(
									itemCount: snapshot.data!.count,
									// prototypeItem: card_builder(snapshot.data!.list.first),
									itemBuilder: (context, index) {
										return card_builder(snapshot.data!.list[index]);
									},
								);
							} else if (snapshot.hasError) {
								return Text('${snapshot.error}');
							}

							// By default, show a loading spinner.
							return const CircularProgressIndicator();
						},
					),
				),
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
									// child: Image.network(
									// 	event.image,
									// 	fit: BoxFit.fitWidth,
									// ),
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
														Icon(Icons.access_time),
														Padding(
															padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
															child: Text(
																employment_string,
																style: timerStyle,),
														),
													],
												),
											),
											// Spacer(),
											Container(
												margin: const EdgeInsets.fromLTRB(20, 0, 8, 26),
												child: Row(
													children: [
														Icon(Icons.location_on),
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