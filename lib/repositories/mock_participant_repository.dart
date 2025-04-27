import '../model/participant.dart';
import 'participant_repository.dart';

class MockParticipantRepository implements ParticipantRepository {
  final List<Participant> _participants = [
    Participant(bib: '101', name: 'Alice Smith', gender: 'Male'),
    Participant(bib: '102', name: 'Bob Johnson', gender: 'Female'),
    Participant(bib: '103', name: 'Charlie Brown', gender: 'Male'),
    Participant(bib: '104', name: 'Diana Lee', gender: 'Female'),
    Participant(bib: '105', name: 'Eve Williams', gender: 'Male'),
    Participant(bib: '106', name: 'John Son', gender: 'Male'),
    Participant(bib: '107', name: 'Eva Jame', gender: 'Female'),
    Participant(bib: '108', name: 'Justin Bieber', gender: 'Male'),
    Participant(bib: '109', name: 'Selena Gomez', gender: 'Female'),
    Participant(bib: '1010', name: 'Taloy Swift', gender: 'Male'),
    Participant(bib: '1011', name: 'James Arthurs', gender: 'Male'),
    Participant(bib: '1012', name: 'Chris Brown', gender: 'Female'),
    Participant(bib: '1013', name: 'Lyly Saha', gender: 'Male'),
    Participant(bib: '1014', name: 'Billie Eilish', gender: 'Female'),
    Participant(bib: '1015', name: 'Sarah Ish', gender: 'Male'),
    Participant(bib: '1016', name: 'Lame Prose', gender: 'Male'),
    Participant(bib: '1017', name: 'Goo Emme', gender: 'Female'),
  ];

  @override
  List<Participant> getParticipants() {
    return _participants;
  }

  @override
  void addParticipant(Participant participant) {
    _participants.add(participant);
  }
}
