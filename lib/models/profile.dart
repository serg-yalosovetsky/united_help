
import '../services/authenticate.dart';
import '../services/urls.dart';

class User {
  final int id;
  final bool active;
  final String? phone;
  final String username;
  final String? nickname;
  final String? telegram_phone;
  final String? viber_phone;
  final String reg_date;


  const User({
    required this.id,
    required this.username,
    required this.active,
    required this.phone,
    required this.nickname,
    required this.telegram_phone,
    required this.viber_phone,
    required this.reg_date,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    var e= User(
      id: json['id'],
      username: json['username'],
      active: json['active'],
      phone: json['phone'],
      nickname: json['nickname'],
      telegram_phone: json['telegram_phone'],
      viber_phone: json['viber_phone'],
      reg_date: json['reg_date'],
    );
    print(e);
    return e;
  }
}


class Profile {
  final int id;
  final int role;
  final double rating;
  final String? image;
  final String? description;
  final String? url;
  final String? organization;
  final bool active;
  final List<int> skills;

  const Profile({
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
    var e= Profile(
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
    print(e);
    return e;
  }
}



class UserProfile {
  final int id;
  final User user;
  final int role;
  final double rating;
  final String? image;
  final String? description;
  final String? url;
  final String? organization;
  final bool active;
  final List<int> skills;

  const UserProfile({
    required this.id,
    required this.user,
    required this.role,
    required this.rating,
    required this.image,
    required this.description,
    required this.url,
    required this.organization,
    required this.active,
    required this.skills,

  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    print(json);
    var e= UserProfile(
      id: json['id'],
      user: User.fromJson(json['user']),
      active: json['active'],
      description: json['description'],
      image: json['image'],
      url: json['url'],
      organization: json['organization'],
      role: json['role'],
      rating: json['rating'],
      skills: json['skills'].cast<int>(),
    );
    print(e);
    return e;
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
      print('event = $event');
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
      print('event = $event');
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


Future<Profiles> fetchProfiles(String profile_query) async {
  var r = Requests();
  String url = '$server_url$all_profiles_url/$profile_query';
  final response = await r.get_wrapper(url);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = Profiles.fromJson(res);
    return r;
  } else {
    throw Exception('Failed to load Profile');
  }
}


Future<Profile> fetchProfile(String profile_query) async {
  var r = Requests();
  String url = '$server_url$all_profiles_url/$profile_query';
  final response = await r.get_wrapper(url);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = Profile.fromJson(res);
    return r;
  } else {
    throw Exception('Failed to load Profile');
  }
}


Future<Users> fetchUsers(String user_query) async {
  var r = Requests();
  String url = '$server_url$all_users_url/$user_query';
  final response = await r.get_wrapper(url);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = Users.fromJson(res);
    return r;
  } else {
    throw Exception('Failed to load User');
  }
}

Future<User> fetchUser(String user_query) async {
  var r = Requests();
  String url = '$server_url$all_users_url/$user_query';
  final response = await r.get_wrapper(url);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    var r = User.fromJson(res);
    return r;
  } else {
    throw Exception('Failed to load User');
  }
}


Future<UserProfile> fetchUserProfile(String profile_query) async {
  var r = Requests();

  String url = '$server_url$userprofile_url/$profile_query';
  if (profile_query.isEmpty)
    url += '1';
  print('url $url');
  final response = await r.get_wrapper(url);

  if (response['status_code'] == 200) {
    var res  = response['result'];
    print(response['result']);
    var r = UserProfile.fromJson(res);
    return r;
  } else {
    throw Exception('Failed to load UserProfile');
  }
}
