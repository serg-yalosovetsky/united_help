import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../fragment/welcome_button.dart';
import '../services/appservice.dart';

class WelcomeRegisterOrLoginScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final app_service = Provider.of<AppService>(context);

		return MaterialApp(
		  home: Scaffold(
		  	backgroundColor: ColorConstant.whiteA700,
		  	body: SafeArea(
		  	  child: Container(
		  	  	child: SingleChildScrollView(
		  	  		child: Center(
		  	  		  child: Column(
		  	  		  	mainAxisSize: MainAxisSize.min,
		  	  		  	crossAxisAlignment: CrossAxisAlignment.center,
		  	  		  	mainAxisAlignment: MainAxisAlignment.start,
		  	  		  	children: [
		  	  		  		Padding(
		  	  		  			padding: EdgeInsets.fromLTRB(64, 74, 64, 0),
		  	  		  			child: SvgPicture.asset(
									'images/img_group26649.svg',
		  	  		  				height: 184.00,
		  	  		  				// width: 247.00,
		  	  		  			),
		  	  		  		),
		  	  		  		Padding(
		  	  		  			padding: EdgeInsets.fromLTRB(64, 20, 64, 0),
		  	  		  			child: Text(
		  	  		  				"Вітаємо в UnitedHelp",
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
		  	  		  			width: 227.00,
		  	  		  			margin: EdgeInsets.fromLTRB(64, 3, 64, 0),
		  	  		  			child: Text(
		  	  		  				"Ми допоможемо знайти те, що ти шукаєш)",
		  	  		  				maxLines: null,
		  	  		  				textAlign: TextAlign.center,
		  	  		  				style: TextStyle(
		  	  		  					color: ColorConstant.bluegray200,
		  	  		  					fontSize: 16,
		  	  		  					fontFamily: 'SF Pro Text',
		  	  		  					fontWeight: FontWeight.w500,
		  	  		  					height: 1.25,
		  	  		  				),
		  	  		  			),
		  	  		  		),

							welcome_button(
								text: 'Зареєструватись',
								padding: const [72, 44, 72, 0],
								active: true,
								fun: () {
									app_service.is_try_register = true;
									context.go('/register');
									},

							),
							  welcome_button(
								  text: 'Увійти в акаунт',
								  padding: const [72, 14, 72, 28],
								  active: false,
									fun: () {
										app_service.is_try_login = true;
										context.go('/login');
										},

								),
							Row(
							  children: const [
								  Expanded(
									  flex: 3,
									  child: Padding(
									    padding: EdgeInsets.fromLTRB(25.0, 0, 0, 0),
									    child: Divider(height: 20, color: Color(0xFFBDD2E4),  thickness: 2,),
									  )),
								  Expanded(
								    child: Padding(
								      padding: EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
								      child: Text(
										  'або',
										  style: TextStyle(
											  color: Color(0xFF748B9F),
											  fontSize: 18,
											  // height: 18,
											  fontFamily: 'SF Pro Text',
											  fontWeight: FontWeight.w600,
										  ),
									  ),
								    ),
								  ),
								  Expanded(
									  flex: 3,
									  child: Padding(
									    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
									    child: Divider(height: 20, color: Color(0xFFBDD2E4),  thickness: 2,),
									  )),
							  ],
							),
							social_button(
								  text: 'Увійти з Google',
								  padding: const [72, 14, 72, 5],
								  icon: Image.asset(
								    "images/img_icons8google1.png",
										  // color: null,
										  height: 32.0,
										  semanticLabel: 'Login via google',
								    ),
							  ),
							social_button(
							      text: 'Увійти з Facebook',
								  padding: const [72, 14, 72, 5],
								  icon: Icon(
									  Icons.facebook,
									  color: Color(0xFF0b85e0),
									  size: 32.0,
									  semanticLabel: 'Login via facebook',
								  )
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
