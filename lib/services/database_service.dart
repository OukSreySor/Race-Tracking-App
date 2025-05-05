import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_tracking_app/dto/participant_dto.dart';
import 'package:race_tracking_app/model/participant.dart';

const String PARTICIPANT_COLLECTION_REF = "participants";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference<Participant> _participantsRef;

  DatabaseService() {
    _participantsRef = _firestore.collection(PARTICIPANT_COLLECTION_REF).withConverter<Participant>(
      fromFirestore: (snapshot, _) {
        final data = snapshot.data();
        return ParticipantDto.fromJson(data!, snapshot.id);  
      },
    
      toFirestore: (participant, _) => ParticipantDto.toJson(participant));
  }

  // Add a participant
  Future<void> addParticipant(Participant participant) async {
    try {
      await _participantsRef.add(participant); 
    } catch (e) {
      print("Error adding participant: $e");
    }
  }

  // Get all participants
  Future<List<Participant>> getParticipants() async {
    try {
      QuerySnapshot<Participant> snapshot = await _participantsRef.get();
      return snapshot.docs.map((doc) => doc.data()).toList(); 
    } catch (e) {
      print("Error fetching participants: $e");
      return [];
    }
  }

  // Update a participant
  Future<void> updateParticipant(String participantId, Participant participant) async {
    try {
      await _participantsRef.doc(participantId).set(participant); 
    } catch (e) {
      print("Error updating participant: $e");
    }
  }

  // Delete a participant
  Future<void> deleteParticipant(String participantId) async {
    try {
      await _participantsRef.doc(participantId).delete();
    } catch (e) {
      print("Error deleting participant: $e");
    }
  }
}