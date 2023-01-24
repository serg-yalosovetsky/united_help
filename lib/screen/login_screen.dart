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
import '../fragment/welcome_button.dart';
import '../routes/routes.dart';
import '../providers/appservice.dart';
import '../services/authenticate.dart';

class LoginScreen extends StatefulWidget {
	const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
	final _form_key_email = GlobalKey<FormState>();
	final _form_key_password = GlobalKey<FormState>();
	List<bool> button_states = [false, false];
	final int email_index = 0;
	final int password_index = 1;
	final email_controller = TextEditingController();
	final password_controller = TextEditingController();
	late bool _password_visible;
	late AppService app_service;
	bool is_wrong_password = false;

	@override
	void dispose() {
		// Clean up the controller when the widget is disposed.
		email_controller.dispose();
		password_controller.dispose();
		super.dispose();
	}

	void initState() {
		_password_visible = false;
		app_service = Provider.of<AppService>(context, listen: false);
		if (app_service.is_register) {
			if (app_service.email.isNotEmpty) {
				email_controller.text = app_service.email;
				app_service.email = '';
			}
			if (app_service.password.isNotEmpty) {
				password_controller.text = app_service.password;
				app_service.password = '';
			}
		}
	}

	on_submit ([var args]) async {
		// Requests.password = password_controller.text;
		// Requests.username = email_controller.text;
		var r = Requests();
		print(email_controller.text);
		print(password_controller.text);
		app_service.set_username(email_controller.text);
		app_service.set_password(password_controller.text);
		bool result = await app_service.login();
		if (result){
			setState(() {
				is_wrong_password = true;
			});
		}
		print('result = $result');
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
		Widget form_email = Form(
			key: _form_key_email,
			child: Padding(
				padding: const EdgeInsets.fromLTRB(31, 13, 31, 0),
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
							onPressed: email_controller.clear,
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
										form_email,
										form_password,
										welcome_button(
											text_style: SFProTextSemibold18,
											text: 'Увійти в акаунт',
											padding: const [72, 24, 72, 0],
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
												if (email_controller.text.isNotEmpty &&
														_form_key_email.currentState!.validate()) {
												 	 app_service.email = email_controller.text;
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

