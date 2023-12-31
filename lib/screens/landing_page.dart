import 'package:club_members_management_system/screens/pages/account_page.dart';
import 'package:club_members_management_system/screens/pages/contact_page.dart';
import 'package:club_members_management_system/screens/pages/home_page.dart';
import 'package:club_members_management_system/screens/pages/practice_page.dart';
import 'package:club_members_management_system/screens/pages/todo_page.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int currentTab = 0;
  Color kActiveColor = const Color(0xff53E88B);

  final List<Widget> screens = [
    const HomePage(),
    const ParcticePage(),
    const TodoPage(),
    const ChatPage(),
    const AccountPage(),
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
            currentTab = 2;
          });
        },
        tooltip: "Add Task",
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
                  activeIcon: Icon(Icons.computer_rounded),
                  icon: Opacity(
                      opacity: 0.25, child: Icon(Icons.computer_rounded)),
                  label: "Practice",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                    color: Colors.transparent,
                  ),
                  label: "Add Task",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.live_help_outlined),
                  icon: Opacity(
                    opacity: 0.25,
                    child: Icon(Icons.live_help_outlined),
                  ),
                  label: "Contact Us",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.account_circle_outlined),
                  icon: Opacity(
                      opacity: 0.25,
                      child: Icon(Icons.account_circle_outlined)),
                  label: "Profile",
                ),
              ])),
    );
  }
}
