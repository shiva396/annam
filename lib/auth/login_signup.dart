import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/canteen_owner/canteen_main_tab.dart';
import 'package:projrect_annam/helper/helper.dart';
import 'package:projrect_annam/student/student_main_tab.dart';
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
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/img/logo.png'),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    height: 500,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                        SignUpBar(toggleForm: _toggleForm, isSignUp: _isSignUp),
                        _isSignUp ? SignUpFields() : const EmailBar(),
                        const ContinueDivider(),
                        const SocialIcons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SocialIcons extends StatelessWidget {
  const SocialIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          padding: const EdgeInsets.all(15),
          color: Colors.blueAccent,
          icon: const FaIcon(FontAwesomeIcons.facebook), // facebook icon
          iconSize: 30,
          onPressed: () {
            print("ds");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RoleSeperationPage(
                          userData: {},
                        )));
          },
        ),
        IconButton(
          padding: const EdgeInsets.all(15),
          color: Colors.blueAccent,
          icon: const FaIcon(FontAwesomeIcons.twitter), // twitter icon
          iconSize: 30,
          onPressed: () {},
        ),
        IconButton(
          padding: const EdgeInsets.all(15),
          color: Colors.orange,
          icon: const FaIcon(FontAwesomeIcons.google), // google icon
          iconSize: 30,
          onPressed: () {},
        ),
      ],
    );
  }
}

class ContinueDivider extends StatelessWidget {
  const ContinueDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 15.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text('or continue with'),
          Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(hintText: 'Enter email'),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(hintText: 'Password'),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.orange),
          ),
        ),
        SizedBox(
          height: 35,
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
                  return Colors.orange
                      .withOpacity(0.8); // darker shade on hover
                }
                return Colors.orange;
              },
            ),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () async {
            if (emailController.text.trim().toLowerCase().isNotEmpty) {
              await FirebaseOperations.firebaseAuth.signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
              DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
                  .collection('role')
                  .doc('role')
                  .get();
              Map<String, dynamic> res = (docSnapshot.get('role'));
              if (res.containsKey(emailController.text.trim().toLowerCase())) {
                String role = res[emailController.text.trim().toLowerCase()];
                if (role == 'student') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainTabView(
                        role: role,
                      ),
                    ),
                  );
                } else if (role == 'canteen_owner') {
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
                     
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CanteenOwner(collegeName: collegeName)));
                    } else {
                      print("Collge not found");
                    }

                    // Iterate through each document in the "college" collection
                  } catch (e) {
                    print('Error checking documents: $e');
                  }
                }
              } else {
                print("Account not found");
              }
            } else {
              print("Error");
            }
          },
          child: const Text(
            'Log In',
            style: TextStyle(fontSize: 18),
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
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(25),
      ),
      height: 40,
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
                  child: const Text('Log In'),
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
                  child: const Text('Sign Up'),
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
          controller: passwordController,
          decoration: InputDecoration(hintText: 'Password'),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        ),
        SizedBox(height: 10),
        TextField(
          controller: retypedPasswordController,
          decoration: InputDecoration(hintText: 'Re-type Password'),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        ),
        SizedBox(
          height: 25,
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
                print("Error");
              } else {
                // All correct
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RoleSeperationPage(
                              userData: {
                                'email':
                                    emailController.text.toLowerCase().trim(),
                                'password': passwordController.text.trim()
                              },
                            )));
              }
            } else {
              print("Error");
            }
          },
          child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
        )
      ],
    );
  }
}
