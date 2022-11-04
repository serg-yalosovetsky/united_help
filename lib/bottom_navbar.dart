import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'card_list.dart';
import 'card_screen.dart';
import 'map.dart';

BottomNavigationBar buildBottomNavigationBar(fun, int selected_index) {
	const home_label = 'Головна';
	const event_label = 'Мої івенти';
	const notify_label = 'Сповіщення';
	const accaunt_label = 'Аккаунт';
	// int selected_index = 0;
	const bottom_selected_tab_color = Color.fromRGBO(0, 113, 216, 1);
	const bottom_unselected_tab_color = Color.fromRGBO(142, 142, 147, 1);

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
		onTap: fun,
	);
}

