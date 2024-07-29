import 'package:flutter/material.dart';

import '../../../elements/app_button_square_border.dart';

class ShoppingCartEmptyViewbody extends StatelessWidget {
  const ShoppingCartEmptyViewbody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 120),
        Image.asset('assets/images/shopping_cart_img.png',
            width: 156, height: 156),
        const SizedBox(height: 66),
        const Text(
          'Your shopping cart is empty',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0x66000000)),
        ),
        const SizedBox(height: 10),
        const Text(
          'View the store and select your products',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppButtonSquareBorder(
            onTap: () {
              Navigator.pop(context);
            },
            text: 'Go Shopping',
          ),
        )
      ],
    );
  }
}
