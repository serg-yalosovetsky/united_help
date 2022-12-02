import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/filters.dart';
import 'package:united_help/fragment/switch_app_bar.dart';
import 'package:united_help/services/appservice.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/card_detail.dart';
import '../routes/routes.dart';


class FiltersCard extends StatelessWidget {
	const FiltersCard({super.key});

	@override
	Widget build(BuildContext context) {
		const TextStyle back_style = TextStyle(color: Colors.blue);


		const List<String> locations = ['Київ', 'Львів', 'Дніпро', 'Одеса',
		'Івано-Франківськ', 'Інше'];
		const List<String> employment = ['Постійна', 'Часткова', 'Івент'];
		const List<String> time_start = ['Fri, Jul 1', '9:41 AM'];
		const List<String> time_end = ['Sun, Jul 31', '9:41 AM'];
		const List<String> skills = [
			"Microsoft Office", "Комунікативність",
			"Пунктуальність", "Організованість"
		];
		// AppService _app_service = Provider.of<AppService>(context, listen: false);

		return Scaffold(
			appBar: buildAppBar(() {
				Navigator.pop(context);
			}, 'Фільтри', 'Зберегти'),
			body: SafeArea(
				child: filters(
							locations: locations, time_start: time_start, time_end: time_end,
								skills: skills, employment: employment,)
			),
		// bottomNavigationBar: buildBottomNavigationBar(_onItemTapped, selected_index),

		);
	}
}