import 'dart:async';
import 'dart:developer';

import 'package:beauty_arena_app/presentation/views/fav_products/fav_products_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../application/app_state.dart';
import '../../../../application/errorStrings.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/delete.dart';
import '../../../../infrastructure/models/device_token.dart';
import '../../../../infrastructure/services/auth.dart';
import '../../../../infrastructure/services/notification.dart';
import '../../../elements/app_button_primary.dart';
import '../../../elements/dialogue_boxes/are_you_sure.dart';
import '../../../elements/navigation_dialog.dart';
import '../../../elements/notification_widget.dart';
import '../../../elements/processing_widget.dart';
import '../../my_orders_screen/my_orders_view.dart';
import '../../update_profile_screen/update_profile_view.dart';
import '../../welcome_screen/welcome_view.dart';
import 'widgets/my_account_widget.dart';

class MyAccountViewBody extends StatefulWidget {
  MyAccountViewBody({Key? key}) : super(key: key);

  @override
  State<MyAccountViewBody> createState() => _MyAccountViewBodyState();
}

class _MyAccountViewBodyState extends State<MyAccountViewBody> {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    var error = Provider.of<ErrorString>(context);
    var user = Provider.of<UserProvider>(context);
    return StreamProvider.value(
        value: NotificationServices().getNotificationToken(
            user.getUserDetails()!.data!.customer!.id.toString()),
        initialData: NotificationTokenModel(),
        builder: (context, child) {
          var model = context.watch<NotificationTokenModel>();
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Color(0xffF9F9F9)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Image.asset('assets/icons/user_icon.png',
                            width: 21.09, height: 24.52),
                        const SizedBox(width: 10),
                        const Text(
                          'My Account',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Container(
                            height: 130.44,
                            width: 130.44,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: CachedNetworkImage(
                                imageUrl: user
                                    .getUserDetails()!
                                    .data!
                                    .customer!
                                    .image
                                    .toString(),
                                height: 130.44,
                                width: 130.44,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Image.asset(
                                  'assets/images/user_ph.jpeg',
                                  fit: BoxFit.cover,
                                  height: 130.44,
                                  width: 130.44,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/user_ph.jpeg',
                                  height: 130.44,
                                  width: 130.44,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                        const SizedBox(height: 7),
                        Text(
                          user
                              .getUserDetails()!
                              .data!
                              .customer!
                              .name
                              .toString(),
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        Text(
                          user
                              .getUserDetails()!
                              .data!
                              .customer!
                              .customerMobile
                              .toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0x66000000)),
                        ),
                        const SizedBox(height: 30),
                        MyAccountWidget(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateProfileView()));
                            },
                            text: 'My Profile',
                            image: 'assets/icons/user_black_icon.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        MyAccountWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FavProductsView()));
                            },
                            text: 'Favorite Products',
                            image: 'assets/images/heart.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        MyAccountWidget(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyOrdersView()));
                            },
                            text: 'My Orders',
                            image: 'assets/icons/shopping_cart_black_icon.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        NotificationWidget(
                            onTap: (val) {
                              if (model.deviceTokens.toString().isEmpty) {
                                _initFcm(user
                                    .getUserDetails()!
                                    .data!
                                    .customer!
                                    .id
                                    .toString());
                              } else {
                                FirebaseFirestore.instance
                                    .collection('deviceTokens')
                                    .doc(user
                                        .getUserDetails()!
                                        .data!
                                        .customer!
                                        .id
                                        .toString())
                                    .set(
                                  {
                                    'deviceTokens': "",
                                  },
                                );
                              }
                            },
                            isEnabled: model.deviceTokens.toString().isNotEmpty,
                            text: 'Notifications',
                            image: 'assets/icons/shopping_cart_black_icon.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        MyAccountWidget(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (ctx) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 30),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 50),
                                                    Image.asset(
                                                        'assets/images/delete-account.png',
                                                        width: 96.86,
                                                        height: 97.79),
                                                    SizedBox(height: 20),
                                                    const Text(
                                                      'Are You Sure?',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 30),
                                                      child: const Text(
                                                        'Deleting your account will remove all your details from our system. This action is irreversible.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.3,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(height: 40),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40),
                                                      child: AppButtonPrimary(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor:
                                                              Colors.white,
                                                          text: 'Go Back'),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 40),
                                                      child: Consumer<AppState>(
                                                        builder: (context,
                                                            state, child) {
                                                          return state.getStateStatus() ==
                                                                  AppCurrentState
                                                                      .IsBusy
                                                              ? Center(
                                                                  child:
                                                                      ProcessingWidget(),
                                                                )
                                                              : AppButtonPrimary(
                                                                  onTap:
                                                                      () async {
                                                                    try {
                                                                      await AuthServices().deleteUser(
                                                                          context,
                                                                          token: user
                                                                              .getUserDetails()!
                                                                              .data!
                                                                              .token
                                                                              .toString(),
                                                                          state:
                                                                              state);
                                                                      if (state
                                                                              .getStateStatus() ==
                                                                          AppCurrentState
                                                                              .IsFree) {
                                                                        Navigator.pushAndRemoveUntil(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => WelcomeView()),
                                                                            (route) => false);
                                                                      }
                                                                    } catch (e) {
                                                                      print(e
                                                                          .toString());
                                                                    }
                                                                  },
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xffC70000),
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  text:
                                                                      'Delete my Account');
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )).then((value) {});
                            },
                            text: 'Delete Account',
                            image: 'assets/icons/close_icon.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        MyAccountWidget(
                            onTap: () async {
                              var prefs = await SharedPreferences.getInstance();
                              await showNavigationDialog(context,
                                  message:
                                      'Do you really want to logout from app?',
                                  buttonText: 'Yes', navigation: () {
                                prefs.clear();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeView()),
                                    (route) => false);
                                user.clearData();
                              },
                                  secondButtonText: 'No',
                                  showSecondButton: true);
                            },
                            text: 'Logout',
                            image: 'assets/icons/logout_icon.png'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> _initFcm(String userID) async {
    await FirebaseMessaging.instance.subscribeToTopic('BEAUTY_ARENA');
    await FirebaseMessaging.instance.getToken().then((token) {
      if (kDebugMode) {
        print(token);
      }
      FirebaseFirestore.instance.collection('deviceTokens').doc(userID).set(
        {
          'deviceTokens': token,
        },
      );
    });
  }
}
