import 'package:isar/isar.dart';

part 'email.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? name;
  String? surname;

  int? age;
}


