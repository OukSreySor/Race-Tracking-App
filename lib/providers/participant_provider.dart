import 'package:flutter/material.dart';
import 'package:race_tracking_app/services/database_service.dart';
import '../model/participant.dart';

class ParticipantProvider with ChangeNotifier {
  List<Participant> _participants = [];

  ParticipantProvider(){
    loadParticipants();
  }

  List<Participant> get participants => _participants;

  // Load all participants from the database
  Future<void> loadParticipants() async {
    _participants = await DatabaseService().getParticipants();
    notifyListeners();
  }

  // Add a new participant
  Future<void> addParticipant(Participant participant) async {
    await DatabaseService().addParticipant(participant);
    await loadParticipants();  
  }

  // Update an existing participant
  Future<void> updateParticipant(String id, Participant updatedParticipant) async {
    await DatabaseService().updateParticipant(id, updatedParticipant);
    await loadParticipants(); 
  }

  // Delete a participant
  Future<void> removeParticipant(String id) async {
    await DatabaseService().deleteParticipant(id);
    await loadParticipants();  
  }

  bool isBibAlreadyUsed (String bib) {
    return _participants.any((participant) => participant.bib == bib);
  }
  
  bool get hasParticipants => _participants.isNotEmpty;
}
