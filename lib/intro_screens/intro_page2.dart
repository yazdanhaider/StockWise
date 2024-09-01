import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/95f8476e-f2c5-46f0-8785-b9e36af6c73d/Kg94p6Y2KD.json',
              fit: BoxFit.cover,
            ),
            SizedBox(height: 40.0),
            Center(
              child: Text(
                "Navigate Your Finances with Ease",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        ),

      ),
    );
  }
}
