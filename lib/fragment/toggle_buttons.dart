
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/colors.dart';


int selected_index = 0;
var items = ['Актуальне', 'На мапі'];

class build_toggle_buttons extends StatefulWidget {
	const build_toggle_buttons({super.key});

	@override
	State<build_toggle_buttons> createState() => _build_toggle_buttons();
}


class _build_toggle_buttons extends State<build_toggle_buttons> {
	Color grey_shadow = ColorConstant.Background_for_chips;
	void _onItemTapped(int index) {
		setState(() {
			selected_index = index;
			if (selected_index == 0) {
				// _app_service.current_location = '${APP_PAGE.new_events.to_path}/${event.id}';
				context.go('/');
			}
			if (selected_index == 1) {
				// app_service.current_location = '${APP_PAGE.new_events.to_path}/${event.id}';
				context.go('/map');
			}
		});
	}

	Widget build_passive_button(String text, int elem) {
		return TextButton(
			style: TextButton.styleFrom(
				// foregroundColor: Colors.black,
				padding: const EdgeInsets.fromLTRB(16.0, 13.0, 13.0, 13.0),
				textStyle: const TextStyle(fontSize: 20),
			),
			onPressed: () {_onItemTapped(elem);},
			child: Text(text),
		);
	}
	Widget build_active_button(String text, int elem) {
		return ElevatedButton(
			style: ElevatedButton.styleFrom(
				// foregroundColor: Colors.black,
				shape:
				RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(10.0),
				),
				textStyle: const TextStyle(fontSize: 20, color: Colors.black),
				padding: const EdgeInsets.fromLTRB(16.0, 13.0, 13.0, 13.0),
				// backgroundColor: Colors.white,
			),
			onPressed: () {_onItemTapped(elem);},
			child: Text(text),
		);
	}
	int next(int curr, int min, int max){
		int next_ = ++curr;
		if (next_ > max) {
			next_ = min;
		}
		return next_;
	}
	List<Widget> return_active_or_passive(selected) {
		int next_ = next(selected_index, 0, items.length -1);
		// dPrint('selected $selected_index next $next_ max ${ items.length -1}');
		if (selected == 0) {
			return [
				build_active_button(items[0], selected),
				build_passive_button(items[1], next_),
			];
		}
		else {
			return [
				build_passive_button(items[0], next_),
				build_active_button(items[1], selected),
			];

		}
	}


	@override
	Widget build(BuildContext context) {
		return Card(
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(10.0),
			),
			color: grey_shadow,
			child: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				mainAxisSize: MainAxisSize.min,
				children: return_active_or_passive(selected_index),
			),
		);
	}


}