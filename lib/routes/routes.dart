import 'package:go_router/go_router.dart';
import 'package:united_help/screen/contacts_screen.dart';
import 'package:united_help/screen/filter_screen.dart';
import 'package:united_help/screen/home_list.dart';
import 'package:united_help/screen/login_screen.dart';
import 'package:united_help/screen/new_event_screen.dart';
import 'package:united_help/screen/password_recovery.dart';
import 'package:united_help/screen/splash_screen.dart';
import 'package:united_help/screen/welcome_register_or_login.dart';
import 'package:united_help/screen/welcome_role.dart';

import '../fragment/switch_app_bar.dart';
import '../screen/account_screen.dart';
import '../fragment/events_list.dart';
import '../screen/diia_sign_screen.dart';
import '../screen/edit_account.dart';
import '../screen/email_password_confirmation.dart';
import '../screen/errror_screen.dart';
import '../screen/home_map.dart';
import '../screen/my_events_history.dart';
import '../screen/my_events_organizer.dart';
import '../screen/new_event_choose_help_or_job.dart';
import '../screen/notifications_screen.dart';
import '../screen/register_email_confirmation.dart';
import '../screen/register_screen.dart';
import '../screen/settings_screen.dart';
import '../screen/verification_main.dart';
import '../providers/appservice.dart';
import '../providers/filters.dart';
import '../services/debug_print.dart';


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
  my_events_history,
  contacts,
  filters_screen,
  error,
  account,
  edit_account,
  settings,
  notifications,
  webview_diia,
}

extension AppPageExtension on APP_PAGE {
  String get to_path {
    switch (this) {
      case APP_PAGE.home_list:
        return "/";
      case APP_PAGE.new_events:
        return "/new_events";
      case APP_PAGE.webview_diia:
        return "/webview_diia";
      case APP_PAGE.new_events_choose_help_or_job:
        return "/new_events_choose_help_or_job";
      case APP_PAGE.my_events:
        return "/my_events";
      case APP_PAGE.my_events_history:
        return "/my_events_history";
      case APP_PAGE.contacts:
        return "/contacts";
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
      case APP_PAGE.filters_screen:
        return "/filters_screen";
      case APP_PAGE.notifications:
        return "/notifications";
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
      case APP_PAGE.webview_diia:
        return "WEBVIEW_DIIA";
      case APP_PAGE.my_events:
        return "MY_EVENTS";
      case APP_PAGE.my_events_history:
        return "MY_EVENTS_HISTORY";
      case APP_PAGE.new_events_choose_help_or_job:
        return "NEW_EVENTS_CHOOSE_HELP_OR_JOB";
      case APP_PAGE.contacts:
        return "CONTACTS";
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
      case APP_PAGE.filters_screen:
        return "FILTERS_SCREEN";
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
      case APP_PAGE.notifications:
        return "NOTIFICATIONS";
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
  late final Filters filters;
  GoRouter get router => _go_router;

  AppRouter(this.app_service, this.filters);


  late final GoRouter _go_router = GoRouter(
    refreshListenable: app_service,
    initialLocation: app_service.role==Roles.organizer ?
                        APP_PAGE.my_events.to_path :
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
        path: APP_PAGE.webview_diia.to_path,
        name: APP_PAGE.webview_diia.to_name,
        builder: (context, state) => const WebViewDiia(),
      ),
      GoRoute(
        path: '${APP_PAGE.new_events.to_path}/:event_for_or_edit',
        name: APP_PAGE.new_events.to_name,
        builder: (context, state) => NewEventScreen(
          event_for_or_edit: state.params['event_for_or_edit'] ?? '',
        ),
      ),
      GoRoute(
        path: APP_PAGE.my_events.to_path,
        name: APP_PAGE.my_events.to_name,
        builder: (context, state) => MyEventsScreen(),
      ),
      GoRoute(
        path: APP_PAGE.my_events_history.to_path,
        name: APP_PAGE.my_events_history.to_name,
        builder: (context, state) => MyEventsHistoryScreen(),
      ),
      GoRoute(
        path: APP_PAGE.new_events_choose_help_or_job.to_path,
        name: APP_PAGE.new_events_choose_help_or_job.to_name,
        builder: (context, state) => NewEventChooseHelpOrJobScreen(),
      ),
      GoRoute(
        path: '${APP_PAGE.contacts.to_path}/:contacts_type',
        name: APP_PAGE.contacts.to_name,
        builder: (context, state) => ContactsScreen(profiles_query: state.params['contacts_type'] ?? 'volunteers'),
      ),
      GoRoute(
        path: APP_PAGE.filters_screen.to_path,
        name: APP_PAGE.filters_screen.to_name,
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
        path: '${APP_PAGE.account.to_path}/:account_id',
        name: APP_PAGE.account.to_name,
        builder: (context, state) => AccountScreen(user_id: int.parse(state.params['account_id'] ?? '0')),
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
        path: APP_PAGE.notifications.to_path,
        name: APP_PAGE.notifications.to_name,
        builder: (context, state) => NotificationsScreen(),
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
      final register_login_location = APP_PAGE.register_login.to_path;
      var _home = '';
      if(app_service.role == Roles.organizer)
        if(app_service.actual_or_history == SwitchEnum.first) {
          _home = APP_PAGE.my_events.to_path;
        } else {
          _home = APP_PAGE.my_events_history.to_path;
        }
      else {
        _home = APP_PAGE.home_list.to_path;
      }
      final home_location = _home;
      final splash_location = APP_PAGE.splash.to_path;
      final welcome_location = APP_PAGE.welcome.to_path;
      final verification_location = APP_PAGE.verification.to_path;

      var is_going_to_login = state.subloc == login_location;
      var is_going_to_register_login = state.subloc == register_login_location;
      var is_going_to_init = state.subloc == splash_location;
      var is_going_to_onboard = state.subloc == welcome_location;
      var is_going_to_verfication = state.subloc == verification_location;
      var is_need_to_home = (state.subloc == verification_location ||
          state.subloc == welcome_location || state.subloc == splash_location ||
          state.subloc == register_login_location || state.subloc == login_location);

      // if (is_test && !is_going_to_home) return home_location;


      // If not Initialized and not going to Initialized redirect to Splash
      if (!app_service.initialized && !is_going_to_init) {
          return splash_location;
        // If not onboard and not going to onboard redirect to OnBoarding
      } else  if (app_service.initialized && !app_service.onboarding && !is_going_to_onboard ) {
          return welcome_location;
        // If not logedin and not going to login redirect to Login
      } else if (app_service.initialized && app_service.onboarding && !app_service.loginState && !app_service.is_try_login
                && !is_going_to_register_login && !app_service.is_try_register) {
          return register_login_location;

      } else if (app_service.initialized && app_service.onboarding && app_service.loginState && !app_service.is_verificated &&
                !is_going_to_verfication  && !app_service.is_try_verificated) {
          dPrint('return verification_location');
          return verification_location;

        // If all the scenarios are cleared but still going to any of that screen redirect to Home
      } else if (app_service.loginState && app_service.initialized &&
          app_service.onboarding && app_service.is_verificated && is_need_to_home) {
        dPrint('return home location');
        return home_location;
      } else {
        return null;
      }
    },
  );


}


