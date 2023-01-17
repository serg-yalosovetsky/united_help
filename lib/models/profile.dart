
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
  final String? reg_date;
  final bool is_online;


  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.active,
    required this.phone,
    required this.nickname,
    required this.telegram_phone,
    required this.viber_phone,
    this.reg_date,
    this.is_online = true,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    // print('json= $json');

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
      is_online: json['is_online'] ?? false,
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
    this.rating = 0,
    required this.image,
    this.description,
    this.url,
    this.organization,
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
      rating: double.tryParse(json['rating'].toString()) ?? 0,
      skills: json['skills']?.cast<int>() ?? [],
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

    // print(User.fromJson(json['user']));
    // print(Profile.fromJson(json));

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


class Contacts {
  final int count;
  final List<UserProfile> list;

  const Contacts({
    required this.count,
    required this.list,
  });

  factory Contacts.fromJson(List<dynamic> json) {
    var results = <UserProfile>[];
    if (json != []){
      for (var user_profile in json) {
        results.add(UserProfile.fromJson(user_profile));
      }
    }
    return Contacts(
      count: json.length,
      list: results,
    );
  }
}

Future<Profiles> fetchProfiles(String profile_query, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$all_profiles_url/$profile_query';
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
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

  String url = '$server_url$userprofile_url/';
  if (profile_query.isEmpty || profile_query == '0') {
    url += '${app_service.user?.id}/';
  } else {
    url += '$profile_query/';
  }

  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    var r = UserProfile.fromJson(res);
    return r;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load UserProfile');
  }
}



Future<dynamic> fetchContacts(String profile_query, AppService app_service) async {
  var r = Requests();
  print('profile_query $profile_query');
  String url = '$server_url$all_profiles_url$all_contacts_url/';
  if (profile_query.isNotEmpty && (profile_query == 'refugees' ||
      profile_query == 'volunteers' ))
    url = '$url?$profile_query';
  if (profile_query.isNotEmpty && profile_query.contains('event_id'))
    url = '$url?${profile_query.replaceAll('event_id', 'event_id=')}';
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    if (profile_query.isNotEmpty && (profile_query == 'refugees' ||
        profile_query == 'volunteers' || profile_query.contains('event_id'))) {
      var r =  Contacts.fromJson(res[profile_query] ?? res['volunteers'] ?? res['refugees']);
      return r;

    } else{
      print(res);
      return {
        'volunteers': res['volunteers'] != null ? Contacts.fromJson(res['volunteers']) : [],
        'refugees': res['refugees'] != null ? Contacts.fromJson(res['refugees']) : [],
      };
    }
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to load UserProfile');
  }
}


FutureMap postFirebaseToken(String token, AppService app_service) async {
  var r = Requests();
  String url = '$server_url$add_fb_token';
  // print('url: $url');
  var token_map = {'token': token};
  // print('token_map: $token_map');
  final response = await r.post_wrapper(url, token_map, app_service);

  if (response['status_code'] == 200) {
    return response;
  } else {
    app_service.set_access_token(null);
    throw Exception('Failed to add new token');
  }
}