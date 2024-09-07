import 'dart:developer';

import 'package:beauty_arena_app/application/app_state.dart';
import 'package:beauty_arena_app/application/errorStrings.dart';
import 'package:beauty_arena_app/application/user_provider.dart';
import 'package:beauty_arena_app/configurations/enums.dart';
import 'package:beauty_arena_app/infrastructure/models/coupon_body.dart';
import 'package:beauty_arena_app/infrastructure/services/discount.dart';
import 'package:beauty_arena_app/presentation/elements/flush_bar.dart';
import 'package:beauty_arena_app/presentation/elements/processing_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../../application/cart_provider.dart';
import '../shipping_address_screen/shipping_address_view.dart';

class ReviewOrderSummaryView extends StatefulWidget {
  ReviewOrderSummaryView({super.key});

  @override
  State<ReviewOrderSummaryView> createState() => _ReviewOrderSummaryViewState();
}

class _ReviewOrderSummaryViewState extends State<ReviewOrderSummaryView> {
  TextEditingController couponController = TextEditingController();

  num discount = 0;

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    var user = Provider.of<UserProvider>(context);
    var state = Provider.of<AppState>(context);
    return LoadingOverlay(
      isLoading: state.getStateStatus() == AppCurrentState.IsBusy,
      color: Colors.transparent,
      progressIndicator: ProcessingWidget(),
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
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
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShippingAddressView(discount: discount,)));
              },
              child: Container(
                height: 75,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'PROCEED',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/cart_outline.png',
                            width: 30, height: 30),
                        SizedBox(width: 10),
                        Text(
                          'Order Review',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 7),
                Text(
                  'Please review your order for the last time.',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff515151)),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Color(0xffC5C5C5))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 9),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/copy.png',
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Order Details:",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        ...cart.cartItems
                            .map((e) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 240,
                                      child: Text(
                                        e.name.toString(),
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "x${e.quantity.toString()}",
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "₪${(e.quantity * num.parse(e.price)).toStringAsFixed(2)}",

                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ))
                            .toList()
                      ],
                    ),
                  ),
                ),
                // SizedBox(height: 10),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.white,
                //       border: Border.all(color: Color(0xffC5C5C5))),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 12.0, vertical: 9),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             Image.asset(
                //               'assets/images/box.png',
                //               height: 20,
                //               width: 20,
                //             ),
                //             SizedBox(
                //               width: 5,
                //             ),
                //             Text(
                //               "Shipping Details:",
                //               style: TextStyle(
                //                   fontSize: 13, fontWeight: FontWeight.w600),
                //             )
                //           ],
                //         ),
                //         SizedBox(
                //           height: 14,
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               "Shipping to Bethlehem",
                //               style: TextStyle(
                //                   fontSize: 11, fontWeight: FontWeight.w500),
                //             ),
                //             Text(
                //               "₪90",
                //               style: TextStyle(
                //                   fontSize: 11, fontWeight: FontWeight.w500),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: 10),
                DottedBorder(
                  color: Color(0xffCE0000),borderType: BorderType.RRect,
                  dashPattern: [
                    5,
                    5,
                  ],
                  radius: const Radius.circular(10),
                  strokeWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 9),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/coupon.png',
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Do you have a coupon?",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: couponController,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 7),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Color(0xffC2C2C2)))),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  if (couponController.text.isEmpty) {
                                    getFlushBar(context,
                                        title: "Coupon code cannot be empty.");
                                    return;
                                  }
                                  try {
                                    await DiscountServices()
                                        .getDiscount(context,
                                            state: state,
                                            token: user
                                                .getUserDetails()!
                                                .data!
                                                .token
                                                .toString(),
                                            couponCode: couponController.text,
                                            list: cart.cartItems
                                                .map((e) => CouponBodyModel(
                                                    productID:
                                                        e.product.id.toString(),
                                                    quantity: e.quantity))
                                                .toList())
                                        .then((value) {
                                      discount = value.data!.totalDiscount!;
                                      setState(() {});
                                    });
                                  } catch (e) {
                                    discount = 0;
                                    setState(() {});
                                    log(e.toString());
                                    getFlushBar(context,
                                        title: Provider.of<ErrorString>(context,
                                                listen: false)
                                            .getErrorString());
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffCA0303),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13),
                                    child: Center(
                                        child: Text(
                                      "ADD",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Sub total:",
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "₪${cart.getSubTotal()}",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 8,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Text(
                //       "Shipping:",
                //       style: TextStyle(fontSize: 17),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Text(
                //       "₪143.99",
                //       style: TextStyle(fontSize: 17),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Discount:",
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "₪$discount",
                      style: TextStyle(fontSize: 17, color: Color(0xff25B700)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Total:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "₪${cart.getSubTotal() - discount}",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
