import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    required this.key,
  }) : super(key: key);

  final Key key;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "By creating an account, you are agreeing to our\n",
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: "Terms & Conditions ",
              style: const TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AnimatedPolicyDialog(
                        mdFileName: 'terms_and_conditions.md',
                        key: key,
                      );
                    },
                  );
                },
            ),
            const TextSpan(text: "and "),
            TextSpan(
              text: "Privacy Policy! ",
              style: const TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AnimatedPolicyDialog(
                        mdFileName: 'privacy_policy.md',
                        key: key,
                      );
                    },
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedPolicyDialog extends StatefulWidget {
  AnimatedPolicyDialog({
    required Key key,
    this.radius = 8,
    required this.mdFileName,
  })  : assert(mdFileName.contains('.md'),
            'The file must contain the .md extension'),
        super(key: key);

  final double radius;
  final String mdFileName;

  @override
  _AnimatedPolicyDialogState createState() => _AnimatedPolicyDialogState();
}

class _AnimatedPolicyDialogState extends State<AnimatedPolicyDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Dialog(
          insetAnimationCurve: Curves.bounceInOut,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius)),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: Future.delayed(const Duration(milliseconds: 200))
                      .then((value) {
                    return rootBundle
                        .loadString('assets/markdowns/${widget.mdFileName}');
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Markdown(
                        data: snapshot.data!,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(widget.radius),
                      bottomRight: Radius.circular(widget.radius),
                    ),
                  )),
                ),
                onPressed: () {
                  _controller.reverse().then((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(widget.radius),
                      bottomRight: Radius.circular(widget.radius),
                    ),
                  ),
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  child: Text(
                    "CLOSE",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        horizontalLine(),
        const Text(
          "OR",
          style: TextStyle(fontSize: 14),
        ),
        horizontalLine(),
      ],
    );
  }

  Widget horizontalLine() {
    return Container(
      margin: const EdgeInsets.all(12),
      height: 2,
      width: 124,
      color: Colors.grey,
    );
  }
}
