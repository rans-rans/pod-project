import 'package:flutter/material.dart';

import '../models/candidate.dart';

class CandidateChipView extends StatelessWidget {
  final List<Candidate> candidates;

  const CandidateChipView(this.candidates, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 60,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
        Radius.circular(10),
      )),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text("CANDIDATES: "),
            ...candidates
                .map(
                  (person) => GestureDetector(
                    onTap: () {
                      //  int index = candidates
                      //       .indexWhere((element) => element.id == person.id);
                      //   candidates.removeAt(index);
                    },
                    child: Center(
                        child: Container(
                      color: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(left: 5, right: 10),
                      child: Text(person.name,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          )),
                    )),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}
