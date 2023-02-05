import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/welcome_button.dart';
import 'package:united_help/screen/card_screen.dart';
import 'package:united_help/providers/appservice.dart';
import 'package:united_help/services/authenticate.dart';

import '../constants/styles.dart';
import '../screen/finished_event_screen.dart';
import '../screen/new_event_choose_help_or_job.dart';
import '../providers/filters.dart';
import '../services/debug_print.dart';
import '../services/show_nice_time.dart';
import 'get_location_permission.dart';
import 'no_actual_events.dart';
import 'no_internet.dart';
import 'skill_card.dart';
import '../models/events.dart';
import '../services/urls.dart';


class EventListHistoryScreen extends StatefulWidget {
	final String event_query;
	final bool is_listview;
	 EventListHistoryScreen({
		super.key,
		required this.event_query,
		this.is_listview = true,
	});

	@override
	State<EventListHistoryScreen> createState() => _EventListHistoryScreenState();
}

class _EventListHistoryScreenState extends State<EventListHistoryScreen> {
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
				return Center(
		  			child: FutureBuilder<Events>(
		  				future: fetchEvents(widget.event_query, app_service, filters),
		  				builder: (context, snapshot) {
		  					if (snapshot.hasData) {
									if (snapshot.data!.count <= 0){
										app_service.organizer_has_no_events = true;
										return NewEventChooseHelpOrJobScreen();
										// return build_no_actual_widgets();
									}
									app_service.organizer_has_no_events = false;

		  						if (widget.is_listview)
		  							return ListView.builder(
		  								scrollDirection: Axis.vertical,
		  								shrinkWrap: true,
		  								itemCount: snapshot.data!.count,
		  								itemBuilder: (context, index) {
		  									return GestureDetector(
		  											child: card_builder(snapshot.data!.list[index], app_service),
		  											onTap: () {
		  												Navigator.of(context).push(
		  													MaterialPageRoute(
		  														builder: (context) => FinishedEventScreen(
																		event: snapshot.data!.list[index],
																	),
		  													),
		  												);
		  											},

		  									);
		  								},
		  							);
		  						else {
										return Column(
											children: List<Widget>.generate(
												snapshot.data!.count,
												(index) {
													return GestureDetector(
														child: card_builder(snapshot.data!.list[index], app_service),
														onTap: () {
																setState(() {
																	Navigator.of(context).push(
																		MaterialPageRoute(
																			builder: (context) => FinishedEventScreen(
																				event: snapshot.data!.list[index],
																			),
																		),
																	);
																});

														},
													);
												},
											),
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
	}
}


Widget card_builder(Event event, AppService app_service) {
	Widget volunteer_rating = Column(
		children: [
			RatingBar.builder(
				initialRating: 0,
				minRating: 0,
				direction: Axis.horizontal,
				allowHalfRating: true,
				itemCount: 5,
				itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
				itemBuilder: (context, _) => Icon(
					Icons.star,
					color: Colors.amber,
				),
				onRatingUpdate: (rating) {
					dPrint(rating);
				},
			),

			welcome_button_fun(
				text: 'Залиште відгук',
				padding: [0, 14, 0, 16],
				fun: () {},
			),
		],
	);
	Widget organizer_rating = Align(
	  alignment: Alignment.topLeft,
		child: Padding(
		  padding: const EdgeInsets.only(left: 18),
		  child: Column(
	  	crossAxisAlignment: CrossAxisAlignment.start,
	  	children: [
	  		Padding(padding: EdgeInsets.only(top: 9)),
	  		RatingBar.builder(
	  			initialRating: event.rating,
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
	  				dPrint(rating);
	  			},
	  		),

	  		Padding(
	  		  padding: const EdgeInsets.fromLTRB(0, 4, 0, 17),
	  		  child: Text('${event.comments_count} коментарі'),
	  		),
	  	],
	  ),
		),
	);

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

											app_service.role==Roles.organizer ? organizer_rating : volunteer_rating,

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