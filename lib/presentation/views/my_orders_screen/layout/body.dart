import 'dart:async';
import 'package:beauty_arena_app/presentation/views/my_orders_screen/layout/widgets/order_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../application/app_state.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/order.dart';
import '../../../../infrastructure/services/order.dart';
import '../../../elements/processing_widget.dart';

class MyOrdersViewBody extends StatefulWidget {
  const MyOrdersViewBody({Key? key}) : super(key: key);

  @override
  State<MyOrdersViewBody> createState() => _MyOrdersViewBodyState();
}

class _MyOrdersViewBodyState extends State<MyOrdersViewBody> {
  String selectedID = "";
  bool isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Color(0xffF9F9F9)),
      child: Column(
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Image.asset('assets/images/shopping_cart_black_img.png',
                    width: 24.12, height: 24.09),
                SizedBox(width: 10),
                Text(
                  'My Orders',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          FutureProvider.value(
            value: OrdersServices().getAllOrders(
                context, state, user.getUserDetails()!.data!.token.toString()),
            initialData: OrdersModel(),
            builder: (context, child) {
              var model = context.watch<OrdersModel>();
              if (state.getStateStatus() == AppCurrentState.IsBusy && isFirstLoad) {
                return const Center(child: ProcessingWidget());
              } else if (state.getStateStatus() == AppCurrentState.IsError) {
                return const Text('No Internet');
              } else {
                isFirstLoad = false;
                return Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: model.data!.length,
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          onTap: () {
                            selectedID = model.data![i].id.toString();
                            setState(() {});
                          },
                          child: OrdersWidget(
                            model: model.data![i],
                            showData:
                                selectedID == model.data![i].id.toString(),
                          ),
                        );
                      }),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
