import '../model/participant.dart';
import 'participant_repository.dart';

class MockParticipantRepository implements ParticipantRepository {
  final List<Participant> _participants = [
    Participant(bib: '101', name: 'Alice Smith', gender: 'Male', age: 20),
    Participant(bib: '102', name: 'Bob Johnson', gender: 'Female', age: 24),
    Participant(bib: '103', name: 'Charlie Brown', gender: 'Male', age: 25),
    Participant(bib: '104', name: 'Diana Lee', gender: 'Female', age: 20),
    Participant(bib: '105', name: 'Eve Williams', gender: 'Male', age: 18),
    Participant(bib: '106', name: 'John Son', gender: 'Male', age: 29),
    Participant(bib: '107', name: 'Eva Jame', gender: 'Female', age: 30),
    Participant(bib: '108', name: 'Justin Bieber', gender: 'Male', age: 19),
    Participant(bib: '109', name: 'Selena Gomez', gender: 'Female', age: 19),
    Participant(bib: '1010', name: 'Taloy Swift', gender: 'Male', age: 32),
    Participant(bib: '1010', name: 'Taloy Swift', gender: 'Male', age: 30),
    Participant(bib: '1011', name: 'James Arthurs', gender: 'Male', age: 20),
    Participant(bib: '1012', name: 'Chris Brown', gender: 'Female', age: 21),
    Participant(bib: '1013', name: 'Lyly Saha', gender: 'Male', age: 18),
    Participant(bib: '1014', name: 'Billie Eilish', gender: 'Female', age: 24),
    Participant(bib: '1015', name: 'Sarah Ish', gender: 'Male', age: 28),
    Participant(bib: '1016', name: 'Lame Prose', gender: 'Male', age: 27),
    Participant(bib: '1017', name: 'Goo Emme', gender: 'Female', age: 33),
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
