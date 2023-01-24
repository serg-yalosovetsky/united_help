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
  bool _roleState = false;
  bool _loginState = false;
  bool _initialized = false;
  bool _onboarding = false;
  bool is_try_login = false;
  bool is_try_register = false;
  bool is_register = false;
  String email = '';
  String password = '';
  bool is_register_confirm = false;
  bool is_verificated = false;

  bool _user_image_expire = false;
  int _bottom_navbar_order = 0;
  bool _organizer_has_no_events = false;
  bool _account_actual_events = true;

  String init_key = 'init_key';
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
  bool get onboarding => _onboarding;
  SwitchEnum _list_or_map = SwitchEnum.first;
  SwitchEnum _actual_or_history = SwitchEnum.first;
  SwitchEnum _org_volunteers_or_refugees = SwitchEnum.first;

  Future<bool> login() async {
    var r = Requests();
    String? password = await secure_storage.read(key: password_key);
    String? username = await secure_storage.read(key: username_key);
    late Map<String, dynamic> result;
    if (username != null && password != null) {
      result = await r.authenticate(username, password);
    }
    else return false;

    if (result['success']){
      await secure_storage.write(key: access_key, value: result[access_key]);
      await secure_storage.write(key: refresh_key, value: result[refresh_key]);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> relogin() async {
    var r = Requests();
    String? refresh_token = await secure_storage.read(key: refresh_key);
    late Map<String, dynamic> result;
    if (refresh_token != null) {
      result = await r.refreshing_token(refresh_token);
    }
    else return false;

    if (result['success']){
      await secure_storage.write(key: access_key, value: result[access_key]);
      _loginState = true;
      notifyListeners();
      return true;
    }

    return false;
  }

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

  Future<String?> get_access_token() async {
    String? access_token = await secure_storage.read(key: access_key);
    if (access_token == null){
      // TODO вместо логина пароля нужно передавать рефреш ключ, при ошибке
      // TODO сбросить параметр инит, чтобы юзера выкинуло на главный экран
      var result = await Requests().authenticate('serg', 'sergey104781');
        if (result['success']){
          access_token = result['access_token'];
          secure_storage.write(key: access_key, value: access_token);
        }
    }
    return access_token;
  }

  set loginState(bool state) {
    _loginState = state;
    notifyListeners();
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

  set onboarding(bool value) {
    _onboarding = value;
    notifyListeners();
  }

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

  Future<void> onAppStart() async {
    _onboarding = shared_preferences.getBool(init_key) ?? false;
    _loginState = shared_preferences.getBool(access_key) ?? false;
    await Future.delayed(const Duration(microseconds: 2));
    _initialized = true;
    notifyListeners();
    print('initialized');
  }


  logout() {
    set_access_token(null);
    set_refresh_token(null);
    set_password(null);
    set_username(null);
    password = '';
    email = '';
    _initialized = false;
    loginState = false;
    _roleState = false;
  }

}
