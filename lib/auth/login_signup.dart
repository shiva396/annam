import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projrect_annam/auth/detail.dart';

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
                      _isSignUp ? const SignUpFields() : const EmailBar(),
                      const SizedBox(
                        height: 70,
                      ),
                      _isSignUp ? const SignUpButton() : const LogInButton(),
                      const SizedBox(
                        height: 20,
                      ),
                      const ContinueDivider(),
                      const SocialIcons(),
                    ],
                  ),
                ),
              ],
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
                    builder: (context) => const RoleSeperationPage()));
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

class LogInButton extends StatelessWidget {
  const LogInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding:
            WidgetStateProperty.all(const EdgeInsets.fromLTRB(80, 2, 80, 2)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: const BorderSide(color: Colors.orange),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.orange.withOpacity(0.8); // darker shade on hover
            }
            return Colors.orange;
          },
        ),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () {
        print("ds");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RoleSeperationPage()));
      },
      child: const Text(
        'Log In',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class EmailBar extends StatelessWidget {
  const EmailBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          decoration: InputDecoration(hintText: 'Enter email or username'),
        ),
        TextField(
          decoration: InputDecoration(hintText: 'Password'),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.orange),
        ),
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

class SignUpFields extends StatelessWidget {
  const SignUpFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(hintText: 'Enter email or username'),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(hintText: 'New Password'),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(hintText: 'Re-type Password'),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        ),
      ],
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding:
            WidgetStateProperty.all(const EdgeInsets.fromLTRB(80, 2, 80, 2)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: const BorderSide(color: Colors.orange),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.orange.withOpacity(0.8); // darker shade on hover
            }
            return Colors.orange;
          },
        ),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () {
        print("ds");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RoleSeperationPage()));
      },
      child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
    );
  }
}
