import 'dart:async';
import 'package:beauty_arena_app/presentation/views/explore_screen/layout/widgets/explore_product_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../application/app_state.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/categories.dart' as C;
import '../../../../infrastructure/models/dashboard.dart';
import '../../../../infrastructure/models/product.dart';
import '../../../../infrastructure/services/product.dart';
import '../../../elements/processing_widget.dart';
import '../search_products_view.dart';

class SearchProductsViewBody extends StatelessWidget {
  final String brandID;
  final String brandName;

  const SearchProductsViewBody(
      {Key? key, required this.brandID, required this.brandName})
      : super(key: key);

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
          color: Colors.white),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    brandName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Products',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            FutureProvider.value(
              value: ProductServices().getProductsByBrandID(context, state,
                  user.getUserDetails()!.data!.token.toString(), brandID,1),
              initialData: ProductModel(),
              builder: (context, child) {
                var productModel = context.watch<ProductModel>();
                if (state.getStateStatus() == AppCurrentState.IsBusy) {
                  return const Center(child: ProcessingWidget());
                } else if (state.getStateStatus() == AppCurrentState.IsError) {
                  return const Text('No Internet');
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 4.3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 20),
                        itemCount: productModel.data!.data!.length,
                        itemBuilder: (BuildContext ctx, i) {
                          return ExploreProductWidget(
                            model: productModel.data!.data![i],
                            categoryID: productModel
                                .data!.data![i].categories![0].id
                                .toString(),
                          );
                        }),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
