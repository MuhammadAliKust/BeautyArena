import 'dart:developer';

import 'package:beauty_arena_app/application/app_state.dart';
import 'package:beauty_arena_app/application/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/dashboard.dart';
import '../../../../infrastructure/models/product.dart';
import '../../../../infrastructure/services/product.dart';
import '../../../elements/processing_widget.dart';
import '../../explore_screen/layout/widgets/explore_product_widget.dart';

class TopSellingProductsViewBody extends StatefulWidget {
  @override
  State<TopSellingProductsViewBody> createState() =>
      _TopSellingProductsViewBodyState();
}

class _TopSellingProductsViewBodyState
    extends State<TopSellingProductsViewBody> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool? isConnected;
  bool isNetworkCall = false;
  List<Datum> _localList = [];
  ProductModel? _model;
  int currentPage = 0;

  int totalPages = 2;

  void _onRefresh() async {
    checkConnection();
    if (mounted) setState(() {});
    isNetworkCall = true;
    Future.delayed(Duration(seconds: 2), () {
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
    });
  }

  checkConnection() async {
    return await InternetConnectionChecker().hasConnection.then((value) {
      isConnected = value;
      setState(() {});
    });
  }

  @override
  void initState() {
    checkConnection().then((value) async {
      await getApiCall(true).then((value) {
        _localList = value.data!.data!;
        setState(() {});
      });
    });
    super.initState();
  }

  Future<bool> getApiData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      isNetworkCall = true;
    } else {
      if (currentPage >= totalPages) {
        _refreshController.loadNoData();
        return false;
      }
    }
    try {
      await getApiCall(isRefresh).then((value) async {
        if (isRefresh == true) {
          _localList = value.data!.data!;
          totalPages = value.data!.meta!.lastPage!;
        } else {
          print("Called");
          value.data!.data!.map((e) {
            bool contain = _localList.any((item) => item.id == e.id);
            if (!contain) //not already in list
            {
              _localList.add(e);
            }
          }).toList();
        }
        totalPages = value.data!.meta!.lastPage!;
        setState(() {});
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> getApiCall(bool isRefresh) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    if (!isRefresh) {
      currentPage += 1;
      setState(() {});
    } else {
      currentPage = 1;
      setState(() {});
      _refreshController.loadComplete();
    }
    ProductModel model = await ProductServices().getTopSellingProducts(
        context, user.getUserDetails()!.data!.token.toString(), currentPage);
    log(model.toJson().toString());
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_localList.isEmpty && isConnected == false) ...[
          Center(
            child: Text("Kindly check your internet connection."),
          ),
        ] else ...[
          Expanded(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              onRefresh: () async {
                final result = await getApiData(isRefresh: true);
                if (result) {
                  _refreshController.refreshCompleted();
                } else {
                  _refreshController.refreshFailed();
                }
              },
              header: WaterDropHeader(),
              onLoading: () async {
                log("Loading Called");
                isNetworkCall = true;
                setState(() {});
                final result = await getApiData(isRefresh: false);
                if (result) {
                  _refreshController.loadComplete();
                } else {
                  if (currentPage >= totalPages) {
                    _refreshController.loadNoData();
                  } else {
                    _refreshController.loadFailed();
                  }
                }
              },
              child: _localList.isEmpty
                  ? Center(
                      child: ProcessingWidget(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 3 / 4.3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 20),
                          itemCount: _localList.length,
                          itemBuilder: (BuildContext ctx, i) {
                            return ExploreProductWidget(
                              model: Datum(
                                id: _localList[i].id,
                                name: _localList[i].name,
                                price: _localList[i].price,
                                image: _localList[i].image,
                                status: _localList[i].status,
                                images: _localList[i].images,
                                description: _localList[i].description,
                                crossSellingProducts:
                                    _localList[i].crossSellingProducts,
                                inventory: _localList[i].inventory,
                                type: '',
                                offer: _localList[i].offer,
                                salePrice: _localList[i].salePrice,
                              ),
                              categoryID:
                                  _localList[i].categories![0].id.toString(),
                            );
                          }),
                    ),
            ),
          ),
        ]
      ],
    );
  }
}
