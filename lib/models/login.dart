import 'package:isar/isar.dart';

part 'login.g.dart';

@Collection()
class Login {
  Id isarId = Isar.autoIncrement;

  @Index()
  String serverUrl;
  String username;
  String password = "";

  Login({
    required this.serverUrl,
    required this.username,
    this.password = "",
  });
}
