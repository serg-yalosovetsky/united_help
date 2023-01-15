import 'package:hive/hive.dart';


class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}


@HiveType(typeId: 0)
class HivePushNotification extends HiveObject {

  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String body;

  @HiveField(3)
  late String data_title;

  @HiveField(4)
  late String data_body;
}

class HivePushNotificationAdapter extends TypeAdapter<HivePushNotification> {
  @override
  final typeId = 0;

  @override
  HivePushNotification read(BinaryReader reader) {
    var map = reader.read();
    return HivePushNotification()
      ..id = map['id']
      ..title = map['title']
      ..body = map['body']
      ..data_title = map['data_title']
      ..data_body = map['data_body'];
  }

  @override
  void write(BinaryWriter writer, HivePushNotification obj) {
    writer.write({
      'id': obj.id,
      'title': obj.title,
      'body': obj.body,
      'data_title': obj.data_title,
      'data_body': obj.data_body,
    });
  }
}