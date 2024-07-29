import 'package:beauty_arena_app/application/app_state.dart';
import 'package:beauty_arena_app/application/user_provider.dart';
import 'package:beauty_arena_app/infrastructure/services/marina.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/enums.dart';
import '../../../infrastructure/models/marina.dart';
import '../../elements/processing_widget.dart';

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
                    height: 230,
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
                          child: Column(
                            children: [
                              Row(
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
                                        Row(
                                          children: [
                                            Text(
                                              "₪${getSelectedProductsList(model!.data![0])[i].price.toString()}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xffFF2D55),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "₪${getSelectedProductsList(model!.data![0])[i].offerPercentage}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xffB4B4B4),
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(onPressed: (){}, icon:  Image.asset('assets/images/add_cart_icon.png',
                                      width: 24.12, height: 24.09),)
                                ],
                              ),
                              Divider(
                                indent: 50,
                                endIndent: 50,
                              )
                            ],
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
