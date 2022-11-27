import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:united_help/screen/home.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/map.dart';
import 'package:united_help/screen/password_recovery.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// void main() => runApp( UnitedHelp());




Future<void> main() async {
  await SentryFlutter.init(
        (options) {
      options.dsn = 'http://7ec014d5153a4ffb9f41355c01378289@sentry.fyuzd.live/8';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(UnitedHelp()),
  );

}


class UnitedHelp extends StatelessWidget {
  const UnitedHelp({super.key});

  static const String _title = 'Flutter Code Sample';


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // title: _title,
      // home: const HomeScreen(),
      // theme: ThemeData(fontFamily: 'SF Pro'),
      routerConfig: go_router,
    );
  }
}
