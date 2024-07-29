import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../application/cart_provider.dart';
import '../../../../../application/user_provider.dart';
import '../../../../../infrastructure/models/cart.dart';
import '../../../../../infrastructure/models/dashboard.dart';
import '../../../../elements/flush_bar.dart';
import '../../../product_details/item_details_view.dart';

class FeaturedProducts extends StatelessWidget {
  final Product model;

  const FeaturedProducts({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);
    var user = Provider.of<UserProvider>(context, listen: false);
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (user.getUserDetails() != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemDetailsView(
                          model: model,
                          categoryID: model.categories![0].id.toString())));
            } else {
              getLoginFlushBar(context);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: model.image.toString(),
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/ph.jpg',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/ph.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          model.name.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 3),
                      if (model.outOfStock == 1)
                        Text(
                          "Out Of Stock",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.red),
                        ),
                      SizedBox(height: 3),
                      if (model.offer != 0)
                        Row(
                          children: [
                            Text(
                              '₪${model.salePrice.toString()}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffDE1D1D)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '₪${model.price.toString()}',
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff9B9B9B)),
                            ),
                          ],
                        )
                      else
                        Text(
                          '₪${model.price.toString()}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (user.getUserDetails() == null) {
                    getLoginFlushBar(context);
                    return;
                  }
                  if (model.outOfStock == 1) {
                    getFlushBar(context,
                        title:
                            'The product is out of stock and can’t be added to cart.');
                    return;
                  }
                  if (cart.getItemQuantity(model.id.toString()) >=
                      model.inventory!) {
                    getFlushBar(context,
                        title: 'Sorry we do not have enough stock');
                    return;
                  }
                  cart.addItem(CartModel(
                      name: model.name.toString(),
                      id: model.id.toString(),
                      categoryID: model.categories == null
                          ? ""
                          : model.categories![0].id.toString(),
                      offer: model.offer!.toString(),
                      price: model.offer == 1
                          ? model.salePrice.toString()
                          : model.price.toString(),
                      totalQuantity: model.inventory!,
                      product: Product(
                        id: model.id,
                        name: model.name,
                        price: model.price,
                        image: model.image,
                        images: model.images,
                        description: model.description,
                        inventory: model.inventory,
                        status: model.status,
                        crossSellingProducts: model.crossSellingProducts!,
                        sku: model.sku,
                        offer: model.offer,
                        salePrice: model.salePrice,
                      ),
                      quantity: 1,
                      image: model.image.toString()));
                  addToCartFlushBar(context,
                      title: "Item has been added to cart.");
                },
                child: Image.asset('assets/images/add_cart_icon.png',
                    height: 30, width: 30),
              )
            ],
          ),
        ),
        const Divider(
          endIndent: 50,
          indent: 50,
        ),
      ],
    );
  }
}
