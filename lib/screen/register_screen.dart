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
import '../services/debug_print.dart';

class RegisterScreen extends StatefulWidget {
	const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

	final _form_key_name = GlobalKey<FormState>();
	final _form_key_email = GlobalKey<FormState>();
	final _form_key_password = GlobalKey<FormState>();
	List<bool> button_states = [false, false, false];
	final int name_index = 0;
	final int email_index = 1;
	final int password_index = 2;
	final name_controller = TextEditingController();
	final email_controller = TextEditingController();
	final password_controller = TextEditingController();
	late bool _password_visible;
	late AppService app_service;
	@override
	void dispose() {
		// Clean up the controller when the widget is disposed.
		name_controller.dispose();
		email_controller.dispose();
		password_controller.dispose();
		super.dispose();
	}

	void initState() {
		_password_visible = false;
		app_service = Provider.of<AppService>(context, listen: false);
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
		const TextStyle back_style = TextStyle(color: Colors.blue, fontSize: 17);
		Widget form_name = Form(
			key: _form_key_name,
			child: Padding(
				padding: const EdgeInsets.fromLTRB(31, 13, 31, 0),
				child: TextFormField(
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
						dPrint(button_states);
					},
					decoration: InputDecoration(
						border: OutlineInputBorder(
							borderRadius : BorderRadius.all(Radius.circular(16.0)),
						),
						hintText: 'Прізвище, ім’я',
						suffixIcon: IconButton(
							onPressed: name_controller.clear,
							icon: Icon(
									Icons.clear,
							),
						),
					),
				),
			),
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
						dPrint(button_states);

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
								// Based on passwordVisible state choose the icon
								_password_visible
										? Icons.visibility
										: Icons.visibility_off,
								// color: Theme.of(context).primaryColorDark,
							),
						),
					),
				),
			),
		);
		Widget body = Column(
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
				form_name,
				form_email,
				form_password,
				welcome_button(
					text_style: SFProTextSemibold18,
					text: 'Зареєструватись',
					padding: const [0, 47, 0, 0],
					active: button_states.every((element) => element),
					fun: button_states.every((element) => element) ? () async {
						var r = Requests();
						dPrint(name_controller.text);
						dPrint(email_controller.text);
						dPrint(password_controller.text);
						var result = await r.post(
								'${app_service.server_url}$register_url/',
								{
									'username': name_controller.text,
									'email': email_controller.text,
									'password': password_controller.text,
								}
						);
						if (result['status_code'] == 201){
							dPrint('success register');
							app_service.set_username(email_controller.text);
							app_service.set_password(password_controller.text);
							app_service.username = name_controller.text;
							app_service.password = password_controller.text;
							// bool result = await app_service.login();
							app_service.is_register = true;
							app_service.current_location = APP_PAGE.register_confirmation.to_path;
							context.go(APP_PAGE.register_confirmation.to_path);
						}

						if (result['status_code'] == 400){
							dPrint('password too weak');

							//TODO handle weak password
							app_service.set_username(email_controller.text);
							app_service.set_password(password_controller.text);
							app_service.username = name_controller.text;
							app_service.password = password_controller.text;
							// bool result = await app_service.login();
							app_service.is_register = true;
							app_service.current_location = APP_PAGE.register_confirmation.to_path;
							context.go(APP_PAGE.register_confirmation.to_path);
						}
						// post_request();
					} : null,
				),
			],
		);
		return MaterialApp(
			debugShowCheckedModeBanner: false,
		  home: Scaffold(
				appBar: buildAppBar(() {
					app_service.is_try_register = false;
					app_service.current_location = APP_PAGE.register_login.to_path;
					context.go(APP_PAGE.register_login.to_path);
				}, 'Реєстрація'),
		  	backgroundColor: ColorConstant.whiteA700,
		  	body: SafeArea(
		  	  child: SingleChildScrollView(
		  	  	child: Center(
		  	  	  child: body,
		  	  	),
		  	  ),
		  	),
		  ),
		);
	}

}

