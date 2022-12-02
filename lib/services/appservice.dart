// ignore: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_help/services/authenticate.dart';

import '../fragment/switch_app_bar.dart';

enum Roles  {
  admin,
  volunteer,
  organizer,
  refugee,
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

  String init_key = 'init_key';
  String access_key = 'access_token';
  String refresh_key = 'refresh_token';
  String password_key = 'password';
  String username_key = 'username';
  String profile_key = 'profile';

  AppService(this.secure_storage, this.shared_preferences);

  Future<String?> get access_token async => await secure_storage.read(key: access_key);
  bool get roleState => _roleState;
  bool get loginState => _loginState;
  bool get initialized => _initialized;
  bool get onboarding => _onboarding;
  ListOrMap _list_or_map = ListOrMap.list;

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

  set_password(String str) async {
    await secure_storage.write(key: password_key, value: str);
    notifyListeners();
  }
  set_username(String str) async {
    await secure_storage.write(key: username_key, value: str);
    notifyListeners();
  }
  // Future<String?> get_username() {
  //   return  secure_storage.read(key: username_key);
  // }
  // Future<String?> get_password() async {
  //   return secure_storage.read(key: password_key);
  // }

  get_access_token() async {
    return await secure_storage.read(key: access_key);
  }

  set loginState(bool state) {
    // sharedPreferences.setBool(LOGIN_KEY, state);
    _loginState = state;
    // _loginStateChange.add(state);
    notifyListeners();
  }

  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }
  set list_or_map(ListOrMap value) {
    _list_or_map = value;
    notifyListeners();
  }
  ListOrMap get list_or_map => _list_or_map;

  set onboarding(bool value) {
    _onboarding = value;
    notifyListeners();
  }

  String get role => shared_preferences.getString(profile_key) ?? '';
  set role(String value) {
    if (Roles.values.contains(role)){
      shared_preferences.setString(profile_key, value);
      // _role = value;
      _roleState = true;
      notifyListeners();
    }
  }

  Future<void> onAppStart() async {
    _onboarding = shared_preferences.getBool(init_key) ?? false;
    _loginState = shared_preferences.getBool(access_key) ?? false;
    // if (!role.isEmpty){
    //   _roleState = true;
    // }
    // if (await relogin()) _loginState = true;
    await Future.delayed(const Duration(microseconds: 2));
    _initialized = true;
    notifyListeners();
    print('initialized');

  }
}
