
import 'package:united_help/services/appservice.dart';

import '../services/authenticate.dart';
import '../services/urls.dart';

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
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var e= Event(
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
    );
    print(e);
    return e;
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
      print('event = $event');
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



Future<Events> fetchEvents(String event_query, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_events_url/$event_query';
  final response = await r.get_wrapper(url, await app_service.get_access_token());

  if (response['status_code'] == 200) {
    var res  = response['result'];
    return Events.fromJson(res);
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load Event');
  }
}
