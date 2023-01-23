import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:united_help/routes/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:united_help/providers/appservice.dart';
import 'package:united_help/providers/auth_service.dart';
import 'package:united_help/providers/filters.dart';
import 'package:united_help/services/notifications.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences shared_preferences = await SharedPreferences.getInstance();
  final FlutterSecureStorage secure_storage = FlutterSecureStorage();
  registerHive();
  await Firebase.initializeApp();

  registerNotification();
  checkForInitialMessage();
  openNotificationsMessageAsync();
  notificationsMessageAsync();
  await SentryFlutter.init(
        (options) {
          options.dsn = 'https://051d9e8c471f47a7a3a0b04e9469aae1@sentry.fyuzd.live/5';
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
  late Filters filters;
  late AuthService auth_service;
  late StreamSubscription<bool> auth_subscription;
  @override
  void initState() {
    app_service = AppService(
      widget.secure_storage,
      widget.shared_preferences,
    );
    filters = Filters(
      widget.shared_preferences,
    );
    filters.restore_filters(if_empty: true);
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
        ChangeNotifierProvider<Filters>(create: (_) => filters),
        Provider<AppRouter>(create: (_) => AppRouter(app_service, filters)),
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

