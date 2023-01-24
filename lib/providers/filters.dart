// ignore: non_constant_identifier_names
import 'dart:async';
import 'dart:convert';

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


  int _city = -1;
  set city (int value) {
    _city = value;
    notifyListeners();
  }
  int get city => _city;

  String name_or_description = '';

  int _new_event_city = -1;
  set new_event_city (int value) {
    _new_event_city = value;
    notifyListeners();
  }
  int get new_event_city => _new_event_city;


  Employments? _employment = null;
  set employment(Employments? value) {
    _employment = value;
    notifyListeners();
  }
  Employments? get employment => _employment;


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


  List<String> _skills_list = [];
  set skills_list (List<String> value) {
    _skills_list = value;
    notifyListeners();
  }
  List<String> get skills_list => _skills_list;


  Map<int, String> skills_names = {};

  Map<String, String> city_aliases = {};
  set_city_aliases (List<City> cities) {
    city_aliases = {};
    for (City city in cities){
      city_aliases[city.city] = city.alias;
    }
  }

  DateTime? start_date = null;
  DateTime? end_date = null;
  TimeOfDay? start_time = null;
  TimeOfDay? end_time = null;


  String filters_key = 'filters_setting';

  save_filters() {
      Map<String, dynamic> filters = {
        'name_or_description': name_or_description,
        'skills': skills_list,
        'city': city,
        'employment': employment,
        'start_date': start_date,
        'end_date': end_date,
        'start_time': start_time,
        'end_time': end_time,
      };
        shared_preferences.setString(filters_key, json.encode(filters));
  }

  restore_filters({bool if_empty=false}) {
    String? filters = shared_preferences.getString(filters_key);
    if (filters != null){
      var filters_json = json.decode(filters);

        if (if_empty ||
            (skills_list.isEmpty && city == -1 && employment == null &&
                start_date == null && time_end == null && date_start == null &&
                date_end == null)) {
          try {
          name_or_description =
              filters_json['name_or_description'] ?? name_or_description;

          if (filters_json['skills'] != null) {
            List<String> skills = [];
            for (var item in filters_json['skills']) {
              if (item.runtimeType == String) skills.add(item.cast(String));
            }
            skills_list = skills.isNotEmpty ? skills : skills_list;
          }

          city = filters_json['city'] ?? city;

          employment =
              str_to_employments(filters_json['employment']) ?? employment;

          print(filters_json['start_date']);
          start_date = filters_json['start_date']!=null ?
                  DateTime.tryParse(filters_json['start_date']) :
                  start_date;

          end_date = filters_json['start_date']!=null ?
                  DateTime.tryParse(filters_json['end_date']) :
                  end_date;

          var _start_time = filters_json['start_time']!=null ?
                  DateTime.tryParse(filters_json['start_time']) :
                  null;

          start_time = _start_time != null
              ? TimeOfDay.fromDateTime(_start_time)
              : start_time;

          var _end_time = filters_json['end_time']!=null ?
                  DateTime.tryParse(filters_json['end_time']) :
                  null;

          end_time =
            _end_time != null ? TimeOfDay.fromDateTime(_end_time) : end_time;

          }
          catch (e) {
            print(e);
          }
        }

    }
  }

  TimeOfDay? time_start;
  TimeOfDay? time_end;
  DateTime? date_start;
  DateTime? date_end;

  bool? event_active = true;

}
