import 'package:beauty_arena_app/presentation/elements/flush_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../application/cart_provider.dart';

class CartWidget extends StatelessWidget {
  final String image;
  final String itemname;
  final String id;
  final String price;
  final String quantity;
  final String counting;
  final VoidCallback onTap;

  const CartWidget(
      {required this.onTap,
      required this.image,
      required this.itemname,
      required this.id,
      required this.price,
      required this.quantity,
      required this.counting});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 78,
                    width: 78,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: image.toString(),
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/ph.jpg',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/ph.jpg',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          itemname,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Text(
                            '₪',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (int.parse(counting) >= int.parse(quantity)) {
                            getFlushBar(context,
                                title:
                                    "Sorry! You cannot order more than $counting items");
                            return;
                          }
                          cart.increment(id);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.add_circle_outline, size: 17),
                        ),
                      ),
                      Text(
                        counting,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          cart.decrement(id);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            CupertinoIcons.minus_circled,
                            size: 17,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      onPressed: () {
                        cart.removeItem(id);
                      },
                      icon: const Icon(CupertinoIcons.delete,
                          color: Color(0xffD0021B), size: 20),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
