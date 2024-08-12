import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/cattle/cattle_maintab.dart';
import 'package:projrect_annam/cattle/menu/home.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/canteen/canteen_main_tab.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/ngo/main_tab.dart';
import 'package:projrect_annam/utils/terms_and_conditions.dart';

import 'package:projrect_annam/students/student_main_tab.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import '../const/static_data.dart';
import '../utils/size_data.dart';
import 'role_page.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({
    super.key,
  });

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  bool _isSignUp = false;

  void _toggleForm() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConst.backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(ImageConst.logo),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(10),
                      height: height * 0.5,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SignUpBar(
                              toggleForm: _toggleForm, isSignUp: _isSignUp),
                          _isSignUp ? SignUpFields() : const EmailBar(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmailBar extends StatefulWidget {
  const EmailBar({
    super.key,
  });

  @override
  State<EmailBar> createState() => _EmailBarState();
}

class _EmailBarState extends State<EmailBar> {
  bool showPassword = false;
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(hintText: 'Enter email'),
        ),
        TextField(
          onTap: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: showPassword == true
                ? Icon(Icons.remove_red_eye)
                : Icon(
                    Icons.visibility_off,
                  ),
          ),
          obscureText: showPassword,
          enableSuggestions: false,
          autocorrect: false,
        ),
        SizedBox(
          height: height * 0.08,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: CustomText(
            text: 'Forgot Password?',
          ),
        ),
        SizedBox(
          height: height * 0.04,
        ),
        TextButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
                const EdgeInsets.fromLTRB(80, 2, 80, 2)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: const BorderSide(color: Colors.orange),
              ),
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.withOpacity(0.8);
                }
                return Colors.orange;
              },
            ),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () async {
            if (emailController.text.trim().toLowerCase().isNotEmpty &&
                passwordController.text.trim().toLowerCase().isNotEmpty) {
              try {
                await FirebaseOperations.firebaseAuth
                    .signInWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
                DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
                    .collection('role')
                    .doc('role')
                    .get();
                Map<String, dynamic> res = (docSnapshot.get('role'));

                if (res
                    .containsKey(emailController.text.trim().toLowerCase())) {
                  String role = res[emailController.text.trim().toLowerCase()];

                  if (role == UserRole.student.asString) {
                    context.pushReplacement(MainTabView(
                      role: role,
                    ));
                  } else if (role == UserRole.canteenOwner.asString) {
                    try {
                      String collegeName = "";
                      CollectionReference collegeCollection =
                          FirebaseFirestore.instance.collection('college');

                      QuerySnapshot collegeSnapshot =
                          await collegeCollection.get();

                      collegeSnapshot.docs.forEach((v) {
                        Map<String, dynamic> abc =
                            v.data() as Map<String, dynamic>;
                        if (abc.containsKey(
                            FirebaseOperations.firebaseAuth.currentUser!.uid)) {
                          collegeName = v.id;
                        }
                      });
                      if (collegeName.isNotEmpty) {
                        context.push(CanteenOwner(collegeName: collegeName));
                      } else {
                        context.showSnackBar("College not found");
                      }

                      // Iterate through each document in the "college" collection
                    } catch (e) {
                      context.showSnackBar('Error checking documents: $e');
                    }
                  } else if (role == UserRole.ngo.asString) {
                    context.push(NgoMainTab());
                  } else if (role == UserRole.cattleOwner.asString) {
                    context.push(CattleOwner());
                  }
                } else {
                  context.showSnackBar("Account not found");
                }
              } catch (e) {
                context.showSnackBar(e.toString());
              }
            } else {
              context.showSnackBar("Please Fill all details");
            }
          },
          child: CustomText(
            text: 'Log In',
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class SignUpBar extends StatelessWidget {
  final VoidCallback toggleForm;
  final bool isSignUp;

  const SignUpBar({
    super.key,
    required this.toggleForm,
    required this.isSignUp,
  });

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(25),
      ),
      height: height * 0.05,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.fromLTRB(40, 1, 40, 1)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                      foregroundColor: isSignUp
                          ? WidgetStateProperty.all<Color>(Colors.orange)
                          : WidgetStateProperty.all<Color>(Colors.white),
                      backgroundColor: isSignUp
                          ? WidgetStateProperty.all<Color>(Colors.white)
                          : WidgetStateProperty.all<Color>(Colors.orange)),
                  onPressed: isSignUp ? toggleForm : null,
                  child: CustomText(
                    text: 'Log In',
                    color: isSignUp ? Colors.orange : Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.fromLTRB(40, 1, 40, 1)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                      foregroundColor: isSignUp
                          ? WidgetStateProperty.all<Color>(Colors.white)
                          : WidgetStateProperty.all<Color>(Colors.orange),
                      backgroundColor: isSignUp
                          ? WidgetStateProperty.all<Color>(Colors.orange)
                          : WidgetStateProperty.all<Color>(Colors.white)),
                  onPressed: isSignUp ? null : toggleForm,
                  child: CustomText(
                      text: 'Sign Up',
                      color: isSignUp ? Colors.white : Colors.orange),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SignUpFields extends StatefulWidget {
  SignUpFields({super.key});

  @override
  State<SignUpFields> createState() => _SignUpFieldsState();
}

class _SignUpFieldsState extends State<SignUpFields> {
  bool showPassword = false;
  bool showRetypedPassword = false;
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController retypedPasswordController = TextEditingController();

  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
    retypedPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(hintText: 'Enter email or username'),
        ),
        SizedBox(height: 10),
        TextField(
          onTap: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: showPassword == true
                ? Icon(Icons.remove_red_eye)
                : Icon(
                    Icons.visibility_off,
                  ),
          ),
          obscureText: showPassword,
          enableSuggestions: false,
          autocorrect: false,
        ),
        SizedBox(height: 10),
        TextField(
          onTap: () {
            showRetypedPassword = !showRetypedPassword;
          },
          controller: retypedPasswordController,
          decoration: InputDecoration(
            hintText: 'Re-type Password',
            suffixIcon: showRetypedPassword == true
                ? Icon(Icons.remove_red_eye)
                : Icon(
                    Icons.visibility_off,
                  ),
          ),
          obscureText: showRetypedPassword,
          enableSuggestions: false,
          autocorrect: false,
        ),
        SizedBox(
          height: 25,
        ),
        TermsOfUse(key: UniqueKey()),
        TextButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
                const EdgeInsets.fromLTRB(80, 2, 80, 2)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: const BorderSide(color: Colors.orange),
              ),
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange
                      .withOpacity(0.8); // darker shade on hover
                }
                return Colors.orange;
              },
            ),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            //  SIGN UP
            if (emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty &&
                retypedPasswordController.text.isNotEmpty) {
              if (passwordController.text != retypedPasswordController.text) {
                context.showSnackBar("The re- entered password did n't match");
              } else {
                // All correct
                context.push(RoleSeperationPage(
                  userData: {
                    'email': emailController.text.toLowerCase().trim(),
                    'password': passwordController.text.trim()
                  },
                ));
              }
            } else {
              context.showSnackBar("Enter All the Fields");
            }
          },
          child: CustomText(
            text: 'Sign Up',
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
