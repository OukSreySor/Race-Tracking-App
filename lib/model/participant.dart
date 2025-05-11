import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Participant {
  final String id;
  final String bib;
  final String name;
  final String gender;
  final int age;
  bool isMarked;
  final Timestamp createdAt;

  Participant({
    String? id,
    required this.bib,
    required this.name,
    required this.gender,
    required this.age,
    this.isMarked = false,
    required this.createdAt
    }): id = id ?? const Uuid().v4();

    Participant copyWith({
    String? id,
    String? bib,
    String? name,
    String? gender,
    int? age,
    bool? isMarked,
    Timestamp? createdAt,
  }) {
    return Participant(
      id: id ?? this.id,
      bib: bib ?? this.bib,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      isMarked: isMarked ?? this.isMarked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
