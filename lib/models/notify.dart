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
    this.id = 0,
    this.title = '',
    this.body = '',
    this.data_title = '',
    this.data_body = '',
    this.is_read = false,
    this.image = '',

  });
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

  @HiveField(5)
  late bool is_read;

  @HiveField(6)
  late String image;
}

class HivePushNotificationAdapter extends TypeAdapter<HivePushNotification> {
  @override
  final typeId = 0;

  @override
  HivePushNotification read(BinaryReader reader) {
    var map = reader.read();
    return HivePushNotification(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      data_title: map['data_title'],
      data_body: map['data_body'],
      is_read: map['is_read'] ?? false,
      image: map['image'],
    );
  }

  @override
  void write(BinaryWriter writer, HivePushNotification obj) {
    writer.write({
      'id': obj.id,
      'title': obj.title,
      'body': obj.body,
      'data_title': obj.data_title,
      'data_body': obj.data_body,
      'is_read': obj.is_read,
      'image': obj.image,
    });
  }
}