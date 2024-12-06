import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_diary.dart';

// open a dialog to create a diary entry
class DiaryEntryDialog extends StatefulWidget {
  final String? docID;
  final String? title;
  final String? content;
  final String? feeling;
  final Timestamp? createdAt;

  const DiaryEntryDialog(
      {super.key,
      this.docID,
      this.title,
      this.content,
      this.feeling,
      this.createdAt});

  @override
  _DiaryEntryDialogState createState() => _DiaryEntryDialogState();
}

class _DiaryEntryDialogState extends State<DiaryEntryDialog> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController feelingController;
  late String dropdownValue;
  final List<String> list = <String>[
    'Happy',
    'Sad',
    'Angry',
    'Excited',
    'Tired',
    'Bored',
    'Anxious',
    'Stressed',
    'Relaxed',
    'Confused'
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    feelingController = TextEditingController(text: widget.feeling);
    dropdownValue = widget.feeling != null && list.contains(widget.feeling!)
        ? widget.feeling!
        : 'Happy';
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    feelingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          (widget.docID == null) ? 'Create Diary Entry' : 'Edit Diary Entry'),
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
          const Text('<Feeling>',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              textAlign: TextAlign.left),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            //set width to full
            isExpanded: true,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          const Text('<Title>',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              textAlign: TextAlign.left),
          TextField(
            decoration: const InputDecoration(hintText: 'Title'),
            controller: titleController,
          ),
          const SizedBox(height: 10),
          const Text('<Content>',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              textAlign: TextAlign.left),
          TextField(
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(hintText: 'Content'),
            controller: contentController,
          ),
          const SizedBox(height: 10),
          Text((widget.createdAt != null)
              ? 'Created at: ${widget.createdAt!.toDate().toString()}'
              : ''),
        ],
      ),
      actions: <Widget>[
        if (widget.docID != null)
          ElevatedButton(
            onPressed: () {
              FirebaseDiaryService.deleteDiaryEntry(widget.docID!);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ElevatedButton(
          onPressed: () {
            if (widget.docID != null) {
              FirebaseDiaryService.updateDiaryEntry(
                widget.docID!,
                titleController.text,
                contentController.text,
                dropdownValue,
              );
            } else {
              FirebaseDiaryService.createDiaryEntry(
                titleController.text,
                contentController.text,
                dropdownValue,
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
  }
}

void openDiaryEntry(BuildContext context, String? docID, String? title,
    String? content, String? feeling, Timestamp? createdAt) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DiaryEntryDialog(
        docID: docID,
        title: title,
        content: content,
        feeling: feeling,
        createdAt: createdAt,
      );
    },
  );
}
