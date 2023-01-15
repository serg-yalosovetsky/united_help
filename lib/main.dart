import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:united_help/fragment/switch_app_bar.dart';
import 'package:united_help/routes/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:united_help/services/appservice.dart';
import 'package:united_help/services/auth_service.dart';

import 'models/notify.dart';

// void main() => runApp( UnitedHelp());




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences shared_preferences = await SharedPreferences.getInstance();
  final FlutterSecureStorage secure_storage = FlutterSecureStorage();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(HivePushNotificationAdapter());

  await SentryFlutter.init(
        (options) {
          options.dsn = 'http://7ec014d5153a4ffb9f41355c01378289@sentry.fyuzd.live/8';
          // options.dsn = 'https://0b96c4fdf54841df9be550172c90f745@o4504272346480640.ingest.sentry.io/4504272372760576';
          options.tracesSampleRate = 1.0;

    },
    appRunner: () => runApp(UnitedHelp(
      shared_preferences: shared_preferences,
      secure_storage: secure_storage,
    )),
  );

}


class UnitedHelp extends StatefulWidget {
  final SharedPreferences shared_preferences;
  final FlutterSecureStorage secure_storage;
  const UnitedHelp({
    Key? super.key,
    required this.shared_preferences,
    required this.secure_storage,
  });


  @override
  State<UnitedHelp> createState() => _UnitedHelpState();
}

class _UnitedHelpState extends State<UnitedHelp> {
  late AppService app_service;
  late AuthService auth_service;
  late StreamSubscription<bool> auth_subscription;
  @override
  void initState() {
    app_service = AppService(
      widget.secure_storage,
      widget.shared_preferences,
    );
    auth_service = AuthService();
    auth_subscription = auth_service.onAuthStateChange.listen(on_auth_state_change);
    super.initState();
  }
  void on_auth_state_change(bool login) {
    app_service.loginState = login;
  }

  @override
  void dispose() {
    auth_subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppService>(create: (_) => app_service),
        Provider<AppRouter>(create: (_) => AppRouter(app_service)),
        Provider<AuthService>(create: (_) => auth_service)
      ],
      child: Builder(
        builder: (context) {
          final GoRouter goRouter = Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: "Router App",
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
          );
        },
      ),
    );
  }
}

