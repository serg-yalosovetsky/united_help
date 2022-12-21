import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/welcome_button.dart';
import 'package:united_help/screen/card_screen.dart';
import 'package:united_help/services/appservice.dart';
import 'package:united_help/services/authenticate.dart';

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
	@override
	void initState() {
		app_service = Provider.of<AppService>(context, listen: false);

		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		print('futureEvents');
		futureEvents = fetchEvents(widget.event_query, app_service);

		return Consumer<AppService>(
		  builder: (context, cart, child) {
				return Center(
		  			child: FutureBuilder<Events>(
		  				future: futureEvents,
		  				builder: (context, snapshot) {
		  					if (snapshot.hasData) {

									if (snapshot.data!.count <= 0){
										return build_no_actual_widgets();
									}

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
		  														builder: (context) => EventScreen(event: snapshot.data!.list[index],),
		  													),
		  												);
		  											},

		  									);
		  								},
		  							);
		  						else {
										var widget_list = List<Widget>.generate(
											snapshot.data!.count,
											(index) {
												return GestureDetector(
													child: card_builder(snapshot.data!.list[index], app_service),
													onTap: () {
															setState(() {
																Navigator.of(context).push(
																	MaterialPageRoute(
																		builder: (context) => EventScreen(
																			event: snapshot.data!.list[index],
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
		  						return build_no_internet();
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


Widget card_builder(Event event, AppService app_service) {
	String employment_string = '';
	if (event.employment == 0)
		employment_string = 'Постійна зайнятість';
	else if (event.employment == 1)
		employment_string = show_nice_time(event.start_time, event.end_time);
	else if (event.employment == 2)
		employment_string = show_nice_time(event.start_time);

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
					print(rating);
				},
			),

			welcome_button_fun(
				text: 'Залиште відгук',
				padding: [0, 14, 0, 16],
				fun: () {},
			),
		],
	);

	Widget organizer_rating = Column(
		children: [
			RatingBar.builder(
				initialRating: 0,
				minRating: 0,
				direction: Axis.horizontal,
				allowHalfRating: true,
				itemCount: 5,
				itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
				itemBuilder: (context, _) => Icon(
					Icons.star,
					color: Colors.amber,
					size: 14,
				),
				onRatingUpdate: (rating) {
					print(rating);
				},
			),

			welcome_button_fun(
				text: 'Залиште відгук',
				padding: [0, 14, 0, 16],
				fun: () {},
			),
		],
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
												child: Text(event.name, style: optionStyle,),
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