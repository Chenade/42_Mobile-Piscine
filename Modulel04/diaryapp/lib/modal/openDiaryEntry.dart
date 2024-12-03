
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_diary.dart';

// open a dialog to create a diary entry
void openDiaryEntry(BuildContext context, String? docID, String? title, String? content, String? feeling, Timestamp? createdAt) {
	final TextEditingController titleController = TextEditingController();
	final TextEditingController contentController = TextEditingController();
	final TextEditingController feelingController = TextEditingController();
	if (title != null) { titleController.text = title; }
	if (content != null) { contentController.text = content; }
	if (feeling != null) { feelingController.text = feeling; }
	showDialog(
		context: context,
		builder: (BuildContext context) {
		return AlertDialog(
			title: Text((docID == null) ? 'Create Diary Entry' : 'Edit Diary Entry'),
			content: Column(
			mainAxisSize: MainAxisSize.min,
			mainAxisAlignment: MainAxisAlignment.start,
			children: <Widget>[
        // Divider
        Container(
          height: 1,
          color: Colors.black,
          margin: const EdgeInsets.symmetric(horizontal: 20),
        ),
        const SizedBox(height: 20),
				const Text('<Feeling>', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey), textAlign: TextAlign.left),
				TextField(
				decoration: const InputDecoration(hintText: 'How are you feeling today?'),
				controller: feelingController,
				),
				const SizedBox(height: 10),
				const Text('<Title>', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey), textAlign: TextAlign.left),
				TextField(
				decoration: const InputDecoration(hintText: 'Title'),
				controller: titleController,
				),
				const SizedBox(height: 10),
				const Text('<Content>', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey), textAlign: TextAlign.left),
				TextField(
					minLines: 5,
					maxLines: 10,
					decoration: const InputDecoration(hintText: 'Content'),
					controller: contentController,
				),
				const SizedBox(height: 10),
				Text((createdAt != null) ? 'Created at: ${createdAt.toDate().toString()}' : ''),
			],
			),
			actions: <Widget>[
				if (docID != null)
					ElevatedButton(
						onPressed: () {
							FirebaseDiaryService.deleteDiaryEntry(docID);
							Navigator.of(context).pop();
						},
						child: const Text('Delete'),
					),
			ElevatedButton(
				onPressed: () {
					if (docID != null) {
						FirebaseDiaryService.updateDiaryEntry(
							docID,
							titleController.text,
							contentController.text,
							feelingController.text,
						);
					} else {
						FirebaseDiaryService.createDiaryEntry(
							titleController.text,
							contentController.text,
							feelingController.text,
						);
					}
					titleController.clear();
					contentController.clear();
					Navigator.of(context).pop();
				},
				child: const Text('Save'),
			),
			],
		);
		},
	);
}
