import 'package:uuid/uuid.dart';

class Participant {
  final String id;
  final String bib;
  final String name;
  final String gender;
  final int age;
  bool isMarked;

  Participant({
    String? id,
    required this.bib,
    required this.name,
    required this.gender,
    required this.age,
    this.isMarked = false,
    }): id = id ?? const Uuid().v4();
}
