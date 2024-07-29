import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../application/cart_provider.dart';
import '../../../application/user_provider.dart';
import '../../../infrastructure/models/dashboard.dart';
import '../../elements/flush_bar.dart';
import '../cart_screen/cart_view.dart';
import 'layout/body.dart';

class ItemDetailsView extends StatelessWidget {
  final Product model;
  final String categoryID;

  const ItemDetailsView(
      {Key? key, required this.model, required this.categoryID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    var cart = Provider.of<CartProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Icon(
                Icons.arrow_back,
                size: 30,color: Colors.black
              ),
            )),
        actions: [
          IconButton(
            icon: cart.cartItems.isEmpty
                ? const Icon(CupertinoIcons.cart, color: Colors.black)
                : Badge(
                    largeSize: 12,
                    smallSize: 12,
                    label: Text(cart.cartItems.length.toString()),
                    child:
                        const Icon(CupertinoIcons.cart, color: Colors.black)),
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
      ),
      body: ItemDetailsViewBody(model: model, categoryID: categoryID),
    );
  }
}
