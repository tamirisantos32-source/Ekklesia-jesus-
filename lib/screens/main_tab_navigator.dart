import 'package:flutter/material.dart';
import 'content_view_page.dart';

class MainTabNavigator extends StatelessWidget {
  final String userRole;

  const MainTabNavigator({Key? key, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Church Portal"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.church), text: "Worship"),
              Tab(icon: Icon(Icons.cake), text: "Birthdays"),
              Tab(icon: Icon(Icons.monetization_on), text: "Tithes"),
              Tab(icon: Icon(Icons.campaign), text: "Notices"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ContentViewPage(category: "worship", userRole: userRole),
            ContentViewPage(category: "birthdays", userRole: userRole),
            ContentViewPage(category: "tithes", userRole: userRole),
            ContentViewPage(category: "notices", userRole: userRole),
          ],
        ),
      ),
    );
  }
}
