import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/skill_card.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../fragment/welcome_button.dart';
import '../services/appservice.dart';

class WelcomeRoleScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final app_service = Provider.of<AppService>(context);
		var SFProTextSemibold18 = TextStyle(
			color: ColorConstant.whiteA700,
			fontSize: 18,
			// height: 18,
			fontFamily: 'SF Pro Text',
			fontWeight: FontWeight.w600,
		);
		// final String assetName = 'images/img_group26649.svg';
		// final Widget svg = SvgPicture.asset(
		// 	assetName,
		// 	semanticsLabel: 'Acme Logo'
		// );
		return MaterialApp(
		  home: Scaffold(
		  	backgroundColor: ColorConstant.whiteA700,
		  	body: SafeArea(
		  	  child: Container(
		  	  	// width: size.width,
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
		  	  		  				// ImageConstant.imgGroup26649,
									'images/img_group26649.svg',
									// 'images/Best-TED-Talks-From-The-Curator-Himself-.jpg',
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
								text: 'Потребую допомогу',
								padding: const [72, 44, 72, 0],
								active: true,
								fun: () {
									app_service.role = 'refugee';
									app_service.onboarding = true;
								},
							),
							  welcome_button(
								  text: 'Волонтер',
								  padding: const [72, 14, 72, 0],
								  active: false,
									fun: () {
										app_service.role = 'volunteer';
										app_service.onboarding = true;
									},
							  ),
							  welcome_button(
								  text: 'Організатор',
								  padding: const [72, 14, 72, 5],
								  active: false,
									fun: () {
										app_service.role = 'organizer';
										app_service.onboarding = true;
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
