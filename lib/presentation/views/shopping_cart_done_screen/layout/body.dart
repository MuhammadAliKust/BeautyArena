import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../application/user_provider.dart';
import '../../../../infrastructure/services/dashboard.dart';
import '../../../../infrastructure/services/local.dart';
import '../../../elements/app_button_square_border.dart';
import '../../../elements/dialogue_boxes/rate_us_view.dart';
import '../../bottom_bar.dart';

class ShoppingCartDoneViewBody extends StatefulWidget {
  const ShoppingCartDoneViewBody({Key? key}) : super(key: key);

  @override
  State<ShoppingCartDoneViewBody> createState() =>
      _ShoppingCartDoneViewBodyState();
}

class _ShoppingCartDoneViewBodyState extends State<ShoppingCartDoneViewBody> {
  @override
  void initState() {
    var user = Provider.of<UserProvider>(context, listen: false);
    DashboardServices()
        .getLocalDashboardData(
            context, user.getUserDetails()!.data!.token.toString())
        .then(CacheServices.instance.writeDashboardData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100),
        Image.asset('assets/images/shopping_done_img.png',
            width: 146, height: 146),
        SizedBox(height: 66),
        const Text(
          'Thank you!',
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        const Text(
          'Your order has been placed.',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0x66000000)),
        ),
        SizedBox(height: 3),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Please check the delivery status at Order Tracking page',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0x66000000)),
          ),
        ),
        SizedBox(height: 80),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppButtonSquareBorder(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                  (route) => false);
            },
            text: 'Back to Home',
          ),
        )
      ],
    );
  }
}
