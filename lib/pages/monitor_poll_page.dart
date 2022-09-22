import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MonitorPollPage extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  const MonitorPollPage(this.stream, {Key? key}) : super(key: key);

  @override
  State<MonitorPollPage> createState() => _MonitorPollPageState();
}

class _MonitorPollPageState extends State<MonitorPollPage> {
  Future<List<Map<String, dynamic>?>> some() async {
    final something =
        await widget.stream.first.then((value) => value.docs.map((element) {
              if (!element.data().containsKey("poll-id")) {
                return element.data();
              }
            }));

    final another = something.toList();
    another.removeWhere((element) => element == null);
    return another;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Status"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List>(
          future: some(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      snapshot.data![index]["name"],
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    trailing: ValueListenableBuilder<int>(
                      valueListenable: ValueNotifier(
                        snapshot.data![index]["vote-count"],
                      ),
                      builder: (context, value, child) => Text(
                        value.toString(),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
