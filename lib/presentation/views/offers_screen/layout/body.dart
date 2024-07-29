import 'dart:developer';

import 'package:beauty_arena_app/presentation/views/featured_products/all_prodcuts_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../application/app_state.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/offers.dart';
import '../../../../infrastructure/services/offers.dart';
import '../../../elements/processing_widget.dart';
import '../../../elements/select_type_container.dart';
import 'widgets/offers_widget.dart';

class OffersViewBody extends StatefulWidget {
  OffersViewBody({Key? key}) : super(key: key);

  @override
  State<OffersViewBody> createState() => _OffersViewBodyState();
}

class _OffersViewBodyState extends State<OffersViewBody> {
  bool isActiveSelected = true;

  bool isFinishedSelected = false;

  bool isAllSelected = false;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context);
    log(user.getUserDetails()!.data!.token.toString());
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Color(0xffF9F9F9)),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset('assets/icons/offers_icon.png',
                    width: 23.09, height: 26.52),
                const SizedBox(width: 10),
                const Text(
                  'Offers',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 13),
          //   child: Row(
          //     children: [
          //       SelectTypeContainer(
          //         text: 'ACTIVE',
          //         onTap: () {
          //           isAllSelected = false;
          //           isActiveSelected = true;
          //           isFinishedSelected = false;
          //           setState(() {});
          //         },
          //         isSelected: isActiveSelected,
          //       ),
          //       SelectTypeContainer(
          //         text: 'FINISHED',
          //         onTap: () {
          //           isAllSelected = false;
          //           isActiveSelected = false;
          //           isFinishedSelected = true;
          //           setState(() {});
          //         },
          //         isSelected: isFinishedSelected,
          //       ),
          //       SelectTypeContainer(
          //         text: 'ALL',
          //         onTap: () {
          //           isAllSelected = true;
          //           isActiveSelected = false;
          //           isFinishedSelected = false;
          //           setState(() {});
          //         },
          //         isSelected: isAllSelected,
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 30),
          FutureProvider.value(
            value: OfferServices().getAllOffers(context, state,
                user.getUserDetails()!.data!.token.toString(), '2'),
            initialData: OffersModel(),
            builder: (context, child) {
              var model = context.watch<OffersModel>();
              if (state.getStateStatus() == AppCurrentState.IsBusy) {
                return const Center(child: ProcessingWidget());
              } else if (state.getStateStatus() == AppCurrentState.IsError) {
                return const Text('No Internet');
              } else {
                return Expanded(
                  child: model.data!.isEmpty
                      ? const Center(
                          child: Text('There are no available offers!'),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: model.data!.length,
                          itemBuilder: (BuildContext context, int i) {
                            return OffersWidget(
                                onTap: () {
                                  if (model.data![i].product!.isEmpty) {
                                    return;
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllProductsView(
                                              productList:
                                                  model.data![i].product!,
                                              categoryID: model.data![i]
                                                  .product![0].categories![0].id
                                                  .toString())));
                                },
                                image: model.data![i].image.toString());
                          }),
                );
              }
            },
          )
        ],
      ),
    );
  }

  String getStatus() {
    if (isAllSelected) {
      return '1';
    } else if (isActiveSelected) {
      return '2';
    } else {
      return '3';
    }
  }
}
