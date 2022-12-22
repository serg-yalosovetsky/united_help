
import 'dart:convert';

import '../services/appservice.dart';
import '../services/authenticate.dart';
import '../services/urls.dart';

class User {
  final int id;
  final bool active;
  final String? phone;
  final String username;
  final String email;
  final String? nickname;
  final String? telegram_phone;
  final String? viber_phone;
  final String reg_date;


  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.active,
    required this.phone,
    required this.nickname,
    required this.telegram_phone,
    required this.viber_phone,
    required this.reg_date,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      active: json['active'],
      phone: json['phone'],
      nickname: json['nickname'],
      telegram_phone: json['telegram_phone'],
      viber_phone: json['viber_phone'],
      reg_date: json['reg_date'],
    );
    // print(e);
    // return e;
  }
  String encode () {
    Map user_map = {
      'id': this.id,
      'username': this.username,
      'email': this.email,
      'active': this.active,
      'phone': this.phone,
      'nickname': this.nickname,
      'telegram_phone': this.telegram_phone,
      'viber_phone': this.viber_phone,
      'reg_date': this.reg_date,
    };
    return json.encode(user_map);
  }
  factory User.decode(String user_str) {
    return User.fromJson(json.decode(user_str));
  }
}


class Profile {
  final int id;
  final int role;
  final double rating;
  String? image;
  final String? description;
  final String? url;
  final String? organization;
  final bool active;
  final List<int> skills;

  Profile({
    required this.id,
    required this.role,
    required this.rating,
    required this.image,
    required this.description,
    required this.url,
    required this.organization,
    required this.active,
    required this.skills,

  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      active: json['active'],
      description: json['description'],
      image: json['image'],
      url: json['url'],
      organization: json['organization'],
      role: json['role'],
      rating: json['rating'],
      skills: json['skills'].cast<int>(),
    );
    // print(e);
    // return e;
  }
  String encode () {
    Map profile_map = {
      'id': this.id,
      'role': this.role,
      'active': this.active,
      'rating': this.rating,
      'image': this.image,
      'description': this.description,
      'url': this.url,
      'organization': this.organization,
      'skills': this.skills,
    };
    return json.encode(profile_map);
  }
  factory Profile.decode(String profile_str) {
    return Profile.fromJson(json.decode(profile_str));
  }
}


class UserProfile {
  final User user;
  final Profile profile;

  const UserProfile({
    required this.user,
    required this.profile,

  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      user: User.fromJson(json['user']),
      profile: Profile.fromJson(json),
    );
  }
}


class Users {
  final int count;
  final String? next;
  final String? previous;
  final List<User> list;

  const Users({
    required this.count,
    required this.list,
    required this.next,
    required this.previous,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    var results = <User>[];
    for (var event in json['results']) {
      results.add(User.fromJson(event));
    }
    return Users(
      count: json['count'],
      list: results,
      previous: json['previous'],
      next: json['next'],
    );
  }
}


class Profiles {
  final int count;
  final String? next;
  final String? previous;
  final List<Profile> list;

  const Profiles({
    required this.count,
    required this.list,
    required this.next,
    required this.previous,
  });

  factory Profiles.fromJson(Map<String, dynamic> json) {
    var results = <Profile>[];
    for (var event in json['results']) {
      results.add(Profile.fromJson(event));
    }
    return Profiles(
      count: json['count'],
      list: results,
      previous: json['previous'],
      next: json['next'],
    );
  }
}


Future<Profiles> fetchProfiles(String profile_query, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_profiles_url/$profile_query';
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = Profiles.fromJson(res);
    return r;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load Profile');
  }
}


Future<Profile> fetchProfile(String profile_query, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_profiles_url/$profile_query';
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = Profile.fromJson(res);
    return r;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load Profile');
  }
}

Future<String> fetchProfileImage(AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_profiles_url/me/image/';
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    return res['image'];
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load image');
  }
}


Future<Users> fetchUsers(String user_query, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_users_url/$user_query';
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = Users.fromJson(res);
    return r;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load User');
  }
}

Future<User> fetchUser(String user_query, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_users_url/$user_query';
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    var r = User.fromJson(res);
    return r;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load User');
  }
}


Future<UserProfile> fetchUserProfile(String profile_query, AppService app_service) async {
  var r = Requests();

  String url = '$server_url$userprofile_url/$profile_query';
  if (profile_query.isEmpty)
    url += '1';
  print('url $url');
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = UserProfile.fromJson(res);
    return r;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load UserProfile');
  }
}
