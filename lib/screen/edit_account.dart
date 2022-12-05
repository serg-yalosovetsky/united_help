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
			child: Column(
				children: <Widget>[
					Padding(
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
				],
			),
		);
		Widget form_email = Form(
			key: _form_key_email,
			child: Column(
				children: <Widget>[
					Padding(
						padding: const EdgeInsets.fromLTRB(31, 13, 31, 0),
						child: TextFormField(
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
				],
			),
		);
		Widget form_password = Form(
			key: _form_key_password,
			child: Column(
				children: <Widget>[
					Padding(
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



				],
			),
		);

		return MaterialApp(
			debugShowCheckedModeBanner: false,
		  home: Scaffold(
				appBar: buildAppBar(() {
					Navigator.pop(context);
				}, 'Редагувати'),
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
										form_name,
										form_email,
										form_password,
										welcome_button(
											text_style: SFProTextSemibold18,
											text: 'Зареєструватись',
											padding: const [72, 47, 72, 0],
											fun: button_states.every((element) => element) ? () async {
												var r = Requests();
												print(name_controller.text);
												print(email_controller.text);
												print(password_controller.text);
												var result = await r.post(
														'$server_url$register_url',
														{
															'username': name_controller.text,
															'email': email_controller.text,
															'password': password_controller.text,
														}
												);
												if (result['status_code'] == 201){
													print('success register');
													app_service.set_username(email_controller.text);
													app_service.set_password(password_controller.text);
													app_service.email = email_controller.text;
													app_service.password = password_controller.text;
													// bool result = await app_service.login();
													app_service.is_register = true;
													context.go(APP_PAGE.register_confirmation.to_path);
												}
												// post_request();
											} : null,
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
