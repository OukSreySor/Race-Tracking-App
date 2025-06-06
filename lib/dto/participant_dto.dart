import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_tracking_app/model/participant.dart';

class ParticipantDto {
  static Participant fromJson(Map<String, dynamic> json, String id) {
    return Participant(
      id: id,
      bib: json['bib'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String,
      age: (json['age'] as num).toInt(),
      createdAt: (json['createdAt']) as Timestamp,
    );
  }

  static Map<String, dynamic> toJson(Participant participant) {
    return {
      'bib': participant.bib,
      'name': participant.name,
      'gender': participant.gender,
      'age': participant.age,
      'createdAt': participant.createdAt
    };
  }
}