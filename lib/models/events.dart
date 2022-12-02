
class Event {
  final int userId;
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
  final List<int> skills;
  final int required_members;

  const Event({
    required this.userId,
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
    required this.skills,
    required this.required_members,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      userId: json['owner'],
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
      skills: json['skills'].cast<int>(),
      required_members: json['required_members'],
    );
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

