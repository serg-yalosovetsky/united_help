
import 'dart:convert';

import 'package:rate_limiter/rate_limiter.dart';
import 'package:united_help/models/profile.dart';

import '../providers/appservice.dart';
import '../services/authenticate.dart';
import '../services/debug_print.dart';
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
      dPrint(comment);
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
  String url = '${app_service.server_url}$all_events_url/$event_query$user_comments_url/';
  dPrint(url);
  final response = await r.get_wrapper(url, app_service);

  if (response['status_code'] == 200) {
    dPrint(response['result']);
    var c = Comments.fromJson(response['result']);
    dPrint(c);
    return c;
  }
  else {
    throw Exception('Failed to load Event');
  }
}


