import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../welcome_screen/welcome_view.dart';
import 'widgets/page_one.dart';
import 'widgets/page_three.dart';
import 'widgets/page_two.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({Key? key}) : super(key: key);

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              PageOneBody(
                onTap: () {
                  controller.animateToPage(1,
                      duration: const Duration(
                        seconds: 1,
                      ),
                      curve: Curves.easeIn);
                },
              ),
              PageTwoBody(
                onTap: () {
                  controller.animateToPage(2,
                      duration: const Duration(
                        seconds: 1,
                      ),
                      curve: Curves.easeIn);
                },
              ),
              PageThreeBody(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeView()));
                },
              ),
            ],
          ),
          Positioned.fill(
            bottom: 130,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                count: 3,
                controller: controller,
                effect: const WormEffect(
                    spacing: 8.0,
                    dotHeight: 10,
                    dotWidth: 10,
                    radius: 40,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.white,
                    activeDotColor: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
