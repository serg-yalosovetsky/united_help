import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:united_help/screen/settings_screen.dart';
import 'package:united_help/services/validators.dart';
import 'package:united_help/services/urls.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../fragment/build_app_bar.dart';
import '../routes/routes.dart';
import '../services/appservice.dart';
import '../services/authenticate.dart';

class EditAccountScreen extends StatefulWidget {
	const EditAccountScreen({super.key});
  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {

	final _form_key_name = GlobalKey<FormState>();
	final _form_key_phone = GlobalKey<FormState>();
	final _form_key_telegram = GlobalKey<FormState>();
	final _form_key_viber = GlobalKey<FormState>();
	final _form_key_bio = GlobalKey<FormState>();
	final _form_key_email = GlobalKey<FormState>();
	List<bool> button_states = [false, false];
	final int name_index = 0;
	final int email_index = 1;
	final name_controller = TextEditingController();
	final phone_controller = TextEditingController();
	final telegram_controller = TextEditingController();
	final viber_controller = TextEditingController();
	final bio_controller = TextEditingController();
	final email_controller = TextEditingController();
	late AppService app_service;
	@override
	void dispose() {
		// Clean up the controller when the widget is disposed.
		name_controller.dispose();
		bio_controller.dispose();
		email_controller.dispose();
		phone_controller.dispose();
		telegram_controller.dispose();
		viber_controller.dispose();
		super.dispose();
	}

	void initState() {
		app_service = Provider.of<AppService>(context, listen: false);
		name_controller.text = app_service.user?.username ?? '';
		email_controller.text = app_service.user?.email ?? '';
		bio_controller.text = app_service.current_profile?.description ?? '';
		phone_controller.text = app_service.user?.phone ?? '';
		telegram_controller.text = app_service.user?.nickname ?? app_service.user?.telegram_phone ?? '';
		viber_controller.text = app_service.user?.viber_phone ?? '';
	}

	@override
	Widget build(BuildContext context) {
		var SFProTextSemibold18 = TextStyle(
			color: ColorConstant.whiteA700,
			fontSize: 18,
			// height: 18,
			fontFamily: 'SF Pro Text',
			fontWeight: FontWeight.w600,
		);

		Widget form_name = Form(
			key: _form_key_name,
			child: Padding(
				padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
				child: TextFormField(
					keyboardType: TextInputType.text,
					controller: name_controller,
					autovalidateMode: AutovalidateMode.onUserInteraction,
					validator: (value) {
						if (value == null || value.isEmpty) {
							return 'Ім’я не може бути пустим';
						}
						return null;
					},
					onChanged: (text) {
						setState(() {
							if (_form_key_name.currentState!.validate())
								button_states[name_index] = true;
							else
								button_states[name_index] = false;
						});
					},
					decoration: InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
						hintText: 'Прізвище, ім’я',
						suffixIcon: IconButton(
							onPressed: () {
									name_controller.clear();
									button_states[name_index] = false;
							},
							icon: Icon(
									Icons.clear,
							),
						),
					),
				),
			),
		);
		Widget form_phone = Row(
		  children: [
				Padding(
					padding: EdgeInsets.fromLTRB(16, 13, 0, 0),
					child: Icon(Icons.phone),
				),
		    Flexible(
		      child: Form(
						key: _form_key_phone,
		      	child: Padding(
		      		padding: const EdgeInsets.fromLTRB(10, 13, 16, 0),
		      		child: TextFormField(
								keyboardType: TextInputType.phone,
								controller: phone_controller,
		      			autovalidateMode: AutovalidateMode.onUserInteraction,
		      			validator: (value) {
									print(value);
									if (value == '123')
										return '123';
		      				if (!(value == null || value.isEmpty)) {
										final is_phone = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
										if (is_phone.hasMatch(value))
											return null;
										else
											return 'phone is not valid';
		      				}
		      						return null;
		      					},
								onChanged: (text) {_form_key_phone.currentState?.validate();},
		      			decoration: InputDecoration(
		      				border: OutlineInputBorder(
		      					borderRadius : BorderRadius.all(Radius.circular(16.0)),
		      				),
		      				hintText: 'phone',
		      				suffixIcon: IconButton(
		      					onPressed: phone_controller.clear,
		      					icon: Icon(
		      						Icons.clear,
		      					),
		      				),
		      			),
		      		),
		      	),
		      ),
		    ),
		  ],
		);
		Widget form_telegram = Row(
			children: [
				Padding(
					padding: EdgeInsets.fromLTRB(16, 13, 0, 0),
					child: Icon(
						Icons.telegram_rounded,
						color: Color(0xff29b6f6),
						size: 26,
					),
				),
				Flexible(
					child: Form(
						key: _form_key_telegram,
						child: Padding(
							padding: const EdgeInsets.fromLTRB(10, 13, 16, 0),
							child: TextFormField(
								keyboardType: TextInputType.text,
								controller: telegram_controller,
								autovalidateMode: AutovalidateMode.onUserInteraction,
								validator: (value) {
									print(value);
									if (value == '123')
										return '123';
									if (!(value == null || value.isEmpty)) {
										final is_phone = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
										final is_nickname = RegExp(r'(^(@)[a-z]{1,}$)');
										if (is_phone.hasMatch(value) || is_nickname.hasMatch(value))
											return null;
										else
											return 'telegram phone?/nickname is invalid';
									}
									return null;
								},
								onChanged: (text) {_form_key_telegram.currentState?.validate();},
								decoration: InputDecoration(
									border: OutlineInputBorder(
										borderRadius : BorderRadius.all(Radius.circular(16.0)),
									),
									hintText: 'telegram',
									suffixIcon: IconButton(
										onPressed: telegram_controller.clear,
										icon: Icon(
											Icons.clear,
										),
									),
								),
							),
						),
					),
				),
			],
		);
		Widget form_viber = Row(
			children: [
				Padding(
					padding: EdgeInsets.fromLTRB(16, 13, 0, 0),
					child: Image.asset(
						"images/img_24.png",
						// color: null,
						width: 26.0,
						semanticLabel: 'Login via google',
					),
				),
				Flexible(
					child: Form(
						key: _form_key_viber,
						child: Padding(
							padding: const EdgeInsets.fromLTRB(10, 13, 16, 0),
							child: TextFormField(
								keyboardType: TextInputType.phone,
								controller: viber_controller,
								autovalidateMode: AutovalidateMode.onUserInteraction,
								validator: (value) {
									print(value);
									if (!(value == null || value.isEmpty)) {
										final is_phone = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
										if (is_phone.hasMatch(value))
											return null;
										else
											return 'viber phone  is not valid';
									}
									return null;
								},
								onChanged: (text) {_form_key_viber.currentState?.validate();},
								decoration: InputDecoration(
									border: OutlineInputBorder(
										borderRadius : BorderRadius.all(Radius.circular(16.0)),
									),
									hintText: 'phone',
									suffixIcon: IconButton(
										onPressed: viber_controller.clear,
										icon: Icon(
											Icons.clear,
										),
									),
								),
							),
						),
					),
				),
			],
		);
		Widget form_bio = Form(
			key: _form_key_bio,
			child: Column(
			  children: [
			    Padding(
			    	padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
			    	child: TextFormField(
							maxLines: 5,
							keyboardType: TextInputType.phone,
							controller: bio_controller,
			    		decoration: InputDecoration(
			    			border: OutlineInputBorder(
			    				borderRadius : BorderRadius.all(Radius.circular(16.0)),
			    			),
			    			hintText: 'Напишіть про себе',
			    			suffixIcon: IconButton(
			    				onPressed: bio_controller.clear,
			    				icon: Icon(
			    					Icons.clear,
			    				),
			    			),
			    		),
			    	),
			    ),
			  ],
			),
		);
		Widget form_email = Form(
			key: _form_key_email,
			child: Padding(
				padding: const EdgeInsets.fromLTRB(16, 13, 16, 0),
				child: TextFormField(
					keyboardType: TextInputType.emailAddress,
					controller: email_controller,
					autovalidateMode: AutovalidateMode.onUserInteraction,
					validator: (value) {
						if (value == null || value.isEmpty) {
							return 'Email не може бути пустим';
						}
						String validate_msg = email_validator(value);
						if (validate_msg.isEmpty){
							return null;
						}
						return validate_msg;
					},
					onChanged: (text) {
						setState(() {
							if (_form_key_email.currentState!.validate())
									button_states[email_index] = true;
							else
									button_states[email_index] = false;
						});
					},
					decoration: InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
						hintText: 'Email',
						suffixIcon: IconButton(
							onPressed: () {
								email_controller.clear;
								button_states[email_index] = false;
							},
							icon: Icon(
								Icons.clear,
							),
						),
					),
				),
			),
		);

