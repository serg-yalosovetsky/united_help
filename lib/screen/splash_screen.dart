import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/routes.dart';
import '../providers/appservice.dart';
import '../services/debug_print.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppService _app_service;

  @override
  void initState() {
    _app_service = Provider.of<AppService>(context, listen: false);
    onStartUp();
    super.initState();
  }

  void onStartUp() async {
    dPrint('before onStartUp');
    await _app_service.onAppStart();
    dPrint('_app_service.initialized ${_app_service.initialized}');
    dPrint('_app_service.onboard ${_app_service.onboarding}');
    _app_service.initialized = true;
    context.go(APP_PAGE.welcome.to_path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/img_15.png', width: 108, height: 67,),
            Text('UnitedHelp',
            style: TextStyle(fontSize: 22, ),),
          ],
        ),
      ),
    );
  }
}
