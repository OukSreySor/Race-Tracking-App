import 'package:uuid/uuid.dart';

class Participant {
  final String id;
  final String bib;
  final String name;
  final String gender;
  final int age;

  Participant({
    String? id,
    required this.bib,
    required this.name,
    required this.gender,
    required this.age,
    }): id = id ?? const Uuid().v4();
}
