import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../application/app_state.dart';
import '../../../../../application/user_provider.dart';
import '../../../../../configurations/enums.dart';
import '../../../../../infrastructure/models/order.dart';
import '../../../../../infrastructure/models/order_details.dart';
import '../../../../../infrastructure/services/order.dart';
import '../../../../elements/processing_widget.dart';

class OrdersWidget extends StatelessWidget {
  final Datum model;
  final bool showData;

  const OrdersWidget({Key? key, required this.model, required this.showData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3.5,
        shadowColor: const Color(0x4D000000),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${model.id.toString()}',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: getOrderColor(
                                model.status.toString().toLowerCase())),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2.5),
                          child: Text(
                            model.status.toString().toUpperCase(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (showData)
                FutureProvider.value(
                  value: OrdersServices().getOrderDetails(
                      context,
                      state,
                      user.getUserDetails()!.data!.token.toString(),
                      model.id.toString()),
                  initialData: OrderDetailsModel(),
                  builder: (context, child) {
                    var model = context.watch<OrderDetailsModel>();
                    if (state.getStateStatus() == AppCurrentState.IsBusy) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: const Center(child: ProcessingWidget()),
                      );
                    } else if (state.getStateStatus() ==
                        AppCurrentState.IsError) {
                      return const Text('No Internet');
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order Date:',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  model.data!.date.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status:',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  model.data!.status.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '₪${model.data!.total.toString()}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Order Details:',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 20),
                            ...model.data!.products!
                                .map((e) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 180,
                                          child: Text(
                                            e.name.toString(),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'x${e.qty.toString()}',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(width: 25),
                                            Text(
                                              '₪${e.price.toString()}',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                                .toList(),
                            SizedBox(height: 20),
                          ],
                        ),
                      );
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  Color getOrderColor(String status) {
    if (status == 'new order') {
      return const Color(0xffE49F00);
    } else if (status == 'completed') {
      return const Color(0xff4E9500);
    } else if (status == 'shipped') {
      return const Color(0xff005095);
    } else if (status == 'cancelled') {
      return const Color(0xffD40000);
    } else {
      return Colors.grey;
    }
  }
}
