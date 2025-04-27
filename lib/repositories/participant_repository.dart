import 'package:race_tracking_app/model/participant.dart';

abstract class ParticipantRepository {
  
  List<Participant> getParticipants();
  void addParticipant(Participant participant);
}
