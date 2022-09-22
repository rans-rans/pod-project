// ignore_for_file: sort_child_properties_last

import "package:flutter/material.dart";

class HelpPage extends StatelessWidget {
  static const routeName = '/help-page';
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Text(
                    "ABOUT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 135, 184, 162),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(
                    "CREATING A POLL",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  """1. First add participants to the list. Each candidate must have a name and a picture(either taken by camera or from storage). The party of the candidate is an optional field. At least two participants should be added\n\n2. After, that set the time the polls should start and also the end time which should be more than 20 mins. Add participant code so that each voter will be authenticated to vote. This can be added by typing them one by one or read from a ".txt" file from your storage. Anyone with one of these codes together with the poll-id will be able to vote in your poll. NOTE: Remember to copy the poll-id which is a unique code that identifies your poll.\n\n 3. After that click on done. Submit to finish the creation.\n
                """,
                  style: TextStyle(fontSize: 20, height: 2),
                  softWrap: true,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(
                    "CASTING YOUR VOTE",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  """To participate in a poll, you will need two things. The first is the poll id and the second one is your own unique voter's code given to you by your admin. This code must be part of the participant codes when the the admin was creating the poll. After voting, you will not be able to vote with the same vote/participant code again\n
                """,
                  style: TextStyle(fontSize: 20, height: 2),
                  softWrap: true,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(
                    "CHECKING THE RESULTS AND MONITORING THE POLL",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  """"Monitoring of polls can be done only be the admin of the poll. To monitor a poll, you will need to have the admin id of that specific poll. With that you can monitor the progress and vote count of each of the candidates.\n Participants can only see the results only if after the poll has ended after verifying with the poll id and their voter code\n
                """,
                  style: TextStyle(fontSize: 20, height: 2),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
