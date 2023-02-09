
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:united_help/providers/appservice.dart';

import '../services/authenticate.dart';
import '../providers/filters.dart';
import '../services/debug_print.dart';
import '../services/urls.dart';
import 'filter.dart';

class Event {
  final int id;
  final String name;
  final bool active;
  final String description;
  final String reg_date;
  final String start_time;
  final String end_time;
  final String image;
  final int city;
  final String location;
  final double location_lat;
  final double location_lon;
  final int employment;
  final int owner;
  final int to;
  final List<int> skills;
  final int required_members;
  final int subscribed_members;
  bool subscribed;
  final double rating;
  final int comments_count;

  Event({
    required this.id,
    required this.name,
    required this.active,
    required this.description,
    required this.reg_date,
    required this.start_time,
    required this.end_time,
    required this.image,
    required this.city,
    required this.location,
    this.location_lat = 0,
    this.location_lon = 0,
    required this.employment,
    required this.owner,
    required this.to,
    required this.skills,
    required this.required_members,
    this.subscribed_members = 0,
    this.subscribed = false,
    this.rating = 0.0,
    this.comments_count = 0,
  });

  factory Event.fromJson(Map<String, dynamic> json) {

    try {

      return Event(
        id: json['id'],
        name: json['name'],
        active: json['active'],
        description: json['description'],
        reg_date: json['reg_date'],
        start_time: json['start_time'],
        end_time: json['end_time'],
        image: json['image'],
        city: json['city'],
        location: json['location'],
        location_lat: double.tryParse(json['location_lat'].toString()) ?? 0,
        location_lon: double.tryParse(json['location_lon'].toString()) ?? 0,
        employment: json['employment'],
        owner: json['owner'],
        to: json['to'],
        skills: json['skills'].cast<int>(),
        required_members: json['required_members'],
        subscribed_members: json['subscribed_members'] ?? 0,
        subscribed: json['subscribed'] ?? false,
        rating: double.tryParse(json['rating'].toString()) ?? 0,
        comments_count: json['comments_count'] ?? 0,
      );
    }
    catch (e) {dPrint(e);}


    return Event(
        id: json['id'],
        name: json['name'],
        active: json['active'],
        description: json['description'],
        reg_date: json['reg_date'],
        start_time: json['start_time'],
        end_time: json['end_time'],
        image: json['image'],
        city: json['city'],
        location: json['location'],
        location_lat: json['location_lat'],
        location_lon: json['location_lon'],
        employment: json['employment'],
        owner: json['owner'],
        to: json['to'],
        skills: json['skills'].cast<int>(),
        required_members: json['required_members'],
        subscribed_members: json['subscribed_members'] ?? 0,
        subscribed: json['subscribed'] ?? false,
        rating: double.tryParse(json['rating'].toString()) ?? 0,
        comments_count: json['comments_count'] ?? 0,
      );
  }

  Map<String, dynamic> to_dict () {
    return {
      'id': this.id,
      'name': this.name,
      'active': this.active,
      'description': this.description,
      'start_time': this.start_time,
      'end_time': this.end_time,
      'image': this.image,
      'city': this.city,
      'location': this.location,
      'location_lat': this.location_lat,
      'location_lon': this.location_lon,
      'employment': this.employment,
      'to': this.to,
      'skills': this.skills,
      'required_members': this.required_members,
      'subscribed': this.subscribed,
    };
  }

}

class Events {
  final int count;
  final String? next;
  final String? previous;
  final List<Event> list;

  const Events({
    required this.count,
    required this.list,
    required this.next,
    required this.previous,
  });

  factory Events.fromJson(Map<String, dynamic> json) {
    dPrint(json);
    var results = <Event>[];
    for (var event in json['results']) {
      results.add(Event.fromJson(event));
    }
    return Events(
      count: json['count'],
      list: results,
      previous: json['previous'],
      next: json['next'],
    );
  }
}


Future<Event> fetchEvent(int event_id, AppService app_service) async {
  var r = Requests();
  String url = '${app_service.server_url}$all_events_url/$event_id/';
  final response = await r.get(url, await app_service.get_access_token());

  if (response['status_code'] == 200) {
    return Event.fromJson(response['result']);
  }
  else {
    throw Exception('Failed to load Event');
  }
}


Future<Events?> fetchEvents(String event_query, AppService app_service, Filters filters) async {
  dPrint('fetchEvents');
  var r = Requests();
  String url = '${app_service.server_url}$all_events_url/';
  if (event_query != ''){
    url += '$event_query';
  }
  dPrint('url= $url');
  final response = await r.get_wrapper(url, app_service);
  dPrint(response);

  if (response['status_code'] == 200) {
    dPrint(response);

    var res  = response['result'];
    dPrint(78678);
    Events events = Events.fromJson(res);
    dPrint(752);

    bool update_skills_map = false;
    if (filters.skills_names.isEmpty) {
      dPrint(987);
      update_skills_map = true;
    } else {
      dPrint(780);
      events_loop:
      for (Event e in events.list) {
        for (int skill in e.skills){
          if (filters.skills_names[skill] == null || filters.skills_names[skill]!.isEmpty){
            update_skills_map = true;
            break events_loop;
          }
        }
      }
    }
    dPrint(78235);
    if (update_skills_map) {
      filters.skills_names = (await fetchSkills('', app_service)).to_dict();
    }
    dPrint(67986);

    return events;
  }

}


FutureMap postEvents(Map<String, dynamic> body, AppService app_service) async {
  var r = Requests();
  dPrint('postEvents');
  dPrint(body);

  String url = '${app_service.server_url}$all_events_url';
  if (body['id'] != 0){
    url = '$url/${body["id"]}/';
  }
  if (body['image'] == '') {
    body.removeWhere((key, value) => key=='image' && value == '');
  }
  else {
    body['image'] = base64Encode(File(body['image']).readAsBytesSync());
  }

  final response = (body['id'] != 0) ? await r.patch_wrapper(url, body, app_service)
                                     : await r.post_wrapper(url, body, app_service);

  if (response['status_code'] == 200 || response['status_code'] == 201) {
    var res  = response['result'];
    return res;
  }
  else {
    throw Exception('Failed to load Event');
  }
}

FutureMap activate_deactivate_event(int event_id, bool activate, AppService app_service,
    {String? cancel_message}) async {
  var r = Requests();
  dPrint('activate_deactivate_Event');

  String url = '${app_service.server_url}$all_events_url/$event_id/${activate ? 'activate' : 'cancel'}/';
  Map<String, dynamic> body = {};
  if (!activate && cancel_message != null ) body = {'message': cancel_message};
  var response = await r.post_wrapper(url, body, app_service);

  if (response['status_code'] >= 200 && response['status_code'] <= 300) {
    return response['result'];
  }
  else {
    throw Exception('Failed to load Event');
  }
}


FutureMap subscribe_unsubscribe_event(int event_id, bool activate, AppService app_service) async {
  var r = Requests();
  dPrint('subscribe_unsubscribe_event');

  String url = '${app_service.server_url}$all_events_url/$event_id/${activate ? 'subscribe' : 'unsubscribe'}/';
  var response = await r.post_wrapper(url, {}, app_service);

  if (response['status_code'] == 200 || response['status_code'] == 204) {
    return response['result'];
  } else {
    throw Exception('Failed to load Event');
  }
}