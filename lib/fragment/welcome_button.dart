import 'package:flutter/material.dart';

import '../constants/colors.dart';

class welcome_button extends StatelessWidget {
	const welcome_button({
		Key? key,
		required this.text,
		this.padding,
		this.active = false,
		required this.fun,
		this.text_style,
		this.icon_widget,
	}) : super(key: key);

	final TextStyle? text_style;
	final String text;
	final Widget? icon_widget;
	final List<double>? padding;
	final bool active;
	final dynamic fun;


	@override
	Widget build(BuildContext context) {
		var text_color = ColorConstant.active_text_color;
		var button_color = ColorConstant.Volonterka_theme_color;
		if (!active) {
			text_color = ColorConstant.inactive_text_color;
			button_color = ColorConstant.Background_for_chips;
		}
		Widget button_text = Text(
			text,
			style: text_style ?? TextStyle(
				color: text_color,
				fontSize: 18,
				fontFamily: 'SF Pro Text',
				fontWeight: FontWeight.w600,
			),
		);
		Widget button_label = Row(
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			mainAxisSize: MainAxisSize.min,
			children: [
				button_text,
				icon_widget ?? Container(),
		],);
		Widget button = SizedBox(
			height: 44,
			child: ElevatedButton(
				style: ElevatedButton.styleFrom(
					primary: button_color,
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(22.0),
					),
				),
				onPressed: () {fun();},
				child: icon_widget!=null ? button_label : button_text,
			),
		);
		if (padding != null) {
		  return Padding(
			padding: EdgeInsets.fromLTRB(padding![0], padding![1], padding![2], padding![3]),
			child: button,
		);
		} else {
		  return button;
		}
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
				child: ElevatedButton(
					style: ElevatedButton.styleFrom(
						primary: background_color,
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(22.0),
						),
					),
					onPressed: () {
						if (fun != null) {
						  fun!();
						}
					},
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
