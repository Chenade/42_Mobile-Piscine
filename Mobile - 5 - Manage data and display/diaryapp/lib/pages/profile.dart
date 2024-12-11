import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/modal/openDiaryEntry.dart';
import 'package:flutter/material.dart';
import '../services/google.dart';
import '../services/firebase_diary.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = GoogleSignInService.currentUser;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(children: [
          // User Information
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
                radius: 40,
              ),
              const SizedBox(width: 20),
              Column(children: <Widget>[
                const SizedBox(height: 10),
                Text(user?.displayName ?? '',
                    style: const TextStyle(fontSize: 20)),
                // Text(user?.email ?? ""),
                StreamBuilder(
                    stream: FirebaseDiaryService.getDairyCount(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List diaryEntries = snapshot.data!.docs;
                        return Text(
                            "${diaryEntries.length.toString()} Entries in Total",
                            style: const TextStyle(fontSize: 15));
                      } else {
                        return const Text('0 Entry',
                            style: TextStyle(fontSize: 15));
                      }
                    }),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await GoogleSignInService.signOut();
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('Sign Out'),
                ),
              ]),
            ],
          ),
          // Divider
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.grey,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 10),
          // Diary List
          const Text('Your last two entries:',
              style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),
          Flexible(
              child: StreamBuilder(
                  stream: FirebaseDiaryService.getDiaryTwoEntries(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List diaryEntries = snapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: diaryEntries.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = diaryEntries[index];
                          String docID = doc.id;
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          String title = data['title'] ?? '';
                          String content = data['content'] ?? '';
                          String feeling = data['feeling'] ?? '';
                          Timestamp createdAt = data['created_at'];
                          return Card(
                            child: ListTile(
                              title: Text(title),
                              subtitle: Text(
                                  "Created at: ${createdAt.toDate().toString()}"),
                              trailing: Text(feeling),
                              leading: IconButton(
                                icon: const Icon(Icons.remove_red_eye),
                                onPressed: () => openDiaryEntry(context, docID,
                                    title, content, feeling, createdAt),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }
                  //
                  )),
          // Divider
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 10),
          const Text('Your Feelings:',
              style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          Flexible(
              child: StreamBuilder(
                  stream: FirebaseDiaryService.getAllDiaryEntries(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List diaryEntries = snapshot.data!.docs;

                      mapFeelings(List diaryEntries) {
                        int count = 0;
                        Map<String, int> feelings = {};
                        for (var entry in diaryEntries) {
                          count += 1;
                          Map<String, dynamic> data =
                              entry.data() as Map<String, dynamic>;
                          String feeling = data['feeling'] ?? '';
                          if (feelings.containsKey(feeling)) {
                            feelings[feeling] = feelings[feeling]! + 1;
                          } else {
                            feelings[feeling] = 1;
                          }
                        }

                        for (var key in feelings.keys) {
                          feelings[key] =
                              (feelings[key]! / count * 100).round();
                        }

                        feelings = Map.fromEntries(feelings.entries.toList()
                          ..sort((e1, e2) => e2.value.compareTo(e1.value)));
                        return feelings;
                      }

                      Map<String, int> feelings = mapFeelings(diaryEntries);
                      // return blocks to display feelings
                      return Column(
                        children: feelings.keys.map((feeling) {
                          return Card(
                            child: ListTile(
                              title: Text(feeling),
                              trailing:
                                  Text("${feelings[feeling].toString()}%"),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }
                  //
                  ))
        ]));
  }
}
