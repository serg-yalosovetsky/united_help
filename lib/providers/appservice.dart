// ignore: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_help/services/authenticate.dart';

import '../fragment/switch_app_bar.dart';
import '../models/filter.dart';
import '../models/profile.dart';
import '../services/debug_print.dart';
import '../services/urls.dart';

enum Roles  {
  admin,
  volunteer,
  organizer,
  refugee,
}


int roles_2_int(Roles role){
  switch (role) {
    case Roles.admin:
      return 0;
    case Roles.volunteer:
      return 1;
    case Roles.organizer:
      return 2;
    case Roles.refugee:
      return 3;
  }
}
// var rolesMap = {
//   Roles.admin: 'admin',
//   Roles.volunteer: 'volunteer',
//   Roles.organizer: 'organizer',
//   Roles.refugee: 'refugee',
// };
Roles isRole(String value){
    return Roles.values.firstWhere(
            (element) => element.toString() == value,
            orElse: () => Roles.volunteer);
}

class AppService with ChangeNotifier {
  late final SharedPreferences shared_preferences;
  late final FlutterSecureStorage secure_storage;


  String _server_url = 'https://united-help.pp.ua';

  set server_url (String value) {
    _server_url = value;
    shared_preferences.setString('server_url', value);
    notifyListeners();
  }
  String get server_url => shared_preferences.getString('server_url') ?? _server_url;


  bool _roleState = false;
  bool _loginState = false;
  bool _initialized = false;
  bool is_try_login = false;
  bool is_try_register = false;
  bool _is_try_verificated = false;
  bool is_register = false;
  String username = '';
  String password = '';
  bool is_register_confirm = false;

  bool _user_image_expire = false;
  int _bottom_navbar_order = 0;
  bool _organizer_has_no_events = false;
  bool _account_actual_events = true;

  String user_init_role_key = 'init_key';
  String user_key = 'user_key';
  String access_key = 'access_token';
  String refresh_key = 'refresh_token';
  String password_key = 'password';
  String username_key = 'username';
  String profile_key = 'profile';
  String volunteer_key = 'volunteer';
  String organizer_key = 'organizer';
  String refugee_key = 'refugee';

  AppService(this.secure_storage, this.shared_preferences);

  Future<String?> get access_token async => await secure_storage.read(key: access_key);
  bool get roleState => _roleState;
  bool get loginState => _loginState;
  bool get initialized => _initialized;

  bool get onboarding => shared_preferences.getBool(user_init_role_key) ?? false;
  set onboarding(bool value) {
    shared_preferences.setBool(user_init_role_key, value);
    notifyListeners();
  }

  SwitchEnum _list_or_map = SwitchEnum.first;
  SwitchEnum _actual_or_history = SwitchEnum.first;
  SwitchEnum _org_volunteers_or_refugees = SwitchEnum.first;


  set_password(String? str) async {
    await secure_storage.write(key: password_key, value: str);
    notifyListeners();
  }
  set_username(String? str) async {
    await secure_storage.write(key: username_key, value: str);
    notifyListeners();
  }
  set_access_token(String? str) async {
    await secure_storage.write(key: access_key, value: str);
  }
  set_refresh_token(String? str) async {
    await secure_storage.write(key: access_key, value: str);
  }



  String _event_query = '';
  set event_query (String value) {
    _event_query = value;
    notifyListeners();
  }
  String get event_query => _event_query;


  String previous_location = '';
  String _current_location = '';
  int current_index = 0;
  set current_location (String value) {
    previous_location = _current_location;
    _current_location = value;
  }
  String get current_location => _current_location;

  set user_image_expire (bool value) {
    _user_image_expire = value;
    notifyListeners();
  }
  bool get user_image_expire => _user_image_expire;

  set bottom_navbar_order(int value) {
    _bottom_navbar_order = value;
    notifyListeners();
  }
  int get bottom_navbar_order => _bottom_navbar_order;

  bool get organizer_has_no_events => _organizer_has_no_events;
  set organizer_has_no_events(bool has_events) {
    _organizer_has_no_events = has_events;
    notifyListeners();
  }

