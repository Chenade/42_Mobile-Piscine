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
		// appBar: AppBar(title: const Text('Welcome to My Diary')),
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
				Text(user?.email ?? ""),
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
		const SizedBox(height: 20),
		Container(
			height: 1,
			color: Colors.grey,
			margin: const EdgeInsets.symmetric(horizontal: 20),
		),
		const SizedBox(height: 20),
		// Diary List
		Flexible(
			child: StreamBuilder(
				stream: FirebaseDiaryService.getDiaryEntries(),
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
						Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
						String title = data['title'] ?? '';
						String content = data['content'] ?? '';
						String feeling = data['feeling'] ?? '';
						Timestamp createdAt = data['created_at'];
						return Card(
							child: ListTile(
							title: Text(title),
							subtitle: Text("Created at: ${createdAt.toDate().toString()}"),
							trailing: IconButton(
								icon: const Icon(Icons.settings),
								onPressed: () => openDiaryEntry(context, docID, title, content, feeling, createdAt),
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
				)
				),
		const SizedBox(height: 20),

		]));
}
}
