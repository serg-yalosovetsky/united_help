import 'package:flutter/material.dart';
import 'package:united_help/fragment/filters.dart';
import '../fragment/card_detail.dart';


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
				child: filters(
							locations: locations, time_start: time_start, time_end: time_end,
								skills: skills, employment: employment,)
			),
		// bottomNavigationBar: buildBottomNavigationBar(_onItemTapped, selected_index),

		);
	}
}