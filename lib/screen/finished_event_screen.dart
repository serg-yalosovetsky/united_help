import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../fragment/bottom_navbar.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
import '../fragment/skill_card.dart';
import '../services/appservice.dart';
import '../services/authenticate.dart';
import '../models/events.dart';
import '../services/show_nice_time.dart';
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

class FinishedEventScreen extends StatefulWidget {
	final Event event;
	const FinishedEventScreen({super.key, required this.event});

  @override
  State<FinishedEventScreen> createState() => _FinishedEventScreenState();
}

class _FinishedEventScreenState extends State<FinishedEventScreen> {

	static const TextStyle optionStyle = 	TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
	static const TextStyle timerStyle = TextStyle(
		fontSize: 18,
	);
	static const TextStyle timerBoldStyle =
	TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

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

	@override
  void initState() {
		app_service = Provider.of<AppService>(context, listen: false);
    super.initState();
  }

	@override
	Widget build(BuildContext context) {
		String title = 'Finished event';
		if (app_service.current_profile?.organization != null &&
				app_service.current_profile!.organization!.isNotEmpty)
				title = app_service.current_profile!.organization!;
		return Scaffold(
			appBar: buildAppBar(
			() {
				Navigator.pop(context);
			},
				title,
			),
			backgroundColor: Colors.white,
			// foregroundColor: Colors.blue,

			body: SafeArea(
					child: Scaffold(
						body: Container(
							margin: EdgeInsets.all(10),
							child: Expanded(
								child: ListView(
									shrinkWrap: true,
									children: [
										Container(
											child: ClipRRect(
												borderRadius: BorderRadius.circular(20.0),
												child: ConstrainedBox(
													constraints: const BoxConstraints(
														minWidth: 70,
														minHeight: 80,
														maxWidth: double.infinity,
														maxHeight: 450,
													),
													child: Image(
															image: CachedNetworkImageProvider(widget.event.image),
															fit: BoxFit.fitWidth
													),
												),
											),
										),
										Container(
											height: 800,
											child: Column(
												mainAxisAlignment: MainAxisAlignment.start,
												mainAxisSize: MainAxisSize.min,
												children: [
													build_bold_left_text(widget.event.name),
													Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: [

															build_location(
																'Відбувся',
																Icons.access_time_outlined,
																text_color: Color(0xFF748B9F),
															),

															RatingBar.builder(
																initialRating: widget.event.rating,
																minRating: 0,
																direction: Axis.horizontal,
																allowHalfRating: true,
																itemCount: 5,
																itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
																itemBuilder: (context, _) => Icon(
																	Icons.star,
																	color: Colors.amber,
																),
																itemSize: 14,
																ignoreGestures: true,
																onRatingUpdate: (rating) {
																	print(rating);
																},
															),
														],
													),

													build_bold_left_text('Відгуки волонтерів'),

												],
											),
										)
									],
								),
							),
						),
						bottomNavigationBar: buildBottomNavigationBar(),

					),

			),

		);
	}
}