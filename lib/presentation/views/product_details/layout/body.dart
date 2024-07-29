import 'dart:developer';

import 'package:beauty_arena_app/infrastructure/models/dashboard.dart';
import 'package:beauty_arena_app/infrastructure/models/single_product.dart';
import 'package:beauty_arena_app/presentation/views/home_screen/layout/widgets/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

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
import '../item_details_view.dart';

class ItemDetailsViewBody extends StatefulWidget {
  final Product model;
  final String categoryID;

  const ItemDetailsViewBody(
      {Key? key, required this.model, required this.categoryID})
      : super(key: key);

  @override
  State<ItemDetailsViewBody> createState() => _ItemDetailsViewBodyState();
}

class _ItemDetailsViewBodyState extends State<ItemDetailsViewBody> {
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
            user.getUserDetails()!.data!.token.toString(),
            widget.model.id.toString())
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
    log(widget.model.images.toString());
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.model.images != null)
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
                  items: widget.model.images!.map((i) {
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
                            errorWidget: (context, url, error) => Image.asset(
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
                if (widget.model.images!.length > 1)
                  Positioned.fill(
                    bottom: 30,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: DotsIndicator(
                        dotsCount: widget.model.images!.length,
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
                                  if (singleProductModel!.data!.favorite == 1) {
                                    singleProductModel!.data!.favorite = 2;
                                    setState(() {});
                                  } else {
                                    singleProductModel!.data!.favorite = 1;
                                    setState(() {});
                                  }
                                  try {
                                    var model = await ProductServices()
                                        .addProductToFavorite(context,
                                            productID:
                                                widget.model.id.toString(),
                                            token: user
                                                .getUserDetails()!
                                                .data!
                                                .token
                                                .toString());
                                    getFlushBar(context,
                                        title:
                                            "Product has been added to favorite.");
                                  } catch (e) {
                                    singleProductModel!.data!.favorite = 1;
                                    setState(() {});
                                    getFlushBar(context, title: e.toString());
                                  }
                                },
                                icon: Icon(
                                  singleProductModel == null
                                      ? Icons.favorite_border
                                      : singleProductModel!.data!.favorite == 2
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
          if(widget.model.outOfStock == 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
  width: 130,
              height: 30,
              child: Center(
                  child: Text(
                "Out Of Stock!",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.model.name.toString(),
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          if (widget.model.offer != 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Text(
                    '₪${widget.model.salePrice.toString()}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffDE1D1D)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '₪${widget.model.price.toString()}',
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
                '₪${widget.model.price.toString()}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:Colors.black),
              ),
            ),
          const SizedBox(height: 10),
          AppButtonSquareBorder(
              onTap: () {
                log(widget.model.outOfStock.toString());
                if (widget.model.outOfStock == 1) {
                  getFlushBar(context,
                      title:
                          'The product is out of stock and can’t be added to cart.');
                  return;
                }
                if (cart.getItemQuantity(widget.model.id.toString()) >=
                    widget.model.inventory!) {
                  getFlushBar(context,
                      title: 'Sorry we do not have enough stock');
                  return;
                }
                cart.addItem(CartModel(
                    id: widget.model.id.toString(),
                    offer: widget.model.offer!.toString(),
                    name: widget.model.name.toString(),
                    image: widget.model.image.toString(),
                    categoryID: widget.categoryID.toString(),
                    totalQuantity: widget.model.inventory!,
                    product: Product(
                      id: widget.model.id,
                      name: widget.model.name,
                      price: widget.model.price,
                      image: widget.model.image,
                      images: widget.model.images,
                      description: widget.model.description,
                      inventory: widget.model.inventory,
                      status: widget.model.status,
                      crossSellingProducts: widget.model.crossSellingProducts!,
                      sku: widget.model.sku,
                      offer: widget.model.offer,
                      salePrice: widget.model.salePrice,
                    ),
                    price: widget.model.offer == 1
                        ? widget.model.salePrice.toString()
                        : widget.model.price.toString(),
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
                data: widget.model.description.toString(),
              ),
            ),
          ),
          SizedBox(height: 20),
          FutureProvider.value(
            value: ProductServices().getRelatedProducts(
                context,
                state,
                user.getUserDetails()!.data!.token.toString(),
                widget.model.id.toString()),
            initialData: RelatedProductsModel(),
            builder: (context, child) {
              var model = context.watch<RelatedProductsModel>();
              if (state.getStateStatus() == AppCurrentState.IsBusy) {
                return const Center(child: ProcessingWidget());
              } else if (state.getStateStatus() == AppCurrentState.IsError) {
                return const Text('No Internet');
              } else {
                return model.data!.isEmpty
                    ? SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'You also might like',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 270,
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: model.data!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ItemDetailsView(
                                                        model:
                                                            model.data![index],
                                                        categoryID: widget
                                                            .categoryID
                                                            .toString())));
                                      },
                                      child: SizedBox(
                                        width: 200.3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 200,
                                                  width: 200.3,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: CachedNetworkImage(
                                                      imageUrl: model
                                                          .data![index].image
                                                          .toString(),
                                                      height: 140,
                                                      width: 140,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              Image.asset(
                                                        'assets/images/ph.jpg',
                                                        fit: BoxFit.cover,
                                                        height: 140,
                                                        width: 140,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        'assets/images/ph.jpg',
                                                        height: 140,
                                                        width: 140,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    4),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    4),
                                                          ),
                                                          color: Colors.black),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                                'assets/images/add_cart_icon.png',
                                                                color: Colors
                                                                    .white,
                                                                height: 20,
                                                                width: 20),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              'Add to cart',
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            if (model.data![index].offer == 0)
                                              Row(
                                                children: [
                                                  Text(
                                                    '₪${model.data![index].price.toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                           Colors.black),
                                                  ),
                                                ],
                                              )
                                            else
                                              Row(
                                                children: [
                                                  Text(
                                                    '₪${model.data![index].salePrice.toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xffDE1D1D)),
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Text(
                                                    '₪${model.data![index].price.toString()}',
                                                    style: const TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xff9B9B9B)),
                                                  ),
                                                ],
                                              ),
                                            Text(
                                              model.data![index].name
                                                  .toString(),
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
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
              }
            },
          )
        ],
      ),
    );
  }
}