		return MaterialApp(
			debugShowCheckedModeBanner: false,
		  home: Scaffold(
				appBar: buildAppBar(() {
					Navigator.pop(context);
				},
					'Редагувати',
					TextButton(
						onPressed: button_states.every((element) => element) ? () async {
							var r = Requests();
							print(name_controller.text);
							print(email_controller.text);
							var result = await r.post(
									'$server_url$register_url',
									{
										'username': name_controller.text,
										'email': email_controller.text,
									}
							);
							if (result['status_code'] == 201){
								print('success register');
								app_service.set_username(email_controller.text);
								app_service.email = email_controller.text;
								// bool result = await app_service.login();
								app_service.is_register = true;
								context.go(APP_PAGE.register_confirmation.to_path);
							}
							// post_request();
						} : null,
						child: Text(
							'Зберегти',
							style: TextStyle(
								// color: Color(0xFF0071D8),
								fontSize: 18,
								fontFamily: 'SF Pro Text',
								fontWeight: FontWeight.w400,
							),
						),
					),
				),
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
		  	  		  			padding: EdgeInsets.fromLTRB(64, 10, 64, 0),
		  	  		  			child: KeyboardVisibilityBuilder(
													builder: (context, isKeyboardVisible) {
														var image;
														print("app_service.current_profile");
														print(app_service.current_profile);
														print(app_service.user.toString());
														print(app_service.role);
														print(app_service.volunteer);
														print(app_service.organizer);
														print(app_service.refugee);
														if (app_service.current_profile != null &&
																app_service.current_profile?.image != null &&
																app_service.current_profile?.image != ''
														) {
															print(app_service.current_profile);
															image = Image.network(
																app_service.current_profile?.image ?? '',
																height:	isKeyboardVisible ? 78.0 : 184.0,
															);
														} else {
															image = Image.asset(
																	'images/img_22.png',
																	height:	isKeyboardVisible ? 78.0 : 184.0,
															);
														}

														return image;
														// 	Image.asset(
														// 	'images/img.png',
														// 	height:	isKeyboardVisible ? 78.0 : 184.0,
														// );
													}
											),
		  	  		  		),
										Padding(
											padding: const EdgeInsets.fromLTRB(73, 15, 73, 0),
											child: Text(
												'Змінити фото акаунта',
												style: TextStyle(
														color: Color(0xFF0071D8),
														fontSize: 18,
														fontWeight: FontWeight.w500
												),
												textAlign: TextAlign.center,
											),
										),
										const build_settings_header(
											text: 'Ім’я',
											up_padding: 22,
										),
										form_name,
										const build_settings_header(
											text: 'Біо',
											up_padding: 22,
										),
										form_bio,

										const build_settings_header(
											text: 'Контакти',
											up_padding: 22,
										),
										form_phone,
										form_telegram,
										form_viber,
										const build_settings_header(
											text: 'Email',
											up_padding: 22,
										),
										form_email,

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
