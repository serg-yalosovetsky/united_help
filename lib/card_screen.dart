import 'package:flutter/material.dart';
import 'bottom_navbar.dart';
import 'card_detail.dart';
import 'card_list.dart';


class JobCard extends StatelessWidget {
	const JobCard({super.key});

	@override
	Widget build(BuildContext context) {
		const TextStyle back_style = TextStyle(color: Colors.blue);

		return Scaffold(
			appBar: AppBar(
				title: const Text(
					'Назад',
					style: back_style,
				),
				backgroundColor: Colors.white,
				foregroundColor: Colors.blue,
			),
			body: const SafeArea(
				child: card_detail()
			),
		// bottomNavigationBar: buildBottomNavigationBar(_onItemTapped, selected_index),

		);
	}
}