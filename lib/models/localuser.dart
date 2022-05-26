import 'package:objectbox/objectbox.dart';

@Entity()
class LocalUser {
  int id;
  int userId;
  String name;
  String imgUrl;

  LocalUser({
    this.id = 0,
    required this.userId,
    required this.imgUrl,
    required this.name,
  });
}
