import 'dart:async';
import 'dart:developer';
import 'package:beauty_arena_app/infrastructure/services/ad.dart';
import 'package:beauty_arena_app/presentation/views/home_screen/layout/widgets/category_widget.dart';
import 'package:beauty_arena_app/presentation/views/home_screen/layout/widgets/poster.dart';
import 'package:beauty_arena_app/presentation/views/home_screen/layout/widgets/product.dart';
import 'package:beauty_arena_app/presentation/views/shop_screen/shop_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../application/app_state.dart';
import '../../../../application/remote_config_provider.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/categories.dart';
import '../../../../infrastructure/models/dashboard.dart';
import '../../../../infrastructure/services/dashboard.dart';
import '../../../../infrastructure/services/local.dart';
import '../../../elements/dialogue_boxes/rate_us_view.dart';
import '../../../elements/flush_bar.dart';
import '../../../elements/processing_widget.dart';
import '../../categories_screen/categories_view.dart';
import '../../explore_screen/explore_view.dart';
import '../../feat_products/feat_products_view.dart';
import '../../featured_products/all_prodcuts_view.dart';
import '../../latest_products/latest_prodcuts_view.dart';
import '../../top_selling_products/top_selling_prodcuts_view.dart';
import 'widgets/featured_product.dart';

class HomeViewBody extends StatefulWidget {
  HomeViewBody({Key? key}) : super(key: key);

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  bool isFirstLoad = true;

  bool refreshData = false;

  getReloadDataStatus() async {
    final prefs = await SharedPreferences.getInstance();
    refreshData = prefs.getBool('reloadDashboardData') == null ? true : false;
  }

  updateReloadDataStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reloadDashboardData', false);
  }

  getTime() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('time') != null) {
      if (prefs.getBool('showRateUs') != false) {
        if (DateTime.now()
                .difference(DateTime.parse(prefs.getString('time').toString()))
                .inDays >
            2) {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (ctx) => const RateUsView());
        }
      }
    }
  }

  @override
  void initState() {
    var user = Provider.of<UserProvider>(context, listen: false);
    getTime();
    AdServices()
        .getAllAds(context, user.getUserDetails()!.data!.token.toString())
        .then((value) {
      showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.7),


          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              elevation: 0,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: value.data![0].image.toString(),
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/user_ph.jpeg',
                        fit: BoxFit.cover,

                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/user_ph.jpeg',

                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon: Icon(CupertinoIcons.clear_circled,color: Colors.white,))
                ],
              ),
            );
          });
    });
    // TODO: implement initState
    super.initState();
  }

  String token = "";

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context, listen: false);
    var remoteConfig = Provider.of<RemoteConfigProvider>(context);

    getReloadDataStatus();
    return RefreshIndicator(
      onRefresh: () {
        refreshData = true;
        setState(() {});
        return Future.value();
      },
      child: FutureProvider.value(
        value: DashboardServices().getDashboardData(
            context,
            state,
            user.getUserDetails() != null
                ? user.getUserDetails()!.data!.token.toString()
                : ""),
        initialData: DashboardModel(),
        builder: (context, child) {
          var _localListing = context.watch<DashboardModel>();

          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
              child: _localListing.data == null
                  ? Center(
                      child: ProcessingWidget(),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                if (remoteConfig
                                    .getRemoteConfig()!
                                    .sliderSection)
                                  if (_localListing.data!.poster!.isNotEmpty)
                                    Stack(
                                      children: [
                                        CarouselSlider(
                                          options: CarouselOptions(
                                              height: 230,
                                              viewportFraction: 1,
                                              enableInfiniteScroll: false),
                                          items: _localListing
                                              .data!
                                              .poster!
                                              .map((i) {
                                            return Builder(
                                              builder: (BuildContext context) {
                                                return PosterWidget(
                                                    model: _localListing
                                                            .data!
                                                            .poster![
                                                        _localListing
                                                            .data!
                                                            .poster!
                                                            .indexOf(i)]);
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                const SizedBox(height: 20),
                                if (_localListing
                                    .data!
                                    .categorySlider!
                                    .isNotEmpty)
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 13),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Categories – التصنيفات',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (user.getUserDetails() !=
                                                    null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoriesView()));
                                                } else {
                                                  getLoginFlushBar(context);
                                                }
                                              },
                                              child: Row(
                                                children: const [
                                                  Text(
                                                    'Show All',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black),
                                                  ),
                                                  Icon(Icons.arrow_right,
                                                      color: Colors.black)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 170,
                                        child: ListView.builder(
                                            itemCount: _localListing
                                                .data!
                                                .categorySlider!
                                                .length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, i) {
                                              return Row(
                                                children: [
                                                  if (i == 0)
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 3),
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (user.getUserDetails() !=
                                                            null) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ExploreView(
                                                                            category: Datum(
                                                                                name: _localListing.data!.categorySlider![i].name.toString(),
                                                                                id: _localListing.data!.categorySlider![i].id,
                                                                                productCount: _localListing.data!.categorySlider![i].productCount,
                                                                                image: _localListing.data!.categorySlider![i].image,
                                                                                children: _localListing.data!.categorySlider![i].children!.map((e) => Datum(id: e.id, productCount: e.productCount, image: e.image, name: e.name)).toList()),
                                                                          )));
                                                        } else {
                                                          getLoginFlushBar(
                                                              context);
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 140,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 140,
                                                              width: 160,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: _localListing
                                                                      .data!
                                                                      .categorySlider![
                                                                          i]
                                                                      .image
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                    'assets/images/ph.jpg',
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image
                                                                          .asset(
                                                                    'assets/images/ph.jpg',
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              _localListing
                                                                  .data!
                                                                  .categorySlider![
                                                                      i]
                                                                  .name
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 10),
                                if (_localListing
                                    .data!
                                    .lastestProduct!
                                    .isNotEmpty)
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 13),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'New – وصل حديثاً',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (user.getUserDetails() !=
                                                    null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LatestProductView()));
                                                } else {
                                                  getLoginFlushBar(context);
                                                }
                                              },
                                              child: Row(
                                                children: const [
                                                  Text(
                                                    'Show All',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black),
                                                  ),
                                                  Icon(Icons.arrow_right,
                                                      color: Colors.black)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7),
                                            itemCount: _localListing
                                                .data!
                                                .lastestProduct!
                                                .length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return ProductWidget(
                                                  model: _localListing
                                                      .data!
                                                      .lastestProduct![i],
                                                  categoryID: _localListing
                                                      .data!
                                                      .lastestProduct![i]
                                                      .categories![0]
                                                      .id
                                                      .toString());
                                            }),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 20),
                                if (_localListing
                                    .data!
                                    .topSellingProduct!
                                    .isNotEmpty)
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 13),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Top Selling – الأكثر مبيعاً',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (user.getUserDetails() !=
                                                    null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TopSellingProductsView()));
                                                } else {
                                                  getLoginFlushBar(context);
                                                }
                                              },
                                              child: Row(
                                                children: const [
                                                  Text(
                                                    'Show All',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black),
                                                  ),
                                                  Icon(Icons.arrow_right,
                                                      color: Colors.black)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7),
                                            itemCount: _localListing
                                                .data!
                                                .topSellingProduct!
                                                .length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return ProductWidget(
                                                  model: _localListing
                                                      .data!
                                                      .topSellingProduct![i],
                                                  categoryID: _localListing
                                                      .data!
                                                      .topSellingProduct![i]
                                                      .categories![0]
                                                      .id
                                                      .toString());
                                            }),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                if (remoteConfig
                                    .getRemoteConfig()!
                                    .couponSection)
                                  if (_localListing
                                      .data!
                                      .cuoponSlider!
                                      .isNotEmpty)
                                    CarouselSlider(
                                      options: CarouselOptions(
                                          height: 300,
                                          enableInfiniteScroll: false),
                                      items: _localListing
                                          .data!
                                          .cuoponSlider!
                                          .map((i) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 40),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color:
                                                            Color(0xB3BEC2CE),
                                                        spreadRadius: 5,
                                                        blurRadius: 20,
                                                        offset: Offset(0,
                                                            15) // changes position of shadow
                                                        ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            _localListing
                                                                .data!
                                                                .cuoponSlider!
                                                                .toString(),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          'assets/images/ph.jpg',
                                                          fit: BoxFit.cover,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'assets/images/ph.jpg',
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                const SizedBox(height: 30),
                                if (remoteConfig
                                    .getRemoteConfig()!
                                    .featuredSection)
                                  if (_localListing
                                      .data!
                                      .featuredProduct!
                                      .isNotEmpty)
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 13),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Featured – إخترنا لكم',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (user.getUserDetails() !=
                                                      null) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FeatProductsView()));
                                                  } else {
                                                    getLoginFlushBar(context);
                                                  }
                                                },
                                                child: Row(
                                                  children: const [
                                                    Text(
                                                      'Show All',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black),
                                                    ),
                                                    Icon(Icons.arrow_right,
                                                        color: Colors.black)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7),
                                            itemCount: _localListing
                                                .data!
                                                .featuredProduct!
                                                .length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return FeaturedProducts(
                                                model: _localListing
                                                    .data!
                                                    .featuredProduct![i],
                                              );
                                            }),
                                      ],
                                    ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
