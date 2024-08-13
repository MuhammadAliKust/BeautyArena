import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/cart_provider.dart';
import 'layout/body.dart';

class ShippingAddressView extends StatelessWidget {
  final num discount;

  const ShippingAddressView({super.key, required this.discount});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ShippingAddressViewBody(
        discount: discount,
      ),
    );
  }
}
