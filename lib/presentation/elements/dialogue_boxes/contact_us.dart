import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_button_primary.dart';

class Contactus extends StatelessWidget {
  final String whatsapp;

  const Contactus({Key? key, required this.whatsapp}) : super(key: key);

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
                    Image.asset('assets/images/contact_us_img.png',
                        width: 96.79, height: 96.79),
                    SizedBox(height: 20),
                    const Text(
                      'Contact us',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'If you have any questions or feedbacks, you can contact us through WhatsApp and we will respond on you very shortly.',
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
                          onTap: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          text: 'Go Back'),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: AppButtonPrimary(
                          onTap: () {
                            _launchURL(whatsapp);
                          },
                          backgroundColor: const Color(0xff559F00),
                          textColor: Colors.white,
                          text: 'Message us Now'),
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

  _launchURL(String whatsapp) async {
    var url = 'https://wa.me/$whatsapp?text=${Uri.parse("Hello!")}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
