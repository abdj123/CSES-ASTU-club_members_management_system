import 'package:club_members_management_system/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import '../../shared_preferance/shared_preference.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? passwordError;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
                "Change Password",
                style: TextStyle(color: Colors.black),
              ),
              const Spacer(),
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
              const SizedBox(
                height: 80,
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Create new Password",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 52,
              ),
              const Text("Password", style: TextStyle(color: Colors.grey)),
              reusableTextField("Password", passwordController),
              const SizedBox(
                height: 18,
              ),
              const Text("Confirm Password",
                  style: TextStyle(color: Colors.grey)),
              reusableTextField("Confirm Password", confirmController),
              const SizedBox(
                height: 27,
              ),
              GestureDetector(
                onTap: () {
                  newPassword();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 17, right: 24),
                  child: Container(
                    width: 206,
                    height: 54,
                    decoration: const BoxDecoration(
                        color: Color(0xff1F212D),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
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
