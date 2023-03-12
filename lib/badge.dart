import 'User.dart';

class Badges {
  String name;
  String description;
  Function(User user) isEarned;

  Badges(
      {required this.name, required this.description, required this.isEarned});
}
