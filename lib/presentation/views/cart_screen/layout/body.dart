import 'package:beauty_arena_app/presentation/views/product_details/item_details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../application/cart_provider.dart';
import '../../shopping_cart_empty_screen/layout/body.dart';
import 'widgets/cart_widget.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    return cart.cartItems.isEmpty
        ? ShoppingCartEmptyViewbody()
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: cart.cartItems.length,
            itemBuilder: (BuildContext context, int i) {
              return CartWidget(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemDetailsView(
                              model: cart.cartItems[i].product,
                              categoryID:
                                  cart.cartItems[i].categoryID.toString())));
                },
                id: cart.cartItems[i].id.toString(),
                image: cart.cartItems[i].image.toString(),
                itemname: cart.cartItems[i].name.toString(),
                price: cart.cartItems[i].price.toString(),
                quantity: cart.cartItems[i].totalQuantity.toString(),
                counting: cart.cartItems[i].quantity.toString(),
              );
            });
  }
}
