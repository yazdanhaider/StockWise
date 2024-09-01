import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'main.dart';

class MainWrapper extends StatefulWidget {
  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  bool showOnboarding = true;

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      setState(() {
        showOnboarding = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return showOnboarding ? OnBoardingScreen() : MainScreen();
  }
}