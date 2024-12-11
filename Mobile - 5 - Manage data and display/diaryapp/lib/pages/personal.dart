import 'package:diaryapp/modal/openDiaryEntry.dart';
import 'package:diaryapp/pages/agenda.dart';
import 'package:diaryapp/pages/profile.dart';
import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to My Diary')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openDiaryEntry(context, null, null, null, null, null),
        child: const Icon(Icons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     '../assets/background.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    ProfilePage(),
                    AgendaPage(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: 
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.person),
              text: 'Profile',
            ),
            Tab(
              icon: Icon(Icons.calendar_today),
              text: 'Agenda',
            ),
          ],
        ),
    );
  }
}