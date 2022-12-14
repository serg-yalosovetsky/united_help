import 'package:flutter/material.dart';

class welcome_button extends StatelessWidget {
	const welcome_button({
		Key? key,
		required this.text,
		required this.padding,
		required this.active,
		required this.fun,
	}) : super(key: key);

	final String text;
	final List<double> padding;
	final bool active;
	final Function fun;


	@override
	Widget build(BuildContext context) {
		const inactive_color = const Color(0xFFF0F3FF);
		const active_color = const Color(0xFF0071d8);
		const active_text_color = Colors.white;
		const inactive_text_color = Colors.black;
		var text_color = active_text_color;
		var button_color = active_color;
		if (!active) {
			text_color = inactive_text_color;
			button_color = inactive_color;
		}
		var text_style = TextStyle(
			color: text_color,
			fontSize: 18,
			// height: 18,
			fontFamily: 'SF Pro Text',
			fontWeight: FontWeight.w600,
		);
		return Padding(
			padding: EdgeInsets.fromLTRB(padding[0], padding[1], padding[2], padding[3]),
			child: SizedBox(
				height: 44,
				width: 230,
				child: ElevatedButton(
					style: ElevatedButton.styleFrom(
						primary: button_color,
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(22.0),
						),
					),
					onPressed: () {fun();},
					child: Text(
						text,
						style: text_style,
					),
				),
			),
		);
	}
}



class welcome_button_fun extends StatelessWidget {
	const welcome_button_fun({
		Key? key,
		required this.text,
		required this.padding,
		this.fun,
	}) : super(key: key);

	final String text;
	final VoidCallback? fun;
	final List<double> padding;
	static const text_style = TextStyle(
		fontSize: 18,
		fontFamily: 'SF Pro Text',
		fontWeight: FontWeight.w600,
	);
	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: EdgeInsets.fromLTRB(padding[0], padding[1], padding[2], padding[3]),
			child: SizedBox(
				height: 44,
				width: 230,
				child: ElevatedButton(
					style: ButtonStyle(
						shape: MaterialStateProperty.all<RoundedRectangleBorder>(
							RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(22.0),
								// side: BorderSide(color: Colors.red)
							),
						),
					),
					onPressed: fun,
					child: Text(
						text,
						style: text_style,
					),
				),
			),
		);
	}
}


class social_button extends StatelessWidget {
	const social_button({
		Key? key,
		required this.text,
		required this.padding,
		this.icon,
		this.fun,
	}) : super(key: key);

	final String text;
	final List<double> padding;
	final Widget? icon;
	final Function? fun;

	@override
	Widget build(BuildContext context) {
		const background_color = Colors.white;
		const text_color = Colors.black;
		var text_style = TextStyle(
			color: text_color,
			fontSize: 18,
			fontFamily: 'SF Pro Text',
			fontWeight: FontWeight.w600,
		);
		Widget _text = Padding(
			padding: const EdgeInsets.all(6.0),
			child: Text(
				text,
				style: text_style,
			),
		);
		return Padding(
			padding: EdgeInsets.fromLTRB(padding[0], padding[1], padding[2], padding[3]),
			child: SizedBox(
				height: 44,
				width: 230,
				child: ElevatedButton(
					style: ElevatedButton.styleFrom(
						primary: background_color,
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(22.0),
						),
					),
					onPressed: () {},
					child:
								icon!=null ? Row(
									children: [
										icon?? Container(),
										_text,
									],
								) : _text,
				),
			),
		);
	}
}
