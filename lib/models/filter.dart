
import 'package:united_help/providers/appservice.dart';

import '../services/authenticate.dart';
import '../services/urls.dart';

class Skill {
  final int id;
  final String name;
  final List<int> parents;
  final String? image;

  const Skill({
    required this.parents,
    required this.id,
    required this.name,
    this.image,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      parents: json['parents'].cast<int>(),
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}


class Skills {
  final int count;
  final String? next;
  final String? previous;
  final List<Skill> list;

  const Skills({
    required this.count,
    required this.list,
    required this.next,
    required this.previous,
  });

  factory Skills.fromJson(Map<String, dynamic> json) {
    var results = <Skill>[];
    for (var skill in json['results']) {
      results.add(Skill.fromJson(skill));
    }
    return Skills(
      count: json['count'],
      list: results,
      previous: json['previous'],
      next: json['next'],
    );
  }
  Map<int, String> to_dict() {
    Map<int, String> map = {};
    for (Skill skill in this.list) {
      map[skill.id] = skill.name;
    }
    return map;
  }
}



class City {
  final int id;
  final String city;
  final String alias;

  const City({
    required this.id,
    required this.city,
    required this.alias,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      city: json['city'],
      alias: json['alias'],
    );
  }
}


class Cities {
  final int count;
  final String? next;
  final String? previous;
  final List<City> list;

  const Cities({
    required this.count,
    required this.list,
    required this.next,
    required this.previous,
  });

  factory Cities.fromJson(Map<String, dynamic> json) {
    var results = <City>[];
    for (var event in json['results']) {
      results.add(City.fromJson(event));
    }
    return Cities(
      count: json['count'],
      list: results,
      previous: json['previous'],
      next: json['next'],
    );
  }
}


enum Employments {
  full,
  part_time,
  one_time,
}

Map<Employments, String>  employments_text = {
  Employments.full: 'Постійна',
  Employments.part_time: 'Часткова',
  Employments.one_time: 'Івент',
};

Map<int, String>  employments_listmap =  {
  0: 'Постійна',
  1: 'Часткова',
  2: 'Івент',
};


Future<Skills> fetchSkills(String skill_query, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_skills_url/';
  url += skill_query;

  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = Skills.fromJson(res);
    return r;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load Skills');
  }
}


Future<Cities> fetchCities(String city_query, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_cities_url/';
  url += city_query;

  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = Cities.fromJson(res);
    return r;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load Cities');
  }
}