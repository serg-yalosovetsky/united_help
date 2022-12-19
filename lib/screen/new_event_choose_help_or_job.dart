import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/new_event_screen.dart';

import '../constants/colors.dart';
import '../fragment/bottom_navbar.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/welcome_button.dart';
import '../services/appservice.dart';

class NewEventChooseHelpOrJobScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final app_service = Provider.of<AppService>(context);

		return MaterialApp(
			debugShowCheckedModeBanner: false,
		  home: Scaffold(
				appBar: buildAppBar(null, 'Новий івент',),
				bottomNavigationBar: const buildBottomNavigationBar(),
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
		  	  		  				"Для кого цей івент?",
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
		  	  		  				"Знайдіть волонтерів, або повідомте потребуючих",
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
											text: 'Надати допомогу',
											padding: const [72, 44, 72, 0],
											active: true,
											fun: () {
												Navigator.of(context).push(
													MaterialPageRoute(
														builder: (context) => NewEventScreen(event_for: Roles.refugee.toString(),),
													),
												);
												},

										),
										welcome_button(
											text: 'Шукаю волонтерів',
											padding: const [72, 14, 72, 28],
											active: false,
											fun: () {
												Navigator.of(context).push(
													MaterialPageRoute(
														builder: (context) => NewEventScreen(event_for: Roles.volunteer.toString(),),
													),
												);
												},

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
