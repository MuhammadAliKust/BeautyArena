import 'package:beauty_arena_app/presentation/elements/app_button_primary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageOneBody extends StatelessWidget {
  final VoidCallback onTap;

  const PageOneBody({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/onboarding_1_bg.png'))),
      child: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Discover',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'All new collections in Palestine are available in Beauty Arena.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w300,
                  color: Colors.black),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: AppButtonPrimary(
                onTap: onTap,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                text: 'Next'),
          ),
          const SizedBox(height: 50)
        ],
      ),
    );
  }
}
