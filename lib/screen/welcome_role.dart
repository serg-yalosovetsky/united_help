import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/fragment/skill_card.dart';
import 'package:united_help/routes/routes.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../fragment/welcome_button.dart';
import '../providers/appservice.dart';

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
			debugShowCheckedModeBanner: false,
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
		  	  		  			padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
		  	  		  			child: Text(
		  	  		  				"Вітаємо в UnitedHelp",
		  	  		  				overflow: TextOverflow.ellipsis,
		  	  		  				textAlign: TextAlign.left,
		  	  		  				style: TextStyle(
		  	  		  					color: ColorConstant.bluegray900,
		  	  		  					fontSize: 22,
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

										IntrinsicWidth(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.stretch,
												mainAxisSize: MainAxisSize.max,
												children: [

													welcome_button(
														text: 'Потребую допомогу',
														padding: const [0, 44, 0, 0],
														active: true,
														fun: () {
															app_service.role = Roles.refugee;
															app_service.onboarding = true;
															context.go(APP_PAGE.register_login.to_path);
														},
													),
													welcome_button(
														text: 'Волонтер',
														padding: const [0, 14, 0, 0],
														active: false,
														fun: () {
															app_service.role = Roles.volunteer;
															app_service.onboarding = true;
															context.go(APP_PAGE.register_login.to_path);
														},
													),
													welcome_button(
														text: 'Організатор',
														padding: const [0, 14, 0, 5],
														active: false,
														fun: () {
															app_service.role = Roles.organizer;
															app_service.onboarding = true;
															context.go(APP_PAGE.register_login.to_path);
														},
													),
												],
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
