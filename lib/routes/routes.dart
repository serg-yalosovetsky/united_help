import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:united_help/screen/login_screen.dart';
import 'package:united_help/screen/register.dart';
import 'package:united_help/screen/splash_screen.dart';
import 'package:united_help/screen/welcome_role.dart';

import '../constants.dart';
import '../screen/account_screen.dart';
import '../fragment/events_list.dart';
import '../screen/errror_screen.dart';
import '../screen/home.dart';
import '../screen/map.dart';
import '../services/appservice.dart';
import '../services/login_state.dart';


enum APP_PAGE {
  welcome,
  register,
  splash,
  login,
  home,
  error,
  account,
}

extension AppPageExtension on APP_PAGE {
  String get to_path {
    switch (this) {
      case APP_PAGE.home:
        return "/";
      case APP_PAGE.account:
        return "/account";
      case APP_PAGE.login:
        return "/login";
      case APP_PAGE.splash:
        return "/splash";
      case APP_PAGE.welcome:
        return "/welcome";
      case APP_PAGE.register:
        return "/register";
      case APP_PAGE.error:
        return "/error";
      default:
        return "/";
    }
  }
  String get to_name {
    switch (this) {
      case APP_PAGE.home:
        return "HOME";
      case APP_PAGE.login:
        return "LOGIN";
      case APP_PAGE.register:
        return "REGISTER";
      case APP_PAGE.account:
        return "ACCOUNT";
      case APP_PAGE.splash:
        return "SPLASH";
      case APP_PAGE.error:
        return "ERROR";
      case APP_PAGE.welcome:
        return "WELCOME";

      default:
        return "HOME";
    }
  }
}

class AppRouter {
  late final AppService app_service;
  GoRouter get router => _go_router;

  AppRouter(this.app_service);


  late final GoRouter _go_router = GoRouter(
    refreshListenable: app_service,
    initialLocation: APP_PAGE.home.to_path,
    routes: <GoRoute>[
      GoRoute(
        path: APP_PAGE.home.to_path,
        name: APP_PAGE.home.to_name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: APP_PAGE.login.to_path,
        name: APP_PAGE.login.to_name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: APP_PAGE.welcome.to_path,
        name: APP_PAGE.welcome.to_name,
        builder: (context, state) => WelcomeRoleScreen(),
      ),
      GoRoute(
        path: APP_PAGE.account.to_path,
        name: APP_PAGE.account.to_name,
        builder: (context, state) => const AccountScreen(),
      ),
      GoRoute(
        path: APP_PAGE.register.to_path,
        name: APP_PAGE.register.to_name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: APP_PAGE.splash.to_path,
        name: APP_PAGE.splash.to_name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: "/map",
        builder: (context, state) => const GoogleMapScreen(),
      ),
      GoRoute(
        path: "/example",
        builder: (context, state) => EventListScreen(event_query: '',),
      ),
      GoRoute(
        path: APP_PAGE.error.to_path,
        name: APP_PAGE.error.to_name,
        builder: (context, state) => ErrorPage(error_message: state.extra.toString()),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error_message: state.error.toString()),
    redirect: (state) {
      final login_location = APP_PAGE.login.to_path;
      final home_location = APP_PAGE.home.to_path;
      final splash_location = APP_PAGE.splash.to_path;
      final welcome_location = APP_PAGE.welcome.to_path;

      final is_login = app_service.loginState;
      var is_init = app_service.initialized;
      final is_onboarded = app_service.onboarding;

      final is_going_to_login = state.subloc == login_location;
      final is_going_to_init = state.subloc == splash_location;
      final is_going_to_onboard = state.subloc == welcome_location;
      print('state.subloc == splash_location ${state.subloc == splash_location}');
      print('!is_init && !is_going_to_init ${!is_init && !is_going_to_init}');
      print('is_init && !is_onboarded ${is_init && !is_onboarded}');
      print('!is_onboarded ${ !is_onboarded}');
      print('is_init  ${is_init }');
      print('app_service.initialized  ${app_service.initialized }');
      // If not Initialized and not going to Initialized redirect to Splash
      if (!is_init && !is_going_to_init) {
        return splash_location;
        // If not onboard and not going to onboard redirect to OnBoarding
      } else  if (is_init && !is_onboarded ) {  //&& !is_going_to_onboard
        return APP_PAGE.welcome.to_path;
        // If not logedin and not going to login redirect to Login
      } else if (is_init && is_onboarded && !is_login && !is_going_to_login) {
        return login_location;
        // If all the scenarios are cleared but still going to any of that screen redirect to Home
      } else if (
             (is_login && is_going_to_login) || (app_service.initialized && is_going_to_init) ||
             (is_onboarded && is_going_to_onboard)
                ) {
        return home_location;
      } else {
        // Else Don't do anything
        return null;
      }
    },
  );


}


