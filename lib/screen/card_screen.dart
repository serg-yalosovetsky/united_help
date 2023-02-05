import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:united_help/constants.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
import '../models/profile.dart';
import '../providers/appservice.dart';
import '../services/authenticate.dart';
import '../models/events.dart';
import '../services/debug_print.dart';
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
		AppService app_service = Provider.of<AppService>(context, listen: false);

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
					child: FutureBuilder<UserProfile>(
						future: fetchUserProfile('${widget.event.owner}/', app_service),
					  builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
							dPrint('snapshot.hasError ${snapshot.hasError}');
							dPrint('snapshot.hasData ${snapshot.hasData}');
							return card_detail(
									event: widget.event,
									skills_names: widget.skills_names,
									owner: snapshot.data,
								);
						},
					),

			),

		);
	}
}