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



class Filters with ChangeNotifier {
  late final SharedPreferences shared_preferences;
  Filters(this.shared_preferences);


  int _filter_city = -1;
  set filter_city (int value) {
    _filter_city = value;
    notifyListeners();
  }
  int get filter_city => _filter_city;


  int _new_event_city = -1;
  set new_event_city (int value) {
    _new_event_city = value;
    notifyListeners();
  }
  int get new_event_city => _new_event_city;


  int _filter_employment = -1;
  set filter_employment (int value) {
    _filter_employment = value;
    notifyListeners();
  }
  int get filter_employment => _filter_employment;


  int _new_event_employment = -1;
  set new_event_employment (int value) {
    _new_event_employment = value;
    notifyListeners();
  }
  int get new_event_employment => _new_event_employment;


  List<String> _city_hint = [];
  set city_hint (List<String> value) {
    _city_hint = value;
    notifyListeners();
  }
  List<String> get city_hint => _city_hint;



  bool _open_text_field_choose_other_city = false;
  set open_text_field_choose_other_city (bool value) {
    _open_text_field_choose_other_city = value;
    notifyListeners();
  }
  bool get open_text_field_choose_other_city => _open_text_field_choose_other_city;




  List<String> _skills_hint = [];
  set skills_hint (List<String> value) {
    _skills_hint = value;
    notifyListeners();
  }
  List<String> get skills_hint => _skills_hint;


  List<String> _skills = [];
  set skills (List<String> value) {
    _skills = value;
    notifyListeners();
  }
  List<String> get skills => _skills;


  Map<int, String> skills_names = {};

  Map<String, String> city_aliases = {};
  set_city_aliases (List<City> cities) {
    city_aliases = {};
    for (City city in cities){
      city_aliases[city.city] = city.alias;
    }

  }

  Employments employment = Employments.full;
  TimeOfDay? time_start;
  TimeOfDay? time_end;
  DateTime? data_start;
  DateTime? data_end;

  bool? event_active = true;


}
