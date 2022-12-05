import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/services/appservice.dart';
import 'package:united_help/services/validators.dart';
import 'package:united_help/services/urls.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../fragment/build_app_bar.dart';
import '../routes/routes.dart';
import '../services/authenticate.dart';

const TextStyle timerBoldStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

class build_settings_screen extends StatelessWidget {
	const build_settings_screen({super.key});
	@override
	Widget build(BuildContext context) {

		AppService app_service = Provider.of<AppService>(context, listen: false);

		return MaterialApp(
			debugShowCheckedModeBanner: false,
		  home: Scaffold(
				appBar: buildAppBar(() {
					app_service.is_try_login = true;
					context.go(APP_PAGE.login.to_path);
				}, 'Реєстрація'),
		  	backgroundColor: ColorConstant.whiteA700,
		  	body: SafeArea(
		  	  child: Container(
		  	  	// width: size.width,
		  	  	child: SingleChildScrollView(
		  	  		child: Center(
		  	  		  child: Column(
		  	  		  	// mainAxisSize: MainAxisSize.min,
		  	  		  	crossAxisAlignment: CrossAxisAlignment.center,
		  	  		  	mainAxisAlignment: MainAxisAlignment.center,
		  	  		  	children: [
										build_settings_header(text: 'Головні налаштування',),

										build_settings_link(
											text: 'Редагувати профіль',
											on_tap: () {print('tap');},
										),
										Padding(
										  padding: const EdgeInsets.fromLTRB(16, 11, 0, 0),
										  child: Divider(height: 20, color: Color(0xFFC6C6C8),  thickness: 1,),
										),
										build_settings_link(
											text: 'Обранні організатори',
											on_tap: () {print('tap2');},
											up_padding: 11,
										),
										Padding(
											padding: const EdgeInsets.fromLTRB(16, 11, 0, 0),
											child: Divider(height: 20, color: Color(0xFFC6C6C8),  thickness: 1,),
										),

										build_settings_header(
											text: 'Змінити акаунт',
											up_padding: 22,
										),
										build_settings_link(
											text: 'Волонтер',
											on_tap: () {print('tap2');},
											up_padding: 11,
											icon: Icons.check,
											active: true,
										),





										Padding(
											padding: EdgeInsets.fromLTRB(64, 34, 64, 0),
											child: Text(
												"Підтримайте UnitedHelp",
												overflow: TextOverflow.ellipsis,
												textAlign: TextAlign.left,
												style: TextStyle(
													color: ColorConstant.bluegray900,
													fontSize:22,
													fontFamily: 'SF Pro Text',
													fontWeight: FontWeight.w600,
													height: 1.00,
												),
											),
										),
										Padding(
		  	  		  			padding: EdgeInsets.fromLTRB(64, 29, 64, 0),
		  	  		  			child: KeyboardVisibilityBuilder(
													builder: (context, isKeyboardVisible) {
														return Image.asset(
															'images/img_15.png',
															// height:	isKeyboardVisible ? 78.0 : 184.0,
															width: 107,
														);
													}
											),
		  	  		  		),
										Padding(
											padding: EdgeInsets.fromLTRB(64, 29, 64, 0),
											child: Text(
												"UnitedHelp",
												overflow: TextOverflow.ellipsis,
												textAlign: TextAlign.left,
												style: TextStyle(
													color: ColorConstant.bluegray900,
													fontSize:22,
													fontFamily: 'SF Pro Text',
													fontWeight: FontWeight.w600,
													height: 1.00,
												),
											),
										),
										Container(
											// width: 222.00,
											margin: EdgeInsets.fromLTRB(25, 9, 25, 0),
											child: Text(
												"Цей додаток створенно на волонтерській основі, ваші донати допомагають нам покращувати його",
												maxLines: null,
												textAlign: TextAlign.center,
												style: TextStyle(
													color: ColorConstant.bluegray200,
													fontSize: 17,
													fontFamily: 'SF Pro Text',
													fontWeight: FontWeight.w500,
													height: 1.25,
												),
											),
										),

										welcome_button(
											text_style: TextStyle(
												fontSize: 18,
												color: Colors.white,
												fontWeight: FontWeight.w600,
											),
											text: 'Задонатити',
											padding: const [0, 33, 0, 0],
											fun: () {},
										),

									],
		  	  		  ),
		  	  		),
		  	  	),
		  	  ),
		  	),
		  ),
		);
	}
}

class build_settings_header extends StatelessWidget {
	final String text;
	final double? up_padding;
	const build_settings_header({
    Key? key,
		this.up_padding,
		required this.text,
	}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    	margin: EdgeInsets.fromLTRB(16, up_padding ?? 30.0, 0, 0),
    	child: Align(
    		alignment: Alignment.centerLeft,
    		child: Text(
					text,
    			style: timerBoldStyle,
    		),
    	),
    );
  }
}

class build_settings_link extends StatelessWidget {
	final String text;
	final Function on_tap;
	final double? up_padding;
	final IconData? icon;
	final bool active;
  const build_settings_link({
    Key? key,
		this.up_padding,
		this.icon,
		this.active = false,
		required this.text,
		required this.on_tap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
		Color get_color(icon, active) {
			if (icon == null){
				return Color(0x3C3C434D);
			} else if (active) {
				return Color(0xFF007AFF);
			} else {
				return Colors.white;
			}

		}
    return GestureDetector(
      child: Row(
      	// mainAxisSize: MainAxisSize.max,
      	mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
          	margin: EdgeInsets.fromLTRB(16, up_padding ?? 14.0, 0, 0),
          	child: Align(
          		alignment: Alignment.centerLeft,
          		child: Text(
								text,
          			style: TextStyle(
          				fontSize: 17,
          				fontWeight: FontWeight.w400,
          			),
          		),
          	),
          ),

      		Container(
      			margin: EdgeInsets.fromLTRB(0, up_padding ?? 14.0, 16, 0),
      			child: Icon(
    					icon ?? Icons.arrow_forward_ios,
    					color: get_color(icon, active),
    				)
      		),
        ],
      ),
    	onTap: () {on_tap();},
    );
  }
}

class welcome_button extends StatelessWidget {
  const welcome_button({
    Key? key,
	  required this.text_style,
	  required this.text,
	  required this.padding,
		this.fun,
  }) : super(key: key);

  final TextStyle text_style;
	final String text;
	final VoidCallback? fun;
  final List<double> padding;

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
