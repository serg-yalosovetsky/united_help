import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/colors.dart';
import '../constants/styles.dart';
import '../fragment/welcome_button.dart';
import '../providers/appservice.dart';
import '../services/debug_print.dart';

class WelcomeRegisterOrLoginScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final app_service = Provider.of<AppService>(context);

		return MaterialApp(
			debugShowCheckedModeBanner: false,
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
		  	  		  			padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
		  	  		  			width: 240.00,
		  	  		  			margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
		  	  		  			child: Text(
		  	  		  				"Ми допоможемо знайти те, що ти шукаєш)",
												maxLines: 2,
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
														text: 'Зареєструватись',
														padding: const [72, 44, 72, 0],
														active: true,
														fun: () {
															app_service.is_try_register = true;
															app_service.current_location = '/register';
															context.go('/register');
															},
													),
													welcome_button(
														text: 'Увійти в акаунт',
														padding: const [72, 14, 72, 28],
														active: false,
														fun: () {
															app_service.is_try_login = true;
															app_service.current_location = '/login';
															context.go('/login');
														},
													),
									    ],
									  ),
									),

									Row(
										children: [
											const Expanded(
												flex: 3,
												child: Padding(
													padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
													child: Divider(height: 16, color: Color(0xFFBDD2E4),  thickness: 2,),
												)),
											Expanded(
												child: Padding(
													padding: EdgeInsets.fromLTRB(10, 0, 7, 0),
													child: Text(
													'або',
													style: StyleConstant.bold_help,
												),
												),
											),
											const Expanded(
												flex: 3,
												child: Padding(
													padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
													child: Divider(height: 16, color: Color(0xFFBDD2E4),  thickness: 2,),
												)),
										],
									),


											IntrinsicWidth(
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.stretch,
													mainAxisSize: MainAxisSize.max,
													children: [
														social_button(
																text: 'Увійти з Google',
																padding: const [0, 14, 0, 5],
																icon: Image.asset(
																	"images/img_icons8google1.png",
																		// color: null,
																		height: 32.0,
																		semanticLabel: 'Login via google',
																	),
																fun: () {

																	GoogleSignIn _googleSignIn = GoogleSignIn(
																		scopes: [
																			'email',
																			'https://www.googleapis.com/auth/contacts.readonly',
																		],
																	);

																	Future<void> _handleSignIn() async {
																		try {
																			await _googleSignIn.signIn();
																		} catch (error) {
																			dPrint(error);
																		}
																	}
																	_handleSignIn();
																},
															),

														social_button(
															text: 'Увійти з Facebook',
															padding: const [0, 14, 0, 5],
															icon: Icon(
																Icons.facebook,
																color: Color(0xFF0b85e0),
																size: 32.0,
																semanticLabel: 'Login via facebook',
															),
															fun: () async {
																dPrint('Увійти з Facebook');
																// Create an instance of FacebookLogin
																final fb = FacebookLogin();

																// Log in
																var res = await fb.expressLogin();

																if (res.status == FacebookLoginStatus.success) {
																	final FacebookAccessToken? accessToken = res.accessToken;
																	dPrint('Access token: ${accessToken?.token}');
																}
																else {
																	// Log in
																	res = await fb.logIn(
																		permissions: [
																			FacebookPermission.publicProfile,
																			FacebookPermission.email,
																		],
																	);

																	if (res != null) {

																		switch (res.status) {
																			case FacebookLoginStatus.success:
																			// Logged in

																			// Send access token to server for validation and auth
																				final FacebookAccessToken? accessToken = res!.accessToken;

																				if (accessToken != null) {
																					dPrint('Access token: ${accessToken.token}');

																					// Get profile data
																					final profile = await fb.getUserProfile();
																					dPrint('Hello, ${profile?.name}! You ID: ${profile
																							?.userId}');

																					// Get user profile image url
																					final imageUrl = await fb.getProfileImageUrl(
																							width: 100);
																					dPrint('Your profile image: $imageUrl');

																					// Get email (since we request email permission)
																					final email = await fb.getUserEmail();
																					// But user can decline permission
																					if (email != null)
																						dPrint('And your email is $email');
																				}
																				break;
																			case FacebookLoginStatus.cancel:
																			// User cancel log in
																				break;
																			case FacebookLoginStatus.error:
																			// Log in failed
																				dPrint('Error while log in: ${res.error}');
																				break;
																		}
																	}
																	else {
																		dPrint('Error while log in: ${res}');
																	}

																}

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
