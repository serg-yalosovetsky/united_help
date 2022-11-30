import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/welcome_button.dart';
import '../routes/routes.dart';
import '../services/appservice.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final app_service = Provider.of<AppService>(context);

		return MaterialApp(
		  home: Scaffold(
			  appBar: buildAppBar(() {
					app_service.is_try_register = false;
					context.go(APP_PAGE.register_login.to_path);
				}, 'Реєстрація'),
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
		  	  		  			child: Image.asset(
									'images/register.png',
		  	  		  				height: 184.00,
		  	  		  				// width: 247.00,
		  	  		  			),
		  	  		  		),

							Padding(
								padding: EdgeInsets.fromLTRB(32, 23, 32, 13),
								child: TextField(
									decoration: InputDecoration(
										border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
										hintText: 'Прізвище, ім’я',
									),
								),
							),
							Padding(
								padding: const EdgeInsets.fromLTRB(32, 0, 32, 13),
								child: TextFormField(
									decoration: InputDecoration(
										border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
										labelText: 'Email',
									),
								),
							),
							Padding(
								padding: const EdgeInsets.fromLTRB(32, 0, 32, 13),
								child: TextFormField(
									decoration: InputDecoration(
										border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
										labelText: 'Пароль',
									),
								),
							),
							welcome_button(
								text: 'Зареєструватись',
								padding: const [72, 44, 72, 0],
								active: true,
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
