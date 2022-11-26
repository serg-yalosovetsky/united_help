import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:united_help/services/authenticate.dart';

Future<Event> fetchEvent() async {
	// Requests.password = 'sergey104781';
	// Requests.username = 'serg';
	// var r = Requests();

	final response = await http.get(
			Uri.parse('http://127.0.0.1:8000/events/2/'),
			headers: {"accept": "application/json",
				// 'Content-Type': 'application/json',
			'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjY5NDI5MDYzLCJpYXQiOjE2Njk0Mjg3NjMsImp0aSI6IjQ4MjM5N2JmOTkxYjRlNWU4YzZhZGZhOThmZGVlNTc0IiwidXNlcl9pZCI6MX0.nitICMa3leS-CFJHR2UnnW-Tr3NGdsUiyrgLL-8CoQQ',
			},
	);


	// final response = await http.post(
	// 	Uri.parse('http://127.0.0.1:8000/api/token/'),
	// 	body: json.encode({"username": "serg",
	// 		"password": "sergey104781"}),
	// 	headers: {'accept': 'application/json',
	// 		'Content-Type': 'application/json',
	// 	},
	// );

	if (response.statusCode == 200) {
		// If the server did return a 200 OK response,
		// then parse the JSON.
		return Event.fromJson(jsonDecode(response.body));
	} else {
		// If the server did not return a 200 OK response,
		// then throw an exception.
		throw Exception('Failed to load Event');
	}
}

class Event {
	final int userId;
	final int id;
	final String title;

	const Event({
		required this.userId,
		required this.id,
		required this.title,
	});

	factory Event.fromJson(Map<String, dynamic> json) {
		return Event(
			userId: json['owner'],
			id: json['id'],
			title: json['name'],
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
	late Future<Event> futureEvent;

	@override
	void initState() {
		super.initState();
		futureEvent = fetchEvent();
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
					child: FutureBuilder<Event>(
						future: futureEvent,
						builder: (context, snapshot) {
							if (snapshot.hasData) {
								return Text(snapshot.data!.title);
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