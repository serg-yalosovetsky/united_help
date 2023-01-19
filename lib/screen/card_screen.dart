import 'package:flutter/material.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
import '../services/appservice.dart';
import '../services/authenticate.dart';
import '../models/events.dart';
import '../services/urls.dart';


class EventScreen extends StatefulWidget {
	final Event event;
	final String title;
	final Map<int, String> skills_names;
	const EventScreen({
		super.key,
		required this.event,
		required this.skills_names,
		this.title = 'Редагувати',
	});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

	@override
	Widget build(BuildContext context) {

		return Scaffold(
			appBar: buildAppBar(
			() {
				Navigator.pop(context);
			},
				widget.title,
			),
			backgroundColor: Colors.white,
			// foregroundColor: Colors.blue,

			body: SafeArea(
					child: card_detail(event: widget.event, skills_names: widget.skills_names),

			),

		);
	}
}