import 'dart:convert';

import 'package:hive/hive.dart';


class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.data_title,
    this.data_body,
    this.is_read = false,
    this.image,
  });

  String? title;
  String? body;
  String? data_title;
  String? data_body;
  bool is_read;
  String? image;
}


@HiveType(typeId: 0)
class HivePushNotification extends HiveObject {
  HivePushNotification({
    this.private_id = 0.0,
    this.id = 0,
    this.title = '',
    this.body = '',
    this.to_profile = '',
    this.data = const {},
    this.is_read = false,
    this.image = '',
    this.notify_type = '',
    this.event_id = 0,
    this.event_to = '',
    this.event_name = '',
    this.actor_name = '',
    this.actor_profile_id = 0,

  });
  @HiveField(0)
  late double private_id;

  @HiveField(1)
  late int id;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late String body;

  @HiveField(4)
  late String to_profile;

  @HiveField(5)
  late Map<String, String> data;

  @HiveField(6)
  late bool is_read;

  @HiveField(7)
  late String image;

  @HiveField(8)
  late String notify_type;

  @HiveField(9)
  late int event_id;

  @HiveField(10)
  late String event_to;

  @HiveField(11)
  late String event_name;

  @HiveField(12)
  late String actor_name;

  @HiveField(13)
  late int actor_profile_id;

}

class HivePushNotificationAdapter extends TypeAdapter<HivePushNotification> {
  @override
  final typeId = 0;

  @override
  HivePushNotification read(BinaryReader reader) {
    var map = reader.read();
    Map<String, String> data = {};
    if (map['_data'] != null) {
      var decoded_data = json.decode(map['_data']);
      for (String k in decoded_data.keys){
        data[k] = decoded_data[k].toString();
      }
    }
    return HivePushNotification(
      private_id: map['private_id'] ?? 0.0,
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      to_profile: map['to_profile'] ?? '',
      data: data,
      is_read: map['is_read'] ?? false,
      image: map['image'] ?? '',
      notify_type: map['notify_type'] ?? '',
      event_id: map['event_id'] ?? 0,
      event_to: map['event_to'] ?? '',
      event_name: map['event_name'] ?? '',
      actor_name: map['actor_name'] ?? '',
      actor_profile_id: map['actor_profile_id'] ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, HivePushNotification obj) {
    writer.write({
      'private_id': obj.private_id,
      'id': obj.id,
      'title': obj.title,
      'body': obj.body,
      'to_profile': obj.to_profile,
      'data': obj.data,
      'is_read': obj.is_read,
      'image': obj.image,
      'notify_type': obj.notify_type,
      'event_id': obj.event_id,
      'event_to': obj.event_to,
      'event_name': obj.event_name,
      'actor_name': obj.actor_name,
      'actor_profile_id': obj.actor_profile_id,
    });
  }
}