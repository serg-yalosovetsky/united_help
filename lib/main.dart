import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_help/screen/home.dart';
import 'package:united_help/routes/routes.dart';
import 'package:united_help/screen/map.dart';
import 'package:united_help/screen/password_recovery.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:united_help/services/appservice.dart';
// void main() => runApp( UnitedHelp());




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final SharedPreferences shared_preferences = await SharedPreferences.getInstance();
  final FlutterSecureStorage secure_storage = FlutterSecureStorage();

  await SentryFlutter.init(
        (options) {
      options.dsn = 'http://7ec014d5153a4ffb9f41355c01378289@sentry.fyuzd.live/8';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(UnitedHelp(
      // shared_preferences: shared_preferences,
      secure_storage: secure_storage,
    )),
  );

}


class UnitedHelp extends StatefulWidget {
  // final SharedPreferences shared_preferences;
  final FlutterSecureStorage secure_storage;
  const UnitedHelp({
    Key? super.key,
    // required this.shared_preferences,
    required this.secure_storage,
  });

  static const String _title = 'Flutter Code Sample';

  @override
  State<UnitedHelp> createState() => _UnitedHelpState();
}

class _UnitedHelpState extends State<UnitedHelp> {
  late AppService app_service;

  @override
  void initState() {
    app_service = AppService(widget.secure_storage);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => app_service),
        Provider<AppRouter>(create: (_) => AppRouter(app_service)),
      ],
      child: Builder(
        builder: (context) {
          final GoRouter goRouter = Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            title: "Router App",
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
          );
        },
      ),
    );
  }
}
