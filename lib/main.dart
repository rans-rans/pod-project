import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";

import 'package:pod/pages/add_voters_page.dart';
import 'package:pod/pages/create_poll_page.dart';
import 'package:pod/pages/help_page.dart';
import 'package:pod/pages/result_page.dart';
import 'package:pod/providers/polls.dart';
import 'package:provider/provider.dart';

import 'pages/homepage.dart';
import 'pages/monitor_poll_search.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Polls(),
        ),
      ],
      child: MaterialApp(
        title: "P.O.D",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 94, 74),
        ),
        home: const HomePage(),
        routes: {
          CreatePollPage.routeName: (context) => const CreatePollPage(),
          MonitorPollSearch.routeName: (context) => const MonitorPollSearch(),
          AddVotersPage.routeName: (context) => const AddVotersPage(),
          ResultsPage.routeName: (context) => const ResultsPage(),
          HelpPage.routeName: (context) => const HelpPage(),
        },
      ),
    );
  }
}
