import 'package:beauty_arena_app/application/app_state.dart';
import 'package:beauty_arena_app/application/cart_provider.dart';
import 'package:beauty_arena_app/application/user_provider.dart';
import 'package:beauty_arena_app/infrastructure/services/marina.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/enums.dart';
import '../../../configurations/front_end_configs.dart';
import '../../../infrastructure/models/cart.dart';
import '../../../infrastructure/models/dashboard.dart';
import '../../../infrastructure/models/marina.dart';
import '../../elements/flush_bar.dart';
import '../../elements/processing_widget.dart';
import '../product_details/item_details_view.dart';

class MarinaView extends StatefulWidget {
  const MarinaView({super.key});

  @override
  State<MarinaView> createState() => _MarinaViewState();
}

class _MarinaViewState extends State<MarinaView> {
  Category? selectedCategory;
  MarinaModel? model;

  @override
  void initState() {
    var state = Provider.of<AppState>(context, listen: false);

    var user = Provider.of<UserProvider>(context, listen: false);
    MarinaServices()
        .getMarina(
            context, state, user.getUserDetails()!.data!.token.toString())
        .then((value) {
      model = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    var cart = Provider.of<CartProvider>(context);
    var state = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      body: model == null
          ? Center(
              child: ProcessingWidget(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/marina.png',
                          height: 28,
                          width: 29,
                        ),
                        Text(
                          'Marian’s Corner',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CachedNetworkImage(
                    imageUrl: model!.data![0].image.toString(),
                    // height: 230,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/user_ph.jpeg',
                      fit: BoxFit.cover,
                      height: 230,
                      width: MediaQuery.of(context).size.width,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/user_ph.jpeg',
                      height: 230,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
                    child: ListView.builder(
                        itemCount: model!.data![0].categories!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return Row(
                            children: [
                              if (i == 0)
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        selectedCategory = null;
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 86,
                                              width: 86,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff0E0E0E)),
                                              child: Center(
                                                child: Text(
                                                  "ALL",
                                                  style: TextStyle(
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 80,
                                              child: Text(
                                                "All Categories",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${model!.data![0].products!.length} items",
                                              style: TextStyle(
                                                  color: Color(0xffACACAC),
                                                  fontSize: 9),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              InkWell(
                                onTap: () {
                                  selectedCategory =
                                      model!.data![0].categories![i];
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: model!
                                              .data![0].categories![i].image
                                              .toString(),
                                          height: 86,
                                          width: 86,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            'assets/images/user_ph.jpeg',
                                            fit: BoxFit.cover,
                                            height: 86,
                                            width: 86,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/images/user_ph.jpeg',
                                            height: 86,
                                            width: 86,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 80,
                                        child: Text(
                                          model!.data![0].categories![i].name
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${getProductsList(model!.data![0], model!.data![0].categories![i]).length} items",
                                        style: TextStyle(
                                            color: Color(0xffACACAC),
                                            fontSize: 9),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      itemCount:
                          getSelectedProductsList(model!.data![0]).length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ItemDetailsView(
                                          model: Product(
                                            id: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .id,
                                            name: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .name,
                                            outOfStock: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .outOfStock,
                                            crossSellingProducts: [],
                                            price: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .price,
                                            image: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .image,
                                            images: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .images,
                                            description:
                                                getSelectedProductsList(
                                                        model!.data![0])[i]
                                                    .description,
                                            inventory: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .inventory,
                                            status: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .status,
                                            sku: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .sku,
                                            offer: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .offer,
                                            salePrice: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .salePrice,
                                          ),
                                          categoryID:selectedCategory == null ? "-1": selectedCategory!.id.toString())));
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .image
                                                .toString(),
                                            height: 88,
                                            width: 88,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/images/user_ph.jpeg',
                                              fit: BoxFit.cover,
                                              height: 88,
                                              width: 88,
                                            ),
                                            errorWidget: (context, url, error) =>
                                                Image.asset(
                                              'assets/images/user_ph.jpeg',
                                              height: 88,
                                              width: 88,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        if ( model!.data![0].products![i].outOfStock == 1)
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
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getSelectedProductsList(
                                                    model!.data![0])[i]
                                                .name
                                                .toString(),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          if (getSelectedProductsList(
                                                      model!.data![0])[i]
                                                  .offer !=
                                              0)
                                            Row(
                                              children: [
                                                Text(
                                                  '₪${getSelectedProductsList(model!.data![0])[i].salePrice.toString()}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xffDE1D1D)),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '₪${getSelectedProductsList(model!.data![0])[i].price.toString()}',
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff9B9B9B)),
                                                ),
                                              ],
                                            )
                                          else
                                            Text(
                                              '₪${getSelectedProductsList(model!.data![0])[i].price.toString()}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cart.addItem(CartModel(
                                            id: getSelectedProductsList(model!.data![0])[i]
                                                .id
                                                .toString(),
                                            offer: getSelectedProductsList(model!.data![0])[i]
                                                .offer!
                                                .toString(),
                                            name: getSelectedProductsList(model!.data![0])[i]
                                                .name
                                                .toString(),
                                            image: getSelectedProductsList(model!.data![0])[i]
                                                .image
                                                .toString(),
                                            categoryID: getSelectedProductsList(model!.data![0])[i]
                                                .categories![0]
                                                .id
                                                .toString(),
                                            totalQuantity: getSelectedProductsList(model!.data![0])[i]
                                                .inventory!,
                                            product: getSelectedProductsList(
                                                model!.data![0])[i],
                                            price: getSelectedProductsList(model!.data![0])[i].offer == 1
                                                ? getSelectedProductsList(model!.data![0])[i]
                                                    .salePrice
                                                    .toString()
                                                : getSelectedProductsList(model!.data![0])[i].price.toString(),
                                            quantity: 1));
                                        addToCartFlushBar(context,
                                            title:
                                                'Item has been added to cart.');
                                      },
                                      icon: Image.asset(
                                          'assets/images/add_cart_icon.png',
                                          width: 24.12,
                                          height: 24.09),
                                    )
                                  ],
                                ),
                                Divider(
                                  indent: 50,
                                  endIndent: 50,
                                )
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
    );
  }

  List<Product> getProductsList(Datum model, Category category) {
    List<Product> productList = [];
    model.products!.map((e) {
      if (e.categories![0].id == category.id) {
        productList.add(e);
      }
    }).toList();

    return productList;
  }

  List<Product> getSelectedProductsList(Datum model) {
    List<Product> productList = [];
    if (selectedCategory != null) {
      model.products!.map((e) {
        if (e.categories![0].id == selectedCategory!.id) {
          productList.add(e);
        }
      }).toList();
    } else {
      model.products!.map((e) {
        productList.add(e);
      }).toList();
    }

    return productList;
  }
}
