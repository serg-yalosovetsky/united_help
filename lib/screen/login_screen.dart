import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:united_help/services/validators.dart';
import 'package:united_help/services/urls.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../fragment/build_app_bar.dart';
import '../fragment/switch_app_bar.dart';
import '../fragment/welcome_button.dart';
import '../routes/routes.dart';
import '../providers/appservice.dart';
import '../services/authenticate.dart';
import '../services/debug_print.dart';

class LoginScreen extends StatefulWidget {
	const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	final _form_key_username = GlobalKey<FormState>();
	final _form_key_password = GlobalKey<FormState>();
	List<bool> button_states = [false, false];
	final int email_index = 0;
	final int password_index = 1;
	final username_controller = TextEditingController();
	final password_controller = TextEditingController();
	late bool _password_visible;
	late AppService app_service;
	bool is_wrong_password = false;

	@override
	void dispose() {
		// Clean up the controller when the widget is disposed.
		username_controller.dispose();
		password_controller.dispose();
		super.dispose();
	}

	void initState() {
		_password_visible = false;
		app_service = Provider.of<AppService>(context, listen: false);
		if (app_service.is_register) {
			if (app_service.username.isNotEmpty) {
				username_controller.text = app_service.username;
				app_service.username = '';
				button_states[email_index] = true;
			}
			if (app_service.password.isNotEmpty) {
				password_controller.text = app_service.password;
				app_service.password = '';
				button_states[password_index] = true;
			}
		}
	}

	on_submit ([var args]) async {
		dPrint(username_controller.text);
		dPrint(password_controller.text);
		app_service.set_username(username_controller.text);
		app_service.set_password(password_controller.text);
		bool result = await app_service.login();
		setState(() {
			is_wrong_password = !result;
			if (result){
				if(app_service.role == Roles.organizer)
					if(app_service.actual_or_history == SwitchEnum.first) {
						app_service.current_location = APP_PAGE.my_events.to_path;
						context.go(APP_PAGE.my_events.to_path);
					} else {
						app_service.current_location = APP_PAGE.my_events_history.to_path;
						context.go(APP_PAGE.my_events_history.to_path);
					}
				else {
					app_service.current_location = APP_PAGE.home_list.to_path;
					context.go(APP_PAGE.home_list.to_path);
				}
			}
		});
		dPrint('result = $result');
		// _form_key_password.currentState.
	}

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
		Widget form_username = Form(
			key: _form_key_username,
			child: Padding(
				padding: const EdgeInsets.fromLTRB(31, 13, 31, 0),
				child: TextFormField(
					keyboardType: TextInputType.text,
					controller: username_controller,
					autovalidateMode: AutovalidateMode.onUserInteraction,
					validator: (value) {
						if (value == null || value.isEmpty) {
							return 'username не може бути пустим';
						}
						else return null;
					},
					onChanged: (text) {
						setState(() {
							if (_form_key_username.currentState!.validate())
									button_states[email_index] = true;
							else
									button_states[email_index] = false;
						});
						dPrint(button_states);
					},
					decoration: InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
						hintText: 'username',
						suffixIcon: IconButton(
							onPressed: username_controller.clear,
							icon: Icon(
								Icons.clear,
							),
						),
					),
				),
			),
		);
		Widget form_password = Form(
			key: _form_key_password,
			child: Padding(
				padding: const EdgeInsets.fromLTRB(31, 13, 31, 0),
				child: TextFormField(
					keyboardType: TextInputType.text,
					controller: password_controller,
					obscureText: !_password_visible,
					autovalidateMode: AutovalidateMode.onUserInteraction,
					onSaved: on_submit,
					validator: (value) {
						if (value == null || value.isEmpty) {
							return 'Пароль не може бути пустим';
						}
						String validate_msg = password_validator(value);
						if (validate_msg.isEmpty){
							return null;
						}
						return validate_msg;
					},
					onChanged: (text) {
						setState(() {
							if (_form_key_password.currentState!.validate())
									button_states[password_index] = true;
							else
									button_states[password_index] = false;
						});
						dPrint(button_states);
					},
					decoration: InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
						hintText: 'Пароль',
						suffixIcon: IconButton(
							onPressed: () {
								setState(() {
									_password_visible = !_password_visible;
								});
							},
							icon: Icon(
								_password_visible
										? Icons.visibility
										: Icons.visibility_off,
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
					app_service.is_try_login = false;
					app_service.current_location = APP_PAGE.register_login.to_path;
					context.go(APP_PAGE.register_login.to_path);
				}, 'Вхід'),
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
														return Image.asset(
															'images/img.png',
															height:	isKeyboardVisible ? 78.0 : 184.0,
														);
														}
													),
		  	  		  		),
										// form_name,
										form_username,
										form_password,
										welcome_button(
											text_style: SFProTextSemibold18,
											text: 'Увійти в акаунт',
											padding: const [0, 24, 0, 0],
											active: button_states.every((element) => element),
											fun: button_states.every((element) => element) ? on_submit : null,
										),
										TextButton(
											style: TextButton.styleFrom(
												// foregroundColor: Colors.black,
												padding: const EdgeInsets.fromLTRB(13.0, 22.0, 13.0, 13.0),
												textStyle: const TextStyle(fontSize: 17),
											),
											onPressed: () {
												// app_service.is_try_login = false;
												if (username_controller.text.isNotEmpty &&
														_form_key_username.currentState!.validate()) {
												 	 // app_service.username = username_controller.text;
												}
												app_service.current_location = APP_PAGE.password_recovery.to_path;
												context.go(APP_PAGE.password_recovery.to_path);
												},
											child: const Text('Забули пароль?'),
										),
										is_wrong_password ? Text(
											'Неверный пароль',
											style: TextStyle(color: Colors.red),
										) : Container(),
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

