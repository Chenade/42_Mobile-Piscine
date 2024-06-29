import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final TabController tabController;

  CustomBottomNavBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromRGBO(0, 0, 0, 0.9),
      child: TabBar(
        controller: tabController,
        indicatorColor: Colors.orange,
        indicatorWeight: 4.0,
        labelColor: Colors.orange,
        unselectedLabelColor: Colors.white,
        tabs: const [
          Tab(
            icon: Icon(Icons.settings),
            text: "Currently",
          ),
          Tab(
            icon: Icon(Icons.today_sharp),
            text: "Today",
          ),
          Tab(
            icon: Icon(Icons.calendar_month_sharp),
            text: "Weekly",
          ),
        ],
      ),
    );
  }
}
