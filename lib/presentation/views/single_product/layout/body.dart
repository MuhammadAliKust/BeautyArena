import 'dart:developer';

import 'package:beauty_arena_app/application/dyanmic_link.dart';
import 'package:beauty_arena_app/infrastructure/models/dashboard.dart';
import 'package:beauty_arena_app/infrastructure/models/single_product.dart';
import 'package:beauty_arena_app/presentation/views/home_screen/layout/widgets/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../application/app_state.dart';
import '../../../../application/cart_provider.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/cart.dart';
import '../../../../infrastructure/models/product.dart';
import '../../../../infrastructure/models/related_products.dart';
import '../../../../infrastructure/services/product.dart';
import '../../../elements/app_button_square_border.dart';
import '../../../elements/flush_bar.dart';
import '../../../elements/processing_widget.dart';
import '../single_product_view.dart';

class SingleProductDetailsViewBody extends StatefulWidget {
  final String productID;

  const SingleProductDetailsViewBody({Key? key, required this.productID})
      : super(key: key);

  @override
  State<SingleProductDetailsViewBody> createState() =>
      _SingleProductDetailsViewBodyState();
}

class _SingleProductDetailsViewBodyState
    extends State<SingleProductDetailsViewBody> {
  double selectedIndex = 0;
  bool isFirstLoad = false;

  SingleProductModel? singleProductModel;

  getData() async {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context, listen: false);
    await ProductServices()
        .getProductByID(
            context,
            state,
            user.getUserDetails() == null
                ? ""
                : user.getUserDetails()!.data!.token.toString(),
            widget.productID.toString())
        .then((value) {
      log(value.toJson().toString());
      singleProductModel = value;
      setState(() {});
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context);
    var cart = Provider.of<CartProvider>(context);
    return singleProductModel == null
        ? Center(
            child: ProcessingWidget(),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (singleProductModel!.data!.images != null)
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            height: 480,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            onPageChanged: (val, _) {
                              selectedIndex = val.toDouble();
                              setState(() {});
                            }),
                        items: singleProductModel!.data!.images!.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: i.toString(),
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/images/ph.jpg',
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/ph.jpg',
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      if (singleProductModel!.data!.images!.length > 1)
                        Positioned.fill(
                          bottom: 30,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: DotsIndicator(
                              dotsCount:
                                  singleProductModel!.data!.images!.length,
                              axis: Axis.horizontal,
                              position: selectedIndex,
                              decorator: const DotsDecorator(
                                color: Color(0xffE5E5EA), // Inactive color
                                activeColor: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 18),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                      splashRadius: 100,
                                      onPressed: () async {
                                        if (singleProductModel!
                                                .data!.favorite ==
                                            1) {
                                          singleProductModel!.data!.favorite =
                                              2;
                                          setState(() {});
                                        } else {
                                          singleProductModel!.data!.favorite =
                                              1;
                                          setState(() {});
                                        }
                                        try {
                                          var model = await ProductServices()
                                              .addProductToFavorite(context,
                                                  productID: singleProductModel!
                                                      .data!.id
                                                      .toString(),
                                                  token: user
                                                      .getUserDetails()!
                                                      .data!
                                                      .token
                                                      .toString());
                                          getFlushBar(context,
                                              title:
                                                  "Product has been added to favorite.");
                                        } catch (e) {
                                          singleProductModel!.data!.favorite =
                                              1;
                                          setState(() {});
                                          getFlushBar(context,
                                              title: e.toString());
                                        }
                                      },
                                      icon: Icon(
                                        singleProductModel == null
                                            ? Icons.favorite_border
                                            : singleProductModel!
                                                        .data!.favorite ==
                                                    2
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                        color: Colors.red,
                                      ))),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                if (singleProductModel!.data!.outOfStock == 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: 130,
                      height: 30,
                      child: Center(
                          child: Text(
                        "Out Of Stock!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            singleProductModel!.data!.name.toString(),
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                  // splashRadius: 100,
                                  onPressed: () async {
                                    Share.share(buildDynamicLinks(
                                        singleProductModel!.data!.id
                                            .toString()));
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    size: 17,
                                  )))
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                if (singleProductModel!.data!.offer != 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          '₪${singleProductModel!.data!.salePrice.toString()}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffDE1D1D)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '₪${singleProductModel!.data!.price.toString()}',
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff9B9B9B)),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      '₪${singleProductModel!.data!.price.toString()}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                const SizedBox(height: 10),
                AppButtonSquareBorder(
                    onTap: () {
                      log(singleProductModel!.data!.outOfStock.toString());
                      if (singleProductModel!.data!.outOfStock == 1) {
                        getFlushBar(context,
                            title:
                                'The product is out of stock and can’t be added to cart.');
                        return;
                      }
                      if (cart.getItemQuantity(
                              singleProductModel!.data!.id.toString()) >=
                          singleProductModel!.data!.inventory!) {
                        getFlushBar(context,
                            title: 'Sorry we do not have enough stock');
                        return;
                      }
                      cart.addItem(CartModel(
                          id: singleProductModel!.data!.id.toString(),
                          offer: singleProductModel!.data!.offer!.toString(),
                          name: singleProductModel!.data!.name.toString(),
                          image: singleProductModel!.data!.image.toString(),
                          categoryID:
                              singleProductModel!.data!.categories!.isEmpty
                                  ? ""
                                  : singleProductModel!.data!.categories![0].id
                                      .toString(),
                          totalQuantity: singleProductModel!.data!.inventory!,
                          product: Product(
                            id: singleProductModel!.data!.id,
                            name: singleProductModel!.data!.name,
                            price: singleProductModel!.data!.price,
                            image: singleProductModel!.data!.image,
                            images: singleProductModel!.data!.images,
                            description: singleProductModel!.data!.description,
                            inventory: singleProductModel!.data!.inventory,
                            status: singleProductModel!.data!.status,
                            crossSellingProducts:
                                singleProductModel!.data!.crossSellingProducts!,
                            sku: singleProductModel!.data!.sku,
                            offer: singleProductModel!.data!.offer,
                            salePrice: singleProductModel!.data!.salePrice,
                          ),
                          price: singleProductModel!.data!.offer == 1
                              ? singleProductModel!.data!.salePrice.toString()
                              : singleProductModel!.data!.price.toString(),
                          quantity: 1));
                      addToCartFlushBar(context,
                          title: 'Item has been added to cart.');
                    },
                    text: 'ADD TO CART'),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Html(
                      data: singleProductModel!.data!.description.toString(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
  }
}