  bool get is_try_verificated => _is_try_verificated;
  set is_try_verificated(bool __is_try_verificated) {
    _is_try_verificated = __is_try_verificated;
    notifyListeners();
  }

  bool get is_verificated => shared_preferences.getBool('is_verificated') ?? false;
  set is_verificated(bool __is_verificated) {
    shared_preferences.setBool('is_verificated', __is_verificated);
    notifyListeners();
  }

  set account_actual_events (bool value) {
    _account_actual_events = value;
    notifyListeners();
  }
  bool get account_actual_events => _account_actual_events;


  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }
  set list_or_map(SwitchEnum value) {
    _list_or_map = value;
    notifyListeners();
  }
  SwitchEnum get list_or_map => _list_or_map;

  set actual_or_history(SwitchEnum value) {
    _actual_or_history = value;
    notifyListeners();
  }
  SwitchEnum get actual_or_history => _actual_or_history;

  set org_volunteers_or_refugees(SwitchEnum value) {
    _org_volunteers_or_refugees = value;
    notifyListeners();
  }
  SwitchEnum get org_volunteers_or_refugees => _org_volunteers_or_refugees;

  bool get is_sent_firebase_token => shared_preferences.getBool('is_sent_firebase_token') ?? false;
  set is_sent_firebase_token(bool value) {
      shared_preferences.setBool('is_sent_firebase_token', value);
  }

  Roles get role => isRole(shared_preferences.getString(profile_key) ?? '');
  set role(Roles value) {
    if (Roles.values.contains(role)){
      shared_preferences.setString(profile_key, value.toString());
      _roleState = true;
      notifyListeners();
    }
  }

  User? get user {
    var user_str = shared_preferences.getString(user_key);
    return user_str!=null ? User.decode(user_str) : null;
  }
  set user(User? user) {
    if (user != null) {
      shared_preferences.setString(user_key, user.encode());
      notifyListeners();
    }
  }

  Profile? get volunteer {
    var profile_str = shared_preferences.getString(volunteer_key);
    return profile_str!=null ? Profile.decode(profile_str) : null;
  }
  set volunteer(Profile? volunteer) {
    if (volunteer == null)
       shared_preferences.remove(volunteer_key);
    else
       shared_preferences.setString(volunteer_key, volunteer.encode());
    notifyListeners();
  }

  Profile? get organizer {
    var profile_str = shared_preferences.getString(organizer_key);
    return profile_str!=null ? Profile.decode(profile_str) : null;
  }
  set organizer(Profile? organizer) {
      if (organizer == null)
          shared_preferences.remove(organizer_key);
      else
          shared_preferences.setString(organizer_key, organizer.encode());
      notifyListeners();
  }

  Profile? get refugee {
    var profile_str = shared_preferences.getString(organizer_key);
    return profile_str!=null ? Profile.decode(profile_str) : null;
  }
  set refugee(Profile? refugee) {
    if (refugee == null)
      shared_preferences.remove(refugee_key);
    else
      shared_preferences.setString(refugee_key, refugee.encode());
      notifyListeners();
  }

  Profile? get current_profile {
    Roles role = this.role;
    if (role == Roles.volunteer)
      return this.volunteer;
    if (role == Roles.organizer)
      return this.organizer;
    if (role == Roles.refugee)
      return this.refugee;
  }
  set current_profile(Profile? profile) {
      Roles role = this.role;
      if (role == Roles.volunteer)
        this.volunteer = profile;
      if (role == Roles.organizer)
        this.organizer = profile;
      if (role == Roles.refugee)
        this.refugee = profile;
  }


  Future<String?> get_access_token() async {
    dPrint('get_access_token');
    dPrint(11);
    String? access_token = await secure_storage.read(key: access_key);
    dPrint(12);
    bool is_login = false;
    dPrint(13);
    if (access_token == null){
      dPrint(14);
        is_login = await relogin();
      dPrint(15);
        dPrint('token valid on relogin =$is_login');
      dPrint(16);
        if (!is_login) {
          dPrint(17);
          is_login = await login();
          dPrint(18);
          dPrint('token valid on login =$is_login');
          dPrint(19);
        }
      dPrint(20);

    }
    else {
      is_login = true;
    }

    dPrint(21);
    if (is_login){
      dPrint(22);
      loginState = true;
      dPrint(23);
      var _access_key = await secure_storage.read(key: access_key);
      dPrint('_access_key= $_access_key');
      return _access_key;
      dPrint(24);
    }
    else {
    dPrint(25);
      loginState = false;
    dPrint(26);
      return null;
    dPrint(27);
    }
    dPrint(28);
  }

  set loginState(bool state) {
    _loginState = state;
    notifyListeners();
  }


  Future<bool> login() async {
    dPrint('method login');

    var r = Requests();
    String? password = await secure_storage.read(key: password_key);
    String? username = await secure_storage.read(key: username_key);
    late Map<String, dynamic> result;
    if (username != null && password != null) {
      result = await r.authenticate(username, password, server_url);
      dPrint(result);
    }
    else {
      dPrint('no username or password');
      loginState = false;
      return false;
    }

    if (result['success'] != null && result['success']){
      await secure_storage.write(key: access_key, value: result[access_key]);
      await secure_storage.write(key: refresh_key, value: result[refresh_key]);
      dPrint('success login');
      loginState = true;
      initialized = true;
      notifyListeners();
      return true;
    }
    dPrint('FAIL login');
    loginState = false;
    return false;
  }

  Future<bool> relogin() async {
    dPrint('TRY TO RELOGIN');
    late Map<String, dynamic> result;
    var r = Requests();
    String? refresh_token = await secure_storage.read(key: refresh_key);
    dPrint('refresh_token= $refresh_token');
    if (refresh_token != null) {
      result = await r.refreshing_token(refresh_token, server_url);
      dPrint('result= $result');
      dPrint(0);

    }
    else {
      dPrint(1);
      return false;
    }

    dPrint(2);
    if (result['success']){
      dPrint(3);
      await secure_storage.write(key: access_key, value: result['access_token']);
      dPrint(await secure_storage.read(key: refresh_key));
      _loginState = true;
      dPrint(5);
      notifyListeners();
      dPrint(6);
      return true;
    }

    dPrint(7);
    return false;
  }

  Future<bool> verify_token() async {
    dPrint('method verify_token');
    var r = Requests();
    String? access_token = await secure_storage.read(key: access_key);
    late Map<String, dynamic> result;
    if (access_token != null) {
      String url = '$server_url$verify_token_url/';
      dPrint(url);
      dPrint({'token':access_token});
      result = await r.post(url, {'token':access_token}, );
      dPrint(result);
    }
    else {
      return false;
    }

    if (result['status_code'] != null && result['status_code'] >= 200 && result['status_code'] < 300){
      _loginState = true;
      notifyListeners();
      dPrint('token is valid');
      return true;
    }
    dPrint('token is invalid');
    return false;
  }

  Future<void> onAppStart() async {

    dPrint('try verify verify_token');

    bool is_login = await verify_token();

    dPrint('token valid on verify_token =$is_login');
    if (!is_login) {
      is_login = await relogin();
      dPrint('token valid on relogin =$is_login');
      if (!is_login) {
        is_login = await login();
        dPrint('token valid on login =$is_login');
      }
    }

    if (is_login) {
      loginState = true;
    }
    else {
      _loginState = false;
      String? refresh_token = await secure_storage.read(key: refresh_key);
      if (refresh_token != null && refresh_token.isNotEmpty) {
        is_try_login = true;
        is_try_register = false;
        is_register = true;
        loginState = true;
      }
      else {
        is_try_login = false;
        is_try_register = true;
        is_register = false;
        loginState = false;
      }
    }
    if (user == null || user?.id == null){

    }
    _initialized = true;

    notifyListeners();
    dPrint('initialized');
  }


  logout() {
    set_access_token(null);
    set_refresh_token(null);
    set_password(null);
    set_username(null);
    password = '';
    username = '';
    _initialized = false;
    loginState = false;
    _roleState = false;
  }

}
