import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String registrationDate;

  @HiveField(3)
  int score;

  UserProfile({
    required this.name,
    required this.email,
    required this.registrationDate,
    required this.score,
  });
}