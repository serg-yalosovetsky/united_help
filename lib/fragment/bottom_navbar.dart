import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'card_list.dart';
import '../screen/card_screen.dart';
import 'map.dart';


int selected_index = 0;

class buildBottomNavigationBar extends StatefulWidget {
	const buildBottomNavigationBar({super.key});

	@override
	State<buildBottomNavigationBar> createState() => _buildBottomNavigationBar();
}


class _buildBottomNavigationBar extends State<buildBottomNavigationBar> {
	// int selected_index = 0;
	bool selected_list = true;
	static const TextStyle optionStyle = TextStyle(
		fontSize: 30, fontWeight: FontWeight.bold);
	static const bottom_selected_tab_color = Color.fromRGBO(0, 113, 216, 1);
	static const bottom_unselected_tab_color = Color.fromRGBO(142, 142, 147, 1);

	static const home_label = 'Головна';
	static const event_label = 'Мої івенти';
	static const notify_label = 'Сповіщення';
	static const accaunt_label = 'Аккаунт';


	void _onItemTapped(int index) {
		setState(() {
			selected_index = index;
			if (index==0) {
				context.go('/');
			}
			if (index==3) {
					context.go('/account');
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		return BottomNavigationBar(
			items: const <BottomNavigationBarItem>[
				BottomNavigationBarItem(
					icon: Icon(Icons.home),
					label: home_label,
					// backgroundColor: bottom_tab_color,
				),
				BottomNavigationBarItem(
					icon: Icon(Icons.calendar_today),
					label: event_label,
					// backgroundColor: bottom_tab_color,

					// backgroundColor: Colors.green,
				),
				BottomNavigationBarItem(
					icon: Icon(Icons.notifications),
					label: notify_label,
					// backgroundColor: bottom_tab_color,
					// backgroundColor: Colors.purple,
				),
				BottomNavigationBarItem(
					icon: Icon(Icons.person),
					label: accaunt_label,
					// backgroundColor: bottom_tab_color,

					// backgroundColor: Colors.pink,
				),
			],
			currentIndex: selected_index,
			selectedItemColor: bottom_selected_tab_color,
			unselectedItemColor: bottom_unselected_tab_color,
			onTap: _onItemTapped,
		);
	}


}