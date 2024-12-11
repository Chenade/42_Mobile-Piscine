import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final TabController tabController;

  CustomBottomNavBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
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
