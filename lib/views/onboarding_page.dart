import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_utils.dart';
import '../services/appservice.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appService = Provider.of<AppService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_PAGE.onBoarding.toTitle),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            appService.onboarding = true;
          },
          child: const Text(
              "Done"
          ),
        ),
      ),
    );
  }
}