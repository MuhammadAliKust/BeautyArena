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
import '../../../../configurations/front_end_configs.dart';
import '../../../../infrastructure/models/categories.dart' as C;
import '../../../../infrastructure/models/dashboard.dart';
import '../../../../infrastructure/models/product.dart';
import '../../../../infrastructure/models/related_products.dart';
import '../../../../infrastructure/models/searched_product.dart';
import '../../../../infrastructure/services/product.dart';
import '../../../elements/no_data_found.dart';
import '../../../elements/processing_widget.dart';
import '../../home_screen/layout/widgets/featured_product.dart';
import '../search_category_product.dart';

class SearchCategoryProductsViewBody extends StatefulWidget {
  final String categoryID;

  const SearchCategoryProductsViewBody({Key? key, required this.categoryID})
      : super(key: key);

  @override
  State<SearchCategoryProductsViewBody> createState() =>
      _SearchCategoryProductsViewBodyState();
}

class _SearchCategoryProductsViewBodyState
    extends State<SearchCategoryProductsViewBody> {
  bool showSearchData = false;

  SearchedProductModel? relatedList;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

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
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (val) {
                            isLoading = true;
                            relatedList = SearchedProductModel();
                            showSearchData = true;
                            setState(() {});
                            ProductServices()
                                .getSearchProductsByCategoryID(
                                    context,
                                    state,
                                    user
                                        .getUserDetails()!
                                        .data!
                                        .token
                                        .toString(),
                                    _searchController.text,
                                    widget.categoryID.toString())
                                .then((value) {
                              relatedList = value;
                              isLoading = false;
                              setState(() {});
                            });
                          },
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500),
                          cursorColor:
                              FrontEndConfigs.kGreyColor.withOpacity(0.2),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 15),
                            hintText: "What are you searching for?",
                            hintStyle: TextStyle(
                              color:
                                  FrontEndConfigs.kGreyColor.withOpacity(0.6),
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xffBEBEBE)),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xffBEBEBE)),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (relatedList != null)
                isLoading
                    ? Center(
                        child: ProcessingWidget(),
                      )
                    : relatedList!.data!.data!.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 100,
                              ),
                              NoDataFoundView(
                                  description:
                                      'Sorry! We cannot find your desired product.'),
                            ],
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: relatedList!.data!.data!.length,
                            itemBuilder: (BuildContext ctx, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: FeaturedProducts(
                                   model: Product(
                                      id: relatedList!.data!.data![i].id,
                                      name:  relatedList!.data!.data![i].name,
                                      price:  relatedList!.data!.data![i].price,
                                      image: relatedList!.data!.data![i].image,
                                      images: relatedList!.data!.data![i].images,
                                      description: relatedList!.data!.data![i].description,
                                      inventory:relatedList!.data!.data![i].inventory,
                                      status: relatedList!.data!.data![i].status,
                                      sku: relatedList!.data!.data![i].sku,
                                      type:relatedList!.data!.data![i].type,
                                      brand: relatedList!.data!.data![i].brand,
                                      crossSellingProducts:[],
                                      categories:relatedList!.data!.data![i].categories,
                                      offer: relatedList!.data!.data![i].offer,
                                      salePrice: relatedList!.data!.data![i].salePrice,
                                      offer_percentage: relatedList!.data!.data![i].offerPercentage,
                                      favorite:relatedList!.data!.data![i].favorite,
                                      outOfStock: relatedList!.data!.data![i].outOfStock,
                                    )),
                              );
                            })
            ],
          ),
        ),
      ),
    );
  }
}
