import 'dart:async';
import 'dart:developer';
import 'package:beauty_arena_app/presentation/views/explore_screen/layout/widgets/explore_product_widget.dart';
import 'package:beauty_arena_app/presentation/views/feat_products/feat_products_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../application/app_state.dart';
import '../../../../application/errorStrings.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/categories.dart' as C;
import '../../../../infrastructure/models/dashboard.dart';
import '../../../../infrastructure/models/product.dart';
import '../../../../infrastructure/models/related_products.dart';
import '../../../../infrastructure/models/searched_product.dart';
import '../../../../infrastructure/services/product.dart';
import '../../../elements/no_data_found.dart';
import '../../../elements/processing_widget.dart';
import '../../home_screen/layout/widgets/featured_product.dart';
import '../filter_products_view.dart';

class FilteredProductsViewBody extends StatelessWidget {
  final String name;
  final String brandID;
  final String categoryID;
  final int priceOrder;
  final String productType;

  FilteredProductsViewBody(
      {Key? key,
      required this.name,
      required this.categoryID,
      required this.priceOrder,
      required this.productType,
      required this.brandID})
      : super(key: key);

  RelatedProductsModel? testModel;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context);
    var error = Provider.of<ErrorString>(context, listen: false);

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
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Search Results',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            FutureProvider.value(
              value: ProductServices().getSearchedProducts(
                context,
                state,
                user.getUserDetails()!.data!.token.toString(),
                name,
                brandID,
                categoryID,
                productType,
                1,
                priceOrder,
              ),
              initialData: SearchedProductModel(),
              catchError: (context, e) {
                state.stateStatus(AppCurrentState.IsError);
                error.saveErrorString(e.toString());
                log(e.toString());
              },
              builder: (context, child) {
                var productModel = context.watch<SearchedProductModel?>();
                if (state.getStateStatus() == AppCurrentState.IsBusy) {
                  return const Center(child: ProcessingWidget());
                } else if (state.getStateStatus() == AppCurrentState.IsError) {
                  return Text(error.getErrorString());
                } else {
                  return productModel!.data == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            NoDataFoundView(
                              description:
                                  'Sorry! We cannot find your desired product.',
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: productModel.data!.data!.length,
                              itemBuilder: (BuildContext ctx, i) {
                                return FeaturedProducts(
                                  model: Product(
                                    id: productModel.data!.data![i].id,
                                    name: productModel.data!.data![i].name,
                                    price: productModel.data!.data![i].price,
                                    image: productModel.data!.data![i].image,
                                    images: productModel.data!.data![i].images,
                                    description:
                                        productModel.data!.data![i].description,
                                    inventory:
                                        productModel.data!.data![i].inventory,
                                    status: productModel.data!.data![i].status,
                                    sku: productModel.data!.data![i].sku,
                                    type: productModel.data!.data![i].type,
                                    brand: productModel.data!.data![i].brand,
                                    crossSellingProducts: [],
                                    categories:
                                        productModel.data!.data![i].categories,
                                    offer: productModel.data!.data![i].offer,
                                    salePrice:
                                        productModel.data!.data![i].salePrice,
                                    offer_percentage: productModel
                                        .data!.data![i].offerPercentage,
                                    favorite:
                                        productModel.data!.data![i].favorite,
                                    outOfStock:
                                        productModel.data!.data![i].outOfStock,
                                  ),
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
