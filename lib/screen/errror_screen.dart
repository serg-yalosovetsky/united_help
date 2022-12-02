import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:united_help/fragment/welcome_button.dart';
import 'package:united_help/routes/routes.dart';

class ErrorPage extends StatefulWidget {
  final String? error_message;
  const ErrorPage({this.error_message});

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage>{

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/img_14.png', width: 150,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 33),
              child: Text(widget.error_message ??
                  '''Упс..Сталась помилка. Перезавантажте, будь ласка''',
              style: TextStyle(fontSize: 21, color: Color(0xff547FA6)),),
            ),
            welcome_button(
                text: 'Перезавантажити',
                padding: [84, 16, 84, 0],
                active: true,
                fun: () {context.go(APP_PAGE.home_list.to_path);},

            ),
          ],
        ),
      ),
    );
  }
}