
import 'dart:convert';

import 'package:united_help/models/profile.dart';

import '../providers/appservice.dart';
import '../services/authenticate.dart';
import '../services/urls.dart';


class Comment {
  final int id;
  final int event_id;
  final User user;
  final String text;
  final String user_image;
  final int? parent;
  final double? rating;

  Comment({
    required this.id,
    required this.event_id,
    required this.user,
    required this.text,
    required this.user_image,
    this.parent,
    this.rating,

  });

  factory Comment.fromJson(Map<String, dynamic> json) {

    return Comment(
      id: json['id'],
      event_id: json['event'],
      user: User.fromJson(json['user']),
      text: json['text'],
      user_image: json['image'],
      parent: json['parent'],
      rating: double.tryParse(json['rating'].toString()),
    );
  }

}


class Comments {
  final int count;
  final String? next;
  final String? previous;
  final List<Comment> list;

  const Comments({
    required this.count,
    required this.list,
    required this.next,
    required this.previous,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    var results = <Comment>[];
    for (var comment in json['results']) {
      print(comment);
      results.add(Comment.fromJson(comment));
    }
    return Comments(
      count: json['count'],
      list: results,
      previous: json['previous'],
      next: json['next'],
    );
  }
}


Future<Comments> fetchComments(String event_query, AppService app_service) async {
  var r = Requests();
  print(1);
  String url = '$server_url$all_events_url/$event_query$user_comments_url/';
  print(url);
  final response = await r.get_wrapper(url, app_service);
  print(3);

  if (response['status_code'] == 200) {
    print(4);
    print(response['result']);
    var c = Comments.fromJson(response['result']);
    print(c);
    return c;
  } else {
    print(6);
    app_service.set_access_token(null);
    throw Exception('Failed to load Comments');
  }
}


