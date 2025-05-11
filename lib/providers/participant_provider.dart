import 'package:flutter/material.dart';
import 'package:race_tracking_app/services/database_service.dart';
import '../model/participant.dart';

class ParticipantProvider with ChangeNotifier {
  List<Participant> _participants = [];
  final Set<String> _markedBibs = {};

  ParticipantProvider(){
    loadParticipants();
  }

  List<Participant> get participants => _participants;
  Set<String> get markedBibs => _markedBibs;


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

  void markBib(String bib) {
    _markedBibs.add(bib);
    notifyListeners();
  }

  void unmarkBib(String bib) {
    _markedBibs.remove(bib);
    notifyListeners();
  }

  bool isMarked(String bib) => _markedBibs.contains(bib);

  bool isBibAlreadyUsed (String bib) {
    return _participants.any((participant) => participant.bib == bib);
  }
  
  bool get hasParticipants => _participants.isNotEmpty;
}
