import 'package:flutter/material.dart';
import 'package:projrect_annam/auth/authWrapper.dart';
import 'package:projrect_annam/helper/helper.dart';
import 'package:projrect_annam/auth/on_boarding_view.dart';

class StartupView extends StatefulWidget {
  final int? initScreen;
  const StartupView({super.key, required this.initScreen});

  @override
  State<StartupView> createState() => _StarupViewState();
}

class _StarupViewState extends State<StartupView> {
  @override
  void initState() {
    super.initState();
    goWelcomePage();
  }

  Future<void> goWelcomePage() async {
    await Future.delayed(const Duration(seconds: 3));

    context.pushReplacement(
        (widget.initScreen == 0 || widget.initScreen == null)
            ? OnBoardingView()
            : AuthWrapper());
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/splash_bg.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/img/logo.png",
            width: media.width * 0.55,
            height: media.width * 0.55,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
