import 'package:beauty_arena_app/application/user_provider.dart';
import 'package:beauty_arena_app/infrastructure/services/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../infrastructure/services/local.dart';
import '../../views/bottom_bar.dart';
import '../app_button_primary.dart';

class RateUsView extends StatefulWidget {
  const RateUsView({Key? key}) : super(key: key);

  @override
  State<RateUsView> createState() => _RateUsViewState();
}

class _RateUsViewState extends State<RateUsView> {
  void setTimer() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('time', DateTime.now().toIso8601String());
  }

  void exitTimer() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('showRateUs', false);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Image.asset('assets/images/rate_us_img.png',
                        width: 127.9, height: 96.79),
                    SizedBox(height: 20),
                    const Text(
                      'Rate us',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'If you liked our app and our products, support us by rating the application the stores.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: AppButtonPrimary(
                          onTap: () async {
                            setTimer();
                            Navigator.pop(context);

                            await Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNavBar()),
                                (route) => false);
                          },
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          text: 'No Thanks.'),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: AppButtonPrimary(
                          onTap: () async {
                            exitTimer();
                            LaunchReview.launch();
                            Navigator.pop(context);
                          },
                          backgroundColor: const Color(0xff559F00),
                          textColor: Colors.white,
                          text: 'Yes. I will rate you!'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
