import 'dart:io';

class Candidate {
  String name;
  String party;
  int id;
  int voteCount = 0;
  File? candidateImage;
  String? imageUrl;

  Candidate({
    required this.name,
    required this.party,
    required this.id,
    this.candidateImage,
    this.imageUrl,
    voteCount,
  });
}
