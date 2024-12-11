import 'dart:developer';

import 'package:beauty_arena_app/configurations/front_end_configs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../application/cart_provider.dart';
import '../../../../../infrastructure/models/cart.dart';
import '../../../../../infrastructure/models/dashboard.dart';
import '../../../../../infrastructure/models/product.dart';
import '../../../../elements/flush_bar.dart';
import '../../../product_details/item_details_view.dart';

class ExploreProductWidget extends StatelessWidget {
  final Datum model;
  final String categoryID;

  const ExploreProductWidget(
      {Key? key, required this.model, required this.categoryID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetailsView(
                    model: Product(
                      id: model.id,
                      name: model.name,  outOfStock: model.outOfStock,
                      crossSellingProducts: [],
                      price: model.price,
                      image: model.image,
                      images: model.images,
                      description: model.description,
                      inventory: model.inventory,
                      status: model.status,
                      sku: model.sku,
                      offer: model.offer,
                      salePrice: model.salePrice,
                    ),
                    categoryID: categoryID)));
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: model.image.toString(),
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/ph.jpg',
                      fit: BoxFit.fill,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/ph.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                if (model.outOfStock == 1)
                  Positioned.fill(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 20,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6)),
                              color: FrontEndConfigs.kPrimaryColor),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey2,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6)),
                              ),
                              child: Center(
                                  child: Text(
                                "Out of Stock!",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                            ),
                          ),
                        )),
                  ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        if(model.outOfStock == 1){
                          getFlushBar(context, title: 'The product is out of stock and can’t be added to cart.');
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
                          categoryID: categoryID,
                          offer: model.offer!.toString(),
                          totalQuantity: model.inventory!,
                          price: model.offer == 1
                              ? model.salePrice.toString()
                              : model.price.toString(),
                          quantity: 1,
                          image: model.image.toString(),
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
                        ));
                        addToCartFlushBar(context,
                            title: 'Item has been added to cart.');
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                            color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/add_cart_icon.png',
                                  color: Colors.white, height: 20, width: 20),
                              SizedBox(width: 2),
                              Text(
                                'Add to cart',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
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
                  SizedBox(
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
            Text(
              model.name.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
