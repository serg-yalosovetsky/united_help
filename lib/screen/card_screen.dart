import 'package:flutter/material.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
import '../services/appservice.dart';
import '../services/authenticate.dart';
import '../models/events.dart';
import '../services/urls.dart';



Future<Event> fetchEvent(int event_id, AppService app_service) async {
	var r = Requests();
	String url = '$server_url$all_events_url/$event_id';
	final response = await r.get(url, await app_service.get_access_token());

	if (response['status_code'] == 200) {
		return Event.fromJson(response['result']);
	} else {
		app_service.set_access_token(null);
		throw Exception('Failed to load Event');
	}
}

class EventScreen extends StatefulWidget {
	final Event event;
	const EventScreen({super.key, required this.event});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

	@override
	Widget build(BuildContext context) {
		const TextStyle back_style = TextStyle(color: Colors.blue);

		return Scaffold(
			appBar: buildAppBar(
			() {
				Navigator.pop(context);
			},
				'Редагувати',
			),
			backgroundColor: Colors.white,
			// foregroundColor: Colors.blue,

			body: SafeArea(
					child: card_detail(event: widget.event),

			),

		);
	}
}