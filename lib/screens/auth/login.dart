import 'package:club_members_management_system/admin/admin_landing_page.dart';
import 'package:club_members_management_system/screens/auth/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared_preferance/shared_preference.dart';
import '../landing_page.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");

  bool isPressed = true;
  bool isPasswd = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            // Image.asset('assets/logo.png'),

            const SizedBox(
              height: 36,
            ),
            const Text(
              "Hey there,",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff2E2E2E),
                  fontWeight: FontWeight.w500),
            ),
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 108,
            ),
            reusableTextField(
              "Email",
              Icons.email_outlined,
              null,
              emailController,
              TextInputType.emailAddress,
              false,
            ),
            reusableTextField(
              "Password",
              Icons.lock_outline,
              Icons.visibility_off_outlined,
              passwordController,
              TextInputType.text,
              isPasswd,
            ),
            Container(),
            const SizedBox(
              height: 20,
            ),
            // GestureDetector(
            //   onTap: () {
            //     // Navigator.of(context).push(MaterialPageRoute(
            //     //   builder: (context) => const ForgotPassword(),
            //     // ));
            //   },
            //   child: RichText(
            //     text: const TextSpan(children: [
            //       TextSpan(
            //           text: "Forgot",
            //           style: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.w500,
            //               color: Colors.black)),
            //       TextSpan(
            //           text: " Password?",
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontSize: 14,
            //               fontWeight: FontWeight.w500))
            //     ]),
            //   ),
            // ),
            const SizedBox(
              height: 30,
            ),

            GestureDetector(
              onTap: () {
                logInToFb();
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
                      "SIGN IN",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?",
                    style: TextStyle(
                        // color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w400)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                  },
                  child: const Text(" Signup",
                      style: TextStyle(
                          color: Color(0xff53E88B),
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                )
              ],
            ),
            const SizedBox(
              height: 7,
            ),

            const SizedBox(
              height: 130,
            )
          ],
        ),
      ),
    );
  }

  void logInToFb() {
    bool isAdmin = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ));
    firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) async {
      FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: result.user!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          doc["role"] == "user"
              ? UserPreferences.setRole(false)
              : UserPreferences.setRole(true);

          await doc["role"] == "user" ? isAdmin = false : isAdmin = true;

          // Navigator.pop(context);
        });
      });
      // await
      UserPreferences.setLogin(true);
      !isAdmin
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Landing()),
            )
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminLanding()),
            );
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });

      Navigator.of(context).pop();
    });
  }

  Container reusableTextField(
    String hintText,
    IconData icons,
    IconData? suffixicon,
    TextEditingController controller,
    TextInputType keybordtype,
    bool hide,
  ) {
    Color secondbackgroundColor = Theme.of(context).cardColor;
    final inputBorder = OutlineInputBorder(
      // borderSide: Divider.createBorderSide(
      //   context,
      // ),
      borderRadius: BorderRadius.circular(10),

      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 0.7,
      ),
    );
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
                    primary: const Color(0xff2E2E2E40),
                    secondary: Colors.white),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: secondbackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  //key: formFiled,
                  obscureText: hide,
                  controller: controller,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    // errorText: errorMessage,
                    prefixIcon: Icon(
                      icons,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (suffixicon != null) {
                              isPressed = !isPressed;
                              isPasswd = !isPasswd;
                            }
                          });
                        },
                        icon: (suffixicon != null)
                            ? (isPressed)
                                ? const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.grey,
                                  )
                            : const Icon(null)),
                    // ignore: use_full_hex_values_for_flutter_colors
                    prefixIconColor: const Color(0xff2E2E2E40),
                    // ignore: use_full_hex_values_for_flutter_colors
                    iconColor: const Color(0xff2E2E2E40),
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
                  keyboardType: keybordtype,
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
