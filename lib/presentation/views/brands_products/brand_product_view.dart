import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../application/bottom_index.dart';
import '../../../application/cart_provider.dart';
import '../../../application/user_provider.dart';
import '../../../infrastructure/models/categories.dart';
import '../../elements/flush_bar.dart';
import '../cart_screen/cart_view.dart';
import 'layout/body.dart';

class BrandProductView extends StatelessWidget {
  final String brandID;
  final String brandName;

  const BrandProductView(
      {Key? key, required this.brandID, required this.brandName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    var cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: cart.cartItems.isEmpty
                ? const Icon(CupertinoIcons.cart, color: Colors.white)
                : Badge(
                    largeSize: 12,
                    smallSize: 12,
                    label: Text(cart.cartItems.length.toString()),
                    child:
                        const Icon(CupertinoIcons.cart, color: Colors.white)),
            onPressed: () {
              if (user.getUserDetails() != null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartView()));
              } else {
                getLoginFlushBar(context);
              }
            },
          ),
        ],
        title: Image.asset('assets/images/logo.png',
            color: Colors.white, width: 133.48, height: 23.57),
      ),
      body: BrandProductViewBody(
        brandID: brandID,
        brandName: brandName,
      ),
    );
  }
}
