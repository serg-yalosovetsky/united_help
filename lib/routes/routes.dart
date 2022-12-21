import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:united_help/screen/filter_screen.dart';
import 'package:united_help/screen/home_list.dart';
import 'package:united_help/screen/login_screen.dart';
import 'package:united_help/screen/new_event_screen.dart';
import 'package:united_help/screen/password_recovery.dart';
import 'package:united_help/screen/splash_screen.dart';
import 'package:united_help/screen/welcome_register_or_login.dart';
import 'package:united_help/screen/welcome_role.dart';

import '../constants.dart';
import '../screen/account_screen.dart';
import '../fragment/events_list.dart';
import '../screen/edit_account.dart';
import '../screen/email_password_confirmation.dart';
import '../screen/errror_screen.dart';
import '../fragment/switch_app_bar.dart';
import '../screen/home_map.dart';
import '../screen/my_events_organizer.dart';
import '../screen/new_event_choose_help_or_job.dart';
import '../screen/register_email_confirmation.dart';
import '../screen/register_screen.dart';
import '../screen/settings_screen.dart';
import '../screen/verification_main.dart';
import '../services/appservice.dart';
import '../services/login_state.dart';


enum APP_PAGE {
  welcome,
  register,
  splash,
  register_login,
  register_confirmation,
  password_confirmation,
  login,
  verification,
  password_recovery,
  home_list,
  home_map,
  new_events,
  new_events_choose_help_or_job,
  my_events,
  filters,
  error,
  account,
  edit_account,
  settings,
}

