import 'package:flutter/material.dart';
import '../model/participant.dart';
import '../repositories/participant_repository.dart';

class ParticipantProvider with ChangeNotifier {
  final ParticipantRepository repository;
  List<Participant> _participants = [];

  ParticipantProvider(this.repository){
    fetchParticipants();
  }

  List<Participant> get participants => _participants;

  void fetchParticipants() {
    _participants = repository.getParticipants();
    notifyListeners();
  }

  void addParticipant(Participant participant) {
    _participants.add(participant);
    notifyListeners();
  }

  void removeParticipant(Participant participant) {
    _participants.remove(participant);
    notifyListeners();
  }
}
