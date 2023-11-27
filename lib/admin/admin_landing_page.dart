import 'package:club_members_management_system/admin/post_event.dart';
import 'package:club_members_management_system/admin/report_page.dart';
import 'package:club_members_management_system/screens/pages/home_page.dart';
import 'package:flutter/material.dart';

class AdminLanding extends StatefulWidget {
  const AdminLanding({Key? key}) : super(key: key);

  @override
  State<AdminLanding> createState() => _AdminLandingState();
}

class _AdminLandingState extends State<AdminLanding> {
  int currentTab = 0;
  Color kActiveColor = const Color(0xff53E88B);

  final List<Widget> screens = [
    const HomePage(),
    const PostEvent(),
    const ReportPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomePage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageStorage(
        bucket: bucket,
        child: screens[currentTab],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentTab = 1;
          });
        },
        tooltip: "Add Event",
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(),
          child: BottomNavigationBar(
              elevation: 8.0,
              selectedItemColor: kActiveColor,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentTab,
              onTap: (int index) {
                setState(() {
                  currentTab = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.home),
                  icon: Opacity(opacity: 0.25, child: Icon(Icons.home)),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                    color: Colors.transparent,
                  ),
                  label: "Add Task",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.settings),
                  icon: Opacity(opacity: 0.25, child: Icon(Icons.settings)),
                  label: "Setting",
                ),
              ])),
    );
  }
}
