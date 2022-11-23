import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:united_help/services/validators.dart';
import 'package:united_help/services/urls.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../services/authenticate.dart';

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

	final name_controller = TextEditingController();
	final email_controller = TextEditingController();
	final password_controller = TextEditingController();
	late bool _password_visible;

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
										button_states[0] = true;
									else
										button_states[0] = false;
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
											button_states[1] = true;
									else
											button_states[1] = false;
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
											button_states[2] = true;
									else
											button_states[2] = false;
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
		  home: Scaffold(
				appBar: AppBar(
					title: Row(
					  children: [
							Icon(Icons.arrow_back_ios),
							const Text(
								'Назад',
								style: back_style,
							),
							Expanded(
							  child: Padding(
							  	padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
							  	child: const Text(
							  		'Register',
										style: TextStyle(color: Colors.black),
										textAlign: TextAlign.center,
							  	),
							  ),
							),

							Icon(Icons.arrow_back_ios, color: Colors.white),
							const Text(
								'Назад',
								style: TextStyle(color: Colors.white),
							),

					  ],
					),
					backgroundColor: Colors.white,
					foregroundColor: Colors.blue,
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
		  	  		  			child: Image.asset(
		  	  		  				// ImageConstant.imgGroup26649,
									'images/img.png',
									// 'images/Best-TED-Talks-From-The-Curator-Himself-.jpg',
		  	  		  				height: 184.00,
		  	  		  				// width: 247.00,
		  	  		  			),
		  	  		  		),
										form_name,
										form_email,
										form_password,
										welcome_button(
											text_style: SFProTextSemibold18,
											text: 'Зареєструватись',
											padding: const [72, 47, 72, 0],
											fun: button_states.every((element) => element) ? () {
												Requests.password = 'sergey104781';
												Requests.username = 'serg';
												var r = Requests();
												print(name_controller.text);
												print(email_controller.text);
												print(password_controller.text);
												r.post(
														'$server_url$register_url',
														{
															'username': name_controller.text,
															'email': email_controller.text,
															'password': password_controller.text,
														}
												);
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