extension AppPageExtension on APP_PAGE {
  String get to_path {
    switch (this) {
      case APP_PAGE.home_list:
        return "/";
      case APP_PAGE.new_events:
        return "/new_events";
      case APP_PAGE.new_events_choose_help_or_job:
        return "/new_events_choose_help_or_job";
      case APP_PAGE.my_events:
        return "/my_events";
      case APP_PAGE.home_map:
        return "/map";
      case APP_PAGE.account:
        return "/account";
      case APP_PAGE.edit_account:
        return "/edit_account";
      case APP_PAGE.settings:
        return "/settings";
      case APP_PAGE.verification:
        return "/verification";
      case APP_PAGE.login:
        return "/login";
      case APP_PAGE.password_recovery:
        return '/password_recovery';
      case APP_PAGE.register_login:
        return "/register_login";
      case APP_PAGE.register_confirmation:
        return "/register_confirmation";
      case APP_PAGE.password_confirmation:
        return "/password_confirmation";
      case APP_PAGE.splash:
        return "/splash";
      case APP_PAGE.welcome:
        return "/welcome";
      case APP_PAGE.register:
        return "/register";
      case APP_PAGE.filters:
        return "/filters";
      case APP_PAGE.error:
        return "/error";
      default:
        return "/";
    }
  }
  String get to_name {
    switch (this) {
      case APP_PAGE.home_list:
        return "HOME_LIST";
      case APP_PAGE.home_map:
        return "HOME_MAP";
      case APP_PAGE.new_events:
        return "NEW_EVENTS";
      case APP_PAGE.my_events:
        return "MY_EVENTS";
      case APP_PAGE.new_events_choose_help_or_job:
        return "NEW_EVENTS_CHOOSE_HELP_OR_JOB";
      case APP_PAGE.register_login:
        return "REGISTER_LOGIN";
      case APP_PAGE.login:
        return "LOGIN";
      case APP_PAGE.verification:
        return "VERIFICATION";
      case APP_PAGE.password_recovery:
        return 'PASSWORD_RECOVERY';
      case APP_PAGE.register:
        return "REGISTER";
      case APP_PAGE.filters:
        return "FILTERS";
      case APP_PAGE.register_confirmation:
        return "REGISTER_CONFIRMATION";
      case APP_PAGE.password_confirmation:
        return "PASSWORD_CONFIRMATION";
      case APP_PAGE.account:
        return "ACCOUNT";
      case APP_PAGE.edit_account:
        return "EDIT_ACCOUNT";
      case APP_PAGE.settings:
        return "SETTINGS";
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
    initialLocation: app_service.role==Roles.organizer ?
                        APP_PAGE.new_events_choose_help_or_job.to_path :
                        APP_PAGE.home_list.to_path,
    routes: <GoRoute>[
      GoRoute(
        path: APP_PAGE.home_list.to_path,
        name: APP_PAGE.home_list.to_name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: APP_PAGE.home_map.to_path,
        name: APP_PAGE.home_map.to_name,
        builder: (context, state) => const GoogleMapScreen(),
      ),
      GoRoute(
        path: '${APP_PAGE.new_events.to_path}/:event_for',
        name: APP_PAGE.new_events.to_name,
        builder: (context, state) => NewEventScreen(event_for: state.params['event_for'] ?? ''),
      ),
      GoRoute(
        path: APP_PAGE.my_events.to_path,
        name: APP_PAGE.new_events.to_name,
        builder: (context, state) => MyEventsScreen(),
      ),
      GoRoute(
        path: APP_PAGE.new_events_choose_help_or_job.to_path,
        name: APP_PAGE.new_events_choose_help_or_job.to_name,
        builder: (context, state) => NewEventChooseHelpOrJobScreen(),
      ),
      GoRoute(
        path: APP_PAGE.filters.to_path,
        name: APP_PAGE.filters.to_name,
        builder: (context, state) => const FiltersCard(),
      ),
      GoRoute(
        path: APP_PAGE.login.to_path,
        name: APP_PAGE.login.to_name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: APP_PAGE.verification.to_path,
        name: APP_PAGE.verification.to_name,
        builder: (context, state) => VerificationScreen(),
      ),
      GoRoute(
        path: APP_PAGE.password_recovery.to_path,
        name: APP_PAGE.password_recovery.to_name,
        builder: (context, state) => const PasswordRecoveryScreen(),
      ),
      GoRoute(
        path: APP_PAGE.register_login.to_path,
        name: APP_PAGE.register_login.to_name,
        builder: (context, state) => WelcomeRegisterOrLoginScreen(),
      ),
      GoRoute(
        path: APP_PAGE.account.to_path,
        name: APP_PAGE.account.to_name,
        builder: (context, state) => AccountScreen(),
      ),
      GoRoute(
        path: APP_PAGE.edit_account.to_path,
        name: APP_PAGE.edit_account.to_name,
        builder: (context, state) => EditAccountScreen(),
      ),
      GoRoute(
        path: APP_PAGE.settings.to_path,
        name: APP_PAGE.settings.to_name,
        builder: (context, state) => build_settings_screen(),
      ),
      GoRoute(
        path: APP_PAGE.register_confirmation.to_path,
        name: APP_PAGE.register_confirmation.to_name,
        builder: (context, state) => RegisterEmailConfirmationScreen(),
      ),
      GoRoute(
        path: APP_PAGE.password_confirmation.to_path,
        name: APP_PAGE.password_confirmation.to_name,
        builder: (context, state) => EmailPasswordConfirmationScreen(),
      ),
      GoRoute(
        path: APP_PAGE.welcome.to_path,
        name: APP_PAGE.welcome.to_name,
        builder: (context, state) => WelcomeRoleScreen(),
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

      bool is_test = true;

      final login_location = APP_PAGE.login.to_path;
      final register_login_location = APP_PAGE.register_login.to_path;
      final home_location = APP_PAGE.home_list.to_path;
      final splash_location = APP_PAGE.splash.to_path;
      final welcome_location = APP_PAGE.welcome.to_path;
      final verification_location = APP_PAGE.verification.to_path;

      final is_login = app_service.loginState;
      final is_init = app_service.initialized;
      final is_onboarded = app_service.onboarding;
      final is_try_login = app_service.is_try_login;
      final is_try_register = app_service.is_try_register;
      final is_verificated = app_service.is_verificated;

      final is_going_to_login = state.subloc == login_location;
      final is_going_to_register_login = state.subloc == register_login_location;
      final is_going_to_init = state.subloc == splash_location;
      final is_going_to_onboard = state.subloc == welcome_location;
      final is_going_to_verfication = state.subloc == verification_location;
      final is_going_to_home = state.subloc == home_location;

      //
      // if (is_test && !is_going_to_home) return home_location;
      //
      //
      // // If not Initialized and not going to Initialized redirect to Splash
      // if (!is_init && !is_going_to_init) {
      //     return splash_location;
      //   // If not onboard and not going to onboard redirect to OnBoarding
      // } else  if (is_init && !is_onboarded && !is_going_to_onboard ) {
      //     return welcome_location;
      //   // If not logedin and not going to login redirect to Login
      // } else if (is_init && is_onboarded && !is_login && !is_try_login
      //           && !is_going_to_register_login && !is_try_register) {
      //     return register_login_location;
      //
      // } else if (is_init && is_onboarded && is_login
      //           && !is_going_to_verfication && !is_verificated) {
      //     return verification_location;
      //
      //
      //   // If all the scenarios are cleared but still going to any of that screen redirect to Home
      // } else if (is_login && is_init && is_onboarded && is_verificated
      //        // (is_login && is_going_to_login) || (is_init && is_going_to_init) ||
      //        // (is_onboarded && is_going_to_onboard)
      //           ) {
      //   return home_location;
      // } else {
      //   // Else Don't do anything
        return null;
      // }
    },
  );


}


