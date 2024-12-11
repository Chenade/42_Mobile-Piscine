import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/modal/openDiaryEntry.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/google.dart';
import '../services/firebase_diary.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
	return Scaffold(
		backgroundColor: Colors.transparent,
	  body: Column(
		children: [
    TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      }, // Disable other formats
      selectedDayPredicate: (day) {
        // DateTime? selectedDay;
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
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
				stream: FirebaseDiaryService.getDiaryEntriesByDate(_selectedDay ?? DateTime.now()),
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
              trailing: Text(feeling),
							leading: IconButton(
								icon: const Icon(Icons.remove_red_eye),
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
		],
	  ),
	);
  }
}
