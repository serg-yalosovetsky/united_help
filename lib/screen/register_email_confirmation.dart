import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/providers/appservice.dart';
import 'package:united_help/services/validators.dart';
import 'package:united_help/services/urls.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../fragment/build_app_bar.dart';
import '../routes/routes.dart';
import '../services/authenticate.dart';

class RegisterEmailConfirmationScreen extends StatelessWidget {
	const RegisterEmailConfirmationScreen({super.key});
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
		  	  		  		Padding(
		  	  		  			padding: EdgeInsets.fromLTRB(64, 147, 64, 0),
		  	  		  			child: KeyboardVisibilityBuilder(
													builder: (context, isKeyboardVisible) {
														return Image.asset(
															'images/img.png',
															height:	isKeyboardVisible ? 78.0 : 184.0,
														);
													}
											),
		  	  		  		),
										Padding(
											padding: EdgeInsets.fromLTRB(64, 20, 64, 0),
											child: Text(
												"Ми надіслали Email",
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
											width: 222.00,
											margin: EdgeInsets.fromLTRB(77, 3, 77, 0),
											child: Text(
												"Будь ласка, підтвердіть свою особистість в Email",
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

