import 'dart:async';
import 'dart:developer';
import 'package:beauty_arena_app/application/cart_provider.dart';
import 'package:beauty_arena_app/infrastructure/models/cart.dart';
import 'package:beauty_arena_app/presentation/elements/flush_bar.dart';
import 'package:beauty_arena_app/presentation/views/brand_screen/brands_view.dart';
import 'package:beauty_arena_app/presentation/views/single_product/single_product_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../application/remote_config_provider.dart';
import '../../../../application/user_provider.dart';
import '../../../../infrastructure/models/city.dart';
import '../../../../infrastructure/models/user.dart';
import '../../../../infrastructure/services/city.dart';
import '../../../../infrastructure/services/dashboard.dart';
import '../../../../infrastructure/services/local.dart';
import '../../../../main.dart';
import '../../bottom_bar.dart';
import '../../onboarding_screen/onboarding_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../welcome_screen/welcome_view.dart';

class SplashViewBody extends StatefulWidget {
  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  CityModel? _citiesList;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future getData(BuildContext cont) async {
    var prefs = await SharedPreferences.getInstance();
    var userProvider = Provider.of<UserProvider>(cont, listen: false);
    var cartProvider = Provider.of<CartProvider>(cont, listen: false);
    if (prefs.getString('USER_DATA') != null) {
      var model = userModelFromJson(prefs.getString('USER_DATA'));

      userProvider.saveUserDetails(model);
    }

    if (prefs.getString('CART_DATA') != null) {
      var cartModel = cartModelFromJson(prefs.getString('CART_DATA'));
      cartProvider.setCartList(cartModel);
    }

    return Future.value(true);
  }

  // Fetching, caching, and activating remote config
  Future _initConfig() async {
    try {
      var remoteConfig =
          Provider.of<RemoteConfigProvider>(context, listen: false);
      await _remoteConfig
          .setConfigSettings(RemoteConfigSettings(
        // cache refresh time
        fetchTimeout: const Duration(seconds: 20),
        // a fetch will wait up to 10 seconds before timing out
        minimumFetchInterval: const Duration(seconds: 10),
      ))
          .onError((error, stackTrace) {
        log(error.toString());
      });
      return await _remoteConfig.fetchAndActivate().then((value) {
        remoteConfig.saveRemoteConfig(RemoteConfigModel(
            baseUrl: _remoteConfig.getString('Base_Url'),
            enableGuestBrowsing: _remoteConfig.getBool('Enable_Guest_Browsing'),
            couponSection: _remoteConfig.getBool('Section_Coupons'),
            featuredSection: _remoteConfig.getBool('Section_FeaturedProducts'),
            onBoardingSection: _remoteConfig.getBool('Section_OnBoarding'),
            sliderSection: _remoteConfig.getBool('Section_Slider'),
            whatsappNumber: _remoteConfig.getString('Whatsapp_Number')));
      });
    } catch (e) {
      getFlushBar(context, title: "Something went wrong.");
    }
  }

  void setTimer() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('time') == null) {
      if (prefs.getBool('showRateUs') == null) {
        prefs.setString('time', DateTime.now().toIso8601String());
      }
    }
  }

  subscribe() async {
    await FirebaseMessaging.instance.subscribeToTopic('BEAUTY_ARENA');
  }

  @override
  void initState() {
    // subscribe();
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint(value.toString());
    });
    FirebaseAuth.instance.signInAnonymously();
    setTimer();

    var remoteConfig =
        Provider.of<RemoteConfigProvider>(context, listen: false);
    _initConfig().then((value) {
      CityServices().getAllCities(context).then((value) async {
        _citiesList = value;
        if (value.data != null) {
          await CacheServices.instance.writeCities(value);
          var prefs = await SharedPreferences.getInstance();

          setState(() {});
          try {
            FirebaseDynamicLinks.instance.onLink
                .listen((PendingDynamicLinkData dynamicLinkData) async {
              getData(navigatorKey.currentContext!).then((value) async {
                if (value != null) {
                  if (dynamicLinkData.link.queryParameters.containsKey('id')) {
                    String? id = dynamicLinkData.link.queryParameters['id'];
                    Navigator.pushAndRemoveUntil(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(
                            builder: (context) =>
                                SingleProductView(productID: id.toString())),
                        (route) => false);
                  }else{
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => WelcomeView()));
                  }
                } else {
                  await Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomeView()));
                }
              });
            });
          } catch (e) {
            getData(navigatorKey.currentContext!).then((user) {
              SharedPreferences.getInstance().then((prefs) async {
                if (remoteConfig.getRemoteConfig()!.onBoardingSection == true) {
                  if (prefs.getString('LOGIN_STATUS') == null) {
                    await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnboardingView()));
                  } else {
                    await getData(context).then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavBar()),
                          (route) => false);
                    });
                  }
                } else {
                  if (prefs.getString('LOGIN_STATUS') == null) {
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => WelcomeView()));
                  } else {
                    await getData(context).then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavBar()),
                          (route) => false);
                    });
                  }
                }
              });
            });
          }
          await FirebaseDynamicLinks.instance
              .getInitialLink()
              .then((value) async {
            getData(navigatorKey.currentContext!).then((user) {
              SharedPreferences.getInstance().then((prefs) async {
                if (value != null) {
                  log(value.toString());
                  if (value.link.queryParameters.containsKey('id')) {
                    String? id = value.link.queryParameters['id'];

                    Navigator.pushAndRemoveUntil(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(
                            builder: (context) =>
                                SingleProductView(productID: id.toString())),
                        (route) => false);
                  }
                } else {
                  if (remoteConfig.getRemoteConfig()!.onBoardingSection ==
                      true) {
                    if (prefs.getString('LOGIN_STATUS') == null) {
                      await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnboardingView()));
                    } else {
                      await getData(context).then((value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavBar()),
                            (route) => false);
                      });
                    }
                  } else {
                    if (prefs.getString('LOGIN_STATUS') == null) {
                      await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeView()));
                    } else {
                      await getData(context).then((value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavBar()),
                            (route) => false);
                      });
                    }
                  }
                }
              });
            });
          });
        }else{
          await Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => WelcomeView()));
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset('assets/images/logo.png', height: 270, width: 270));
  }
}
