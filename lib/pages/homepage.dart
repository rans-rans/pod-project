import 'package:flutter/material.dart';
import 'package:pod/pages/create_poll_page.dart';
import 'package:pod/pages/find_poll_page.dart';
import 'package:pod/pages/help_page.dart';
import 'package:pod/pages/monitor_poll_search.dart';

import 'result_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PLENTY OF DATA"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
            elevation: 10,
            tooltip: "More Options",
            enableFeedback: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                textStyle: const TextStyle(color: Colors.greenAccent),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamed(MonitorPollSearch.routeName);
                  },
                  title: const Text("Poll Monitor"),
                ),
              ),
              PopupMenuItem(
                textStyle: const TextStyle(color: Colors.greenAccent),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(ResultsPage.routeName);
                  },
                  title: const Text("Check Results"),
                ),
              ),
              PopupMenuItem(
                textStyle: const TextStyle(color: Colors.greenAccent),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(HelpPage.routeName);
                  },
                  title: const Text("About Page"),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(width: 2),
                ),
                child: Image.asset(
                  "assets/images/image.png",
                  height: 300,
                  width: double.infinity,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(
                      "assets/images/make_a_poll.jpg",
                      fit: BoxFit.fill,
                      width: 55,
                      height: 50,
                    ),
                  ),
                  title: const Text("MAKE A POLL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onTap: () =>
                      Navigator.of(context).pushNamed(CreatePollPage.routeName),
                  subtitle: const Text(
                      "Create a poll so that people can participate in"),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(25),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    "assets/images/take_part_in_poll.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                title: const Text("CAST YOUR VOTE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FindPollPage(),
                  ),
                ),
                subtitle: const Text(
                    "Participate to cast your vote to the desired person"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
