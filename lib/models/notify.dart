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

