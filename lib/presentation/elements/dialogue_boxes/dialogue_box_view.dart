import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_button_square_border.dart';
import 'are_you_sure.dart';
import 'contact_us.dart';
import 'rate_us_view.dart';

class DialogueBoxView extends StatelessWidget {
  const DialogueBoxView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButtonSquareBorder(
              onTap: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (ctx) => const RateUsView()
                );
              },
              text: 'Rate us'),
          SizedBox(height: 20),
          // AppButtonSquareBorder(
          //     onTap: () {
          //       showDialog(
          //         barrierDismissible: true,
          //           context: context,
          //           builder: (ctx) =>  Contactus()
          //       );
          //     },
          //     text: 'Contact us'),
          SizedBox(height: 20),
          AppButtonSquareBorder(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (ctx) => const AreYouSure()
                );
              },
              text: 'Are You Sure?'),
        ],
      ),
    );
  }
}
