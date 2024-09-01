import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:StockWise/intro_screens/intro_page1.dart';
import 'package:StockWise/intro_screens/intro_page2.dart';
import 'package:StockWise/intro_screens/intro_page3.dart';
import 'package:StockWise/main.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              Builder(
                builder: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to StockWise!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Unlock the Future of Trading – Get Started Now!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        child: Text(
                          'Get Started',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('seen', true);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => MainScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
            onPageChangeCallback: (page) {
              setState(() {
                currentPage = page;
              });
            },
            waveType: WaveType.liquidReveal,
            slideIconWidget: Icon(
              Icons.arrow_back_ios,
              color: Colors.deepPurple,
            ),
            enableLoop: false,
          ),
        ],
      ),
    );
  }
}
