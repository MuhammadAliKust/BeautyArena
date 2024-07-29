import 'dart:developer';
import 'dart:io';

import 'package:beauty_arena_app/application/app_state.dart';
import 'package:beauty_arena_app/presentation/views/fav_products/fav_products_view.dart';
import 'package:beauty_arena_app/presentation/views/page/page_details.dart';
import 'package:beauty_arena_app/presentation/views/search_view.dart';
import 'package:beauty_arena_app/presentation/views/welcome_screen/welcome_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../../application/bottom_index.dart';
import '../../application/cart_provider.dart';
import '../../application/remote_config_provider.dart';
import '../../application/user_provider.dart';
import '../../configurations/front_end_configs.dart';
import '../../infrastructure/models/page.dart';
import '../../infrastructure/services/local.dart';
import '../../infrastructure/services/page.dart';
import '../../packages/custom_nav_bar/custom_nav_bar.dart';
import '../elements/dialogue_boxes/contact_us.dart';
import '../elements/flush_bar.dart';
import '../elements/navigation_dialog.dart';
import 'brand_screen/brands_view.dart';
import 'cart_screen/cart_view.dart';
import 'categories_screen/categories_view.dart';
import 'fav_products/layout/body.dart';
import 'home_screen/home_view.dart';
import 'login_screen/login_view.dart';
import 'marina/marina_view.dart';
import 'my_account_screen/my_account_view.dart';
import 'notification_screen/notification_view.dart';
import 'offers_screen/offers_view.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool refreshData = false;

  @override
  void initState() {
    final newVersion = NewVersionPlus(
      iOSId: 'com.element.beautyArenaApp',
      androidId: 'com.element.beauty_arena',
    );

    advancedStatusCheck(newVersion);
    super.initState();
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      if (status.canUpdate)
        newVersion.showUpdateDialog(
          context: context,
          // launchMode: LaunchMode.externalApplication,
          versionStatus: status,
          allowDismissal: true,
          dialogTitle: 'Update!',
          dialogText:
              "A new version of the application is available! Download it from the stores.",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false);
    var cart = Provider.of<CartProvider>(context);
    var bottomIndex = Provider.of<BottomIndexProvider>(context);

    var remoteConfig =
        Provider.of<RemoteConfigProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (bottomIndex.getBottomIndex() == 0) {
          return await showNavigationDialog(context,
              message: 'Do you really want to exit from app?',
              buttonText: 'Yes', navigation: () {
            exit(0);
          }, secondButtonText: 'No', showSecondButton: true);
        } else {
          bottomIndex.saveBottomIndex(0);
          setState(() {});
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Image.asset('assets/images/logo.png',
              color: Colors.white, width: 133.48, height: 23.57),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    if (user.getUserDetails() != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchView()));
                    } else {
                      getLoginFlushBar(context);
                    }
                  },
                ),
                IconButton(
                  icon: cart.cartItems.isEmpty
                      ? const Icon(CupertinoIcons.cart, color: Colors.white)
                      : Badge(
                          largeSize: 12,
                          smallSize: 12,
                          label: Text(cart.cartItems.length.toString()),
                          child: const Icon(CupertinoIcons.cart,
                              color: Colors.white)),
                  onPressed: () {
                    if (user.getUserDetails() != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartView()));
                    } else {
                      getLoginFlushBar(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          shadowColor: Color(0x66000000),
          backgroundColor: Colors.white,
          child: RefreshIndicator(
            onRefresh: () {
              refreshData = true;
              setState(() {});
              return Future.value();
            },
            child: FutureProvider.value(
                value: PageServices().fetchPages(
                    context,
                    user.getUserDetails() != null
                        ? user.getUserDetails()!.data!.token.toString()
                        : "N/A"),
                initialData: PageModel(),
                builder: (context, child) {
                  PageModel _pageModel = context.watch<PageModel>();
                  if (refreshData == true) {
                    if (_pageModel.data != null) {
                      CacheServices.instance.writePageListing(_pageModel);
                      Future.delayed(Duration.zero, () {
                        setState(() {});
                        refreshData = false;
                      });
                    }
                  }
                  return FutureProvider.value(
                      value: CacheServices.instance.readPageListing(),
                      initialData: [PageModel()],
                      builder: (context, child) {
                        List<PageModel> _localListing =
                            context.watch<List<PageModel>>();
                        if (_localListing.isEmpty) {
                          if (_pageModel.data != null) {
                            CacheServices.instance.writePageListing(_pageModel);
                            Future.delayed(Duration.zero, () {
                              setState(() {});
                            });
                          }
                        }
                        return ListView(
                            // Important: Remove any padding from the ListView.
                            padding: EdgeInsets.zero,
                            children: [
                              if (user.getUserDetails() != null)
                                DrawerHeader(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.close)),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(70),
                                              child: CachedNetworkImage(
                                                imageUrl: user
                                                    .getUserDetails()!
                                                    .data!
                                                    .customer!
                                                    .image
                                                    .toString(),
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                  'assets/images/user_ph.jpeg',
                                                  fit: BoxFit.cover,
                                                  height: 70,
                                                  width: 70,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  'assets/images/user_ph.jpeg',
                                                  height: 70,
                                                  width: 70,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 17),
                                          Container(
                                            width: 170,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  user
                                                      .getUserDetails()!
                                                      .data!
                                                      .customer!
                                                      .name
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  user
                                                      .getUserDetails()!
                                                      .data!
                                                      .customer!
                                                      .customerMobile
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color(0x66000000),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 100,
                                ),
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  bottomIndex.saveBottomIndex(0);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/drawer_home.png',
                                          height: 20,
                                          width: 17.12),
                                      SizedBox(width: 15),
                                      Text(
                                        'Home',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (user.getUserDetails() != null)
                                InkWell(
                                  onTap: () {
                                    if (user.getUserDetails() != null) {
                                      bottomIndex.saveBottomIndex(1);
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginView()));
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/drawer_my_account.png',
                                            height: 14.68,
                                            width: 19.59),
                                        SizedBox(width: 15),
                                        Text(
                                          'My Account',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (user.getUserDetails() != null)
                              InkWell(
                                onTap: () {
                                  if (user.getUserDetails() != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationView()));
                                  } else {
                                    getLoginFlushBar(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/notification_icon.png',
                                          height: 19.59,
                                          width: 13.06),
                                      SizedBox(width: 15),
                                      Text(
                                        'Notifications',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (user.getUserDetails() != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoriesView()));
                                  } else {
                                    getLoginFlushBar(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/drawer_categories.png',
                                          height: 19.59,
                                          width: 13.06),
                                      SizedBox(width: 15),
                                      Text(
                                        'Categories',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (user.getUserDetails() != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BrandsView()));
                                  } else {
                                    getLoginFlushBar(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/drawer_brands.png',
                                          height: 19.54,
                                          width: 19.54),
                                      SizedBox(width: 15),
                                      Text(
                                        'Brands',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_localListing.isNotEmpty)
                                if (_localListing[0].data != null)
                                  ..._localListing[0].data!.map((e) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PageDetailsView(model: e)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 15),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                'assets/images/drawer_brands.png',
                                                height: 19.54,
                                                width: 19.54),
                                            SizedBox(width: 15),
                                            Container(
                                              width: 160,
                                              child: Text(
                                                e.pageTitle.toString(),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              if (user.getUserDetails() != null)
                                InkWell(
                                  onTap: () async {
                                    var prefs =
                                        await SharedPreferences.getInstance();
                                    await showNavigationDialog(context,
                                        message:
                                            'Do you really want to logout from app?',
                                        buttonText: 'Yes', navigation: () {
                                      prefs.clear();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WelcomeView()),
                                          (route) => false);
                                      user.clearData();
                                    },
                                        secondButtonText: 'No',
                                        showSecondButton: true);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/drawer_logout.png',
                                            height: 20,
                                            width: 20.78),
                                        SizedBox(width: 15),
                                        Text(
                                          'Logout',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginView()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/drawer_settings.png',
                                            height: 19.22,
                                            width: 18.18),
                                        SizedBox(width: 15),
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              SizedBox(height: 50),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (ctx) => Contactus(
                                          whatsapp: remoteConfig
                                              .getRemoteConfig()!
                                              .whatsappNumber
                                              .toString()));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.black),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.local_phone_sharp,
                                              color: Colors.white),
                                          SizedBox(width: 7),
                                          Text(
                                            'Contact Support',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ]);
                      });
                }),
          ),
        ),
        body: [
          HomeScreenView(),
          if (user.getUserDetails() != null) MyAccountView() else LoginView(),
          if (user.getUserDetails() != null)
            FavProductsViewBody()
          else
            LoginView(),
          if (user.getUserDetails() != null) OffersView() else LoginView(),
          if (user.getUserDetails() != null)
            MarinaView()
          else
            LoginView(),
        ].elementAt(bottomIndex.getBottomIndex()),
        bottomNavigationBar: BottomIndicatorBar(
          currentIndex: bottomIndex.getBottomIndex(),
          onTap: (index) {
            bottomIndex.saveBottomIndex(index);
            setState(() {});
          },
          items:
              FrontEndConfigs.getBottomNavBarItem(bottomIndex.getBottomIndex()),
          activeColor: Colors.teal,
          inactiveColor: Colors.grey,
          indicatorColor: FrontEndConfigs.kPrimaryColor,
        ),
      ),
    );
  }
}
