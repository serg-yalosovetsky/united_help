import 'package:flutter/material.dart';
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
	// late Future<Event> future_event;

	// @override
	// void initState() {
	// 	super.initState();
	// 	// future_event = fetchEvent(widget.event);
	// }
	@override
	Widget build(BuildContext context) {
		const TextStyle back_style = TextStyle(color: Colors.blue);
		// const String title = 'Гуманітарний штаб м.Тернопіль сортування продуктових наборів';
		// const String image = 'images/Best-TED-Talks-From-The-Curator-Himself-.jpg';
		// const String location = 'Вул. Валова, 27';
		// const String time = 'Постійна зайнятість';
		// const String description = 'Запрошуємо волонтерів до гуманітарного штабу Тернополя. Ми потребуємо допомогу в розвантаженні фур, сортуванні гуманітарної допомоги, пакуванні на фронт й видачі допомоги потребуючим людям.';
		// const List skills = [
		// 	"Microsoft Office", "Комунікативність",
		// 	"Пунктуальність", "Організованість"
		// ];
		// print( widget.event);
		return Scaffold(
			appBar: AppBar(
				title: const Text(
					'Назад',
					style: back_style,
				),
				backgroundColor: Colors.white,
				foregroundColor: Colors.blue,
			),
			body: SafeArea(
					child: card_detail(event: widget.event),
				// 	child: FutureBuilder<Event>(
				// 	future: future_event,
				// 	builder: (context, snapshot) {
				// 		if (snapshot.hasData) {
				// 			// return Text(snapshot.data!.count.toString());
				// 			return card_detail(event: snapshot.data!);
				// 			// card_builder(snapshot.data!.list[index]);
				// 		} else if (snapshot.hasError) {
				// 			return Text('${snapshot.error}');
				// 		}
				//
				// 		return const CircularProgressIndicator();
				// 	}
				// ),

			),

		);
	}
}