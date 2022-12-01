import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../fragment/welcome_button.dart';
import '../services/appservice.dart';

const h1_text = 'UnitedHelp';
const h2_text = 'Через наявність інформації, що може бути використана проти населення України, просимо Вас підтвердити особу';
const verification_text = 'Підтвердження особи';
const diia_button_text = 'Дія підпис';
const bank_id_button_text = 'BankID';
const divider_text = 'або';
const verifacate_persona_button_text = 'Підтвердити особу';

class VerificationScreen extends StatelessWidget {
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
		  	  		  			child: Image.asset(
												'images/img_15.png',
												width: 108, height: 67,
		  	  		  				// width: 247.00,
		  	  		  			),
		  	  		  		),
		  	  		  		Padding(
		  	  		  			padding: EdgeInsets.fromLTRB(64, 20, 64, 0),
		  	  		  			child: Text(
												h1_text,
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
		  	  		  			margin: EdgeInsets.fromLTRB(21, 3, 21, 0),
		  	  		  			child: Text(
												h2_text,
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

								Padding(
									padding: EdgeInsets.fromLTRB(68, 20, 68, 0),
									child: Text(
										verification_text,
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
								social_button(
											text: diia_button_text,
											padding: const [72, 14, 72, 5],
											icon: Image.asset(
												"images/img_16.png",
												// color: null,
												height: 22.0,
												semanticLabel: 'Verification via Diia',
											),
								),
								social_button(
									text: bank_id_button_text,
									padding: const [72, 14, 72, 5],
									icon: Image.asset(
										"images/img_17.png",
										// color: null,
										height: 34.0,
										semanticLabel: 'Verification via Bank Id',
									),
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
												divider_text,
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
							welcome_button(
								text: 'verifacate_persona_button_text',
								padding: const [72, 14, 72, 28],
								active: false,
								fun: () {
									// app_service.is_try_login = true;
									// context.go('/login');
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
