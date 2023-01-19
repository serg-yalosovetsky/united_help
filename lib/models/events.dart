
import 'dart:convert';
import 'dart:io';

import 'package:united_help/services/appservice.dart';

import '../services/authenticate.dart';
import '../services/urls.dart';
import 'filter.dart';

class Event {
  final int id;
  final String name;
  final bool enabled;
  final String description;
  final String reg_date;
  final String start_time;
  final String end_time;
  final String image;
  final int city;
  final String location;
  final int employment;
  final int owner;
  final int to;
  final List<int> skills;
  final int required_members;
  final int subscribed_members;
  final double rating;
  final int comments_count;

  const Event({
    required this.id,
    required this.name,
    required this.enabled,
    required this.description,
    required this.reg_date,
    required this.start_time,
    required this.end_time,
    required this.image,
    required this.city,
    required this.location,
    required this.employment,
    required this.owner,
    required this.to,
    required this.skills,
    required this.required_members,
    this.subscribed_members = 0,
    this.rating = 0.0,
    this.comments_count = 0,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    print('EVENT');
    print(json);
    return Event(
      id: json['id'],
      name: json['name'],
      enabled: json['enabled'],
      description: json['description'],
      reg_date: json['reg_date'],
      start_time: json['start_time'],
      end_time: json['end_time'],
      image: json['image'],
      city: json['city'],
      location: json['location'],
      employment: json['employment'],
      owner: json['owner'],
      to: json['to'],
      skills: json['skills'].cast<int>(),
      required_members: json['required_members'],
      subscribed_members: json['subscribed_members'] ?? 0,
      rating:  double.tryParse(json['rating'].toString()) ?? 0,
      comments_count: json['comments_count'] ?? 0,

    );
  }

  Map<String, dynamic> to_dict () {
    return {
      'id': this.id,
      'name': this.name,
      'enabled': this.enabled,
      'description': this.description,
      'start_time': this.start_time,
      'end_time': this.end_time,
      'image': this.image,
      'city': this.city,
      'location': this.location,
      'employment': this.employment,
      'to': this.to,
      'skills': this.skills,
      'required_members': this.required_members,
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
  String url = '$server_url$all_events_url/$event_id';
  final response = await r.get(url, await app_service.get_access_token());

  if (response['status_code'] == 200) {
    return Event.fromJson(response['result']);
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load Event');
  }
}


Future<Events> fetchEvents(String event_query, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_events_url/';
  if (event_query != ''){
    url += '$event_query/';
  }
  print('url= $url');
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    Events events = Events.fromJson(res);

    bool update_skills_map = false;
    if (app_service.skills_names.isEmpty) {
      update_skills_map = true;
    } else {
      events_loop:
      for (Event e in events.list) {
        for (int skill in e.skills){
          if (app_service.skills_names[skill] == null || app_service.skills_names[skill]!.isEmpty){
            update_skills_map = true;
            break events_loop;
          }
        }
      }
    }
    if (update_skills_map) {
      app_service.skills_names = (await fetchSkills('', app_service)).to_dict();
    }
    return events;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load Event');
  }
}


FutureMap postEvents(Map<String, dynamic> body, AppService app_service) async {
  var r = Requests();
  print('postEvents');
  print(body);

  String url = '$server_url$all_events_url';
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
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load Event');
  }
}

FutureMap activate_deactivate_Event(int event_id, bool activate, AppService app_service) async {
  var r = Requests();
  print('activate_deactivate_Event');

  String url = '$server_url$all_events_url/$event_id/${activate ? 'activate' : 'cancel'}/';
  var response = await r.post_wrapper(url, {}, app_service);

  if (response['status_code'] == 200 || response['status_code'] == 201) {
    return response['result'];
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load Event');
  }
}