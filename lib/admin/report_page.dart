import 'package:club_members_management_system/screens/auth/login.dart';
import 'package:club_members_management_system/screens/pages/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../../shared_preferance/shared_preference.dart';
import '../provider/event_provider.dart';
import '../screens/pages/detail_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? passwordError;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> getEvents() async {
    final recipeProvider = Provider.of<EventProvider>(context, listen: false);
    await recipeProvider.getEvent();
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Reports",
                style: TextStyle(color: Colors.black),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AccountPage(),
                    ));
                  },
                  icon: const Icon(Icons.edit_note_sharp)),
              IconButton(
                  onPressed: () {
                    firebaseAuth.signOut();

                    Navigator.pop(context);

                    UserPreferences.setLogin(false);

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LogIn(),
                    ));
                  },
                  icon: const Icon(Icons.exit_to_app_outlined))
            ],
          )),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Number of Members: ${eventProvider.userCount}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: ListView.builder(
                    itemCount: eventProvider.events.length,
                    itemBuilder: (context, index) {
                      var event = eventProvider.events[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Discription(event: event),
                          ));
                        },
                        child: Column(
                          children: [
                            Text(
                              "Event: ${event.title}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            PieChart(
                              dataMap: {
                                "setted a reminder": event.reminder.toDouble(),
                                "not setted reminder":
                                    (eventProvider.userCount - event.reminder)
                                        .toDouble()
                              },
                              animationDuration:
                                  const Duration(milliseconds: 800),
                              chartLegendSpacing: 32,
                              chartRadius: 80,
                              colorList: [Colors.blueGrey, Colors.yellow],
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 32,
                              centerText: "HYBRID",
                              legendOptions: const LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.right,
                                showLegends: true,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future newPassword() async {
    if (passwordController.text == confirmController.text) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ));

      firebaseAuth.currentUser!
          .updatePassword(passwordController.text)
          .then((_) {
        Navigator.pop(context);
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
          titleSize: 20,
          messageSize: 17,
          borderRadius: BorderRadius.circular(8),
          message: "Successfully changed password",
          duration: const Duration(seconds: 5),
        ).show(context);

        passwordController.clear();
        confirmController.clear();
      }).catchError((error) {
        Navigator.pop(context);
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
          titleSize: 20,
          messageSize: 17,
          borderRadius: BorderRadius.circular(8),
          message: "Password can't be changed$error",
          duration: const Duration(seconds: 5),
        ).show(context);
      });
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
        titleSize: 20,
        messageSize: 17,
        borderRadius: BorderRadius.circular(8),
        message: "Password should be the same",
        duration: const Duration(seconds: 5),
      ).show(context);
    }
  }

  Container reusableTextField(
    String hintText,
    TextEditingController controller,
  ) {
    Color secondbackgroundColor = Theme.of(context).cardColor;
    final inputBorder = OutlineInputBorder(
        // borderSide: Divider.createBorderSide(context),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(10));
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ThemeData().colorScheme.copyWith(
                    // ignore: use_full_hex_values_for_flutter_colors
                    primary: const Color(0xFF2E2E2E40),
                    secondary: Colors.white),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: secondbackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: controller,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    fillColor: secondbackgroundColor,
                    filled: true,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    errorStyle: const TextStyle(fontSize: 0.01),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: textTheme.displayMedium
                      ?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
