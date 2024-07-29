import 'package:beauty_arena_app/presentation/elements/app_button_primary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageThreeBody extends StatelessWidget {
  final VoidCallback onTap;

  const PageThreeBody({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/onboarding_3_bg.png'))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'You Deserve it!',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Create your style with us',
              style: TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: AppButtonPrimary(
                onTap: onTap,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                text: 'Get Started'),
          ),
          const SizedBox(height: 50)
        ],
      ),
    );
  }
}
