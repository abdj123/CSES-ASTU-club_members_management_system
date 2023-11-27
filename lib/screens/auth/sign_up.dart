import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_members_management_system/screens/pages/home_page.dart';
import 'package:club_members_management_system/shared_preferance/shared_preference.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

bool isPressed = true;
bool others = false;
bool passwd = true;

String? fnameError, lnameError, emailError, passwordError;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool checked = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();

    super.dispose();
  }

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            // Image.asset('assets/logo.png'),
            const Text(
              "Let's get you set up",
              style: TextStyle(
                  fontSize: 20,
                  // color: Color(0xff2E2E2E),
                  fontWeight: FontWeight.w500),
            ),
            const Text(
              "Create an account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 38,
            ),
            reusableTextField(
                "First Name",
                Icons.person_outline,
                null,
                others,
                firstnameController,
                TextInputType.text,
                validateFirstName,
                fnameError),
            reusableTextField(
                "Last Name",
                Icons.person_outline,
                null,
                others,
                lastnameController,
                TextInputType.text,
                validateLastName,
                lnameError),
            reusableTextField(
                "Email",
                Icons.email_outlined,
                null,
                others,
                emailController,
                TextInputType.emailAddress,
                validateEmail,
                emailError),
            reusableTextField(
                "Password",
                Icons.lock_outline,
                Icons.visibility_off_outlined,
                passwd,
                passwordController,
                TextInputType.text,
                validatePassword,
                passwordError),
            Container(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: checked,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onChanged: (value) {
                    setState(() {
                      checked = !checked;
                    });
                  },
                ),
                const Text(
                  maxLines: 3,
                  "By continuing you accept our Privacy\n Policy and Term of Use",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                //
                if (checked) {
                  // register();
                  registerToFb();
                } else {
                  Flushbar(
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                    titleSize: 20,
                    messageSize: 17,
                    backgroundColor: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    message: "you have to accept terms and conditions",
                    duration: const Duration(seconds: 5),
                  ).show(context);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                width: 206,
                height: 54,
                decoration: BoxDecoration(
                    color: const Color(0xff1F212D),
                    borderRadius: BorderRadius.circular(15)),
                child: const Center(
                  child: Text(
                    "Signup",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
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
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LogIn(),
                      ),
                    );
                  },
                  child: const Text(" Login",
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
              height: 37,
            )
          ],
        ),
      ),
    );
  }

  Future<void> registerToFb() async {
    firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
        .then((result) {
      final firestore = FirebaseFirestore.instance;
      firestore.collection("users").add({
        "email": emailController.text,
        "first_name": firstnameController.text,
        "last_name": lastnameController.text,
        "role": "user",
        "uid": result.user!.uid
      }).then((res) {
        UserPreferences.setLogin(true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
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
    });
  }

  Container reusableTextField(
      String hintText,
      IconData icons,
      IconData? suffixicon,
      bool hide,
      TextEditingController controller,
      TextInputType keybordtype,
      String? Function(String?)? validator,
      String? errorMessage) {
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
                    primary: const Color(0xff2E2E2E40),
                    secondary: Colors.white),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: errorMessage != null
                      ? Colors.red[50]
                      : secondbackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: controller,
                  obscureText: hide,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    errorText: errorMessage,
                    prefixIcon: Icon(
                      icons,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (suffixicon != null) {
                              isPressed = !isPressed;
                              passwd = !passwd;
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
                  validator: validator,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      fnameError = 'First name is required';
      return fnameError;
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      lnameError = 'Last name is required';
      return lnameError;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value != null && !value.contains('@') || !value!.contains('.')) {
      emailError = "Enter a valid Email";
      return emailError;
    } else {
      emailError = null;
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value != null && value.isEmpty) {
      passwordError = 'Enter a password';
      return passwordError;
    } else if (value!.length < 8) {
      passwordError = 'password length can\'t be lessthan 8';
      return passwordError;
    } else {
      passwordError = null;
      return null;
    }
  }
}
