import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/switch_app_bar.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/notifications_screen.dart';

import '../services/appservice.dart';
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

	String event_label = 'Мої івенти';
	static const notify_label = 'Сповіщення';
	static const accaunt_label = 'Аккаунт';
	String home_label = 'Головна';
	IconData home_icon = Icons.home;
	IconData event_icon = Icons.calendar_today;
	late AppService app_service;



	@override
	Widget build(BuildContext context) {
		app_service = Provider.of<AppService>(context, listen: false);
		if (app_service.role == Roles.organizer) {
		  home_label = 'Мої івенти';
			home_icon = Icons.calendar_today;
		} else {
			home_label = 'Головна';
			home_icon = Icons.home;
		}
		if (app_service.role == Roles.organizer) {
			event_label = 'Контакти';
			event_icon = Icons.contacts_outlined;
		} else {
			event_label = 'Мої івенти';
			event_icon = Icons.calendar_today;
		}

		return BottomNavigationBar(
			items: <BottomNavigationBarItem>[
				BottomNavigationBarItem(
					icon: Icon(home_icon),
					label: home_label,
					// backgroundColor: bottom_tab_color,
				),
				BottomNavigationBarItem(
					icon: Icon(event_icon),
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
			onTap: (int index) {
				setState(() {
					selected_index = index;
					if (index==0) {
						if(app_service.role == Roles.organizer)
							if(app_service.actual_or_history == SwitchEnum.first)
								context.go(APP_PAGE.my_events.to_path);
							else
								context.go(APP_PAGE.my_events_history.to_path);
						else
							context.go('/');
					}
					if (index==1) {
							context.go(APP_PAGE.contacts.to_path);
					}
					if (index==2) {
						// context.go('/example');
						Navigator.push(
							context,
							MaterialPageRoute(
								builder: (context) => NotificationsScreen(),
							),
						);
					}
					if (index==3) {
						context.go(APP_PAGE.account.to_path);
					}

				});
			},
		);
	}


}