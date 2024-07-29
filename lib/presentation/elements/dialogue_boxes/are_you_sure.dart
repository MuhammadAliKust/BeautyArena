import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/app_state.dart';
import '../../../application/user_provider.dart';
import '../../../infrastructure/models/delete.dart';
import '../../../infrastructure/services/auth.dart';
import '../app_button_primary.dart';
import '../flush_bar.dart';

class AreYouSure extends StatelessWidget {
  const AreYouSure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context);
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
                    Image.asset('assets/images/delete-account.png',
                        width: 96.86, height: 97.79),
                    SizedBox(height: 20),
                    const Text(
                      'Are You Sure?',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'Deleting your account will remove all your details from our system. This action is irreversible.',
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
                          onTap: () async {
                            Navigator.pop(context);
                            try {
                            return  await AuthServices().deleteUser(context,
                                  token: user
                                      .getUserDetails()!
                                      .data!
                                      .token
                                      .toString(),
                                  state: state);
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          backgroundColor: const Color(0xffC70000),
                          textColor: Colors.white,
                          text: 'Delete my Account'),
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
