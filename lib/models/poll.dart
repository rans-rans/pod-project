import 'candidate.dart';

class Poll {
  List<Candidate> candidates;
  String name;
  DateTime startTime;
  DateTime endTime;
  String pollId;
  String adminId;
  List eligibleVotersCode;

  Poll({
    required this.candidates,
    required this.name,
    required this.adminId,
    required this.startTime,
    required this.eligibleVotersCode,
    required this.endTime,
    required this.pollId,
  });
}
