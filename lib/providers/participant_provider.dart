import 'package:flutter/material.dart';
import '../model/participant.dart';

class ParticipantProvider with ChangeNotifier {
  //final ParticipantRepository repository;
  final List<Participant> _participants = [];

  // ParticipantProvider(){
  //   fetchParticipants();
  // }

  List<Participant> get participants => _participants;

  // void fetchParticipants() {
  //   _participants = repository.getParticipants();
  //   notifyListeners();
  // }

  void addParticipant(Participant participant) {
    _participants.add(participant);
    notifyListeners();
  }

  void updateParticipant(String id, Participant updatedParticipant) {
    final index = _participants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _participants[index] = updatedParticipant;
      notifyListeners();
    }
  }

  void removeParticipant(String id) {
    _participants.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  bool isBibAlreadyUsed (String bib) {
    return _participants.any((participant) => participant.bib == bib);
  }
  
  bool get hasParticipants => _participants.isNotEmpty;
}
