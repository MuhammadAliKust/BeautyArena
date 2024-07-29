import 'dart:async';
import 'dart:developer';
import 'package:beauty_arena_app/presentation/views/explore_screen/layout/widgets/explore_product_widget.dart';
import 'package:beauty_arena_app/presentation/views/search_category/search_category_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../application/app_state.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/categories.dart' as C;
import '../../../../infrastructure/models/dashboard.dart';
import '../../../../infrastructure/models/product.dart';
import '../../../../infrastructure/services/product.dart';
import '../../../elements/processing_widget.dart';
import '../explore_view.dart';

class ExploreViewBody extends StatefulWidget {
  final C.Datum model;

  const ExploreViewBody({Key? key, required this.model}) : super(key: key);

  @override
  State<ExploreViewBody> createState() => _ExploreViewBodyState();
}

class _ExploreViewBodyState extends State<ExploreViewBody> {
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
      }).onError((error, stackTrace) {
        log(error.toString());
      });
    });
    super.initState();
  }

  Future<bool> getApiData({bool isRefresh = false}) async {
    log("Condition : ${currentPage >= totalPages}");
    if (isRefresh) {
      currentPage = 1;
      isNetworkCall = true;
    } else {
      if (currentPage > totalPages) {
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
      }).onError((error, stackTrace) {
        log(error.toString());
      });
      return true;
    } catch (e) {
      log(e.toString());
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
    var state = Provider.of<AppState>(context, listen: false);

    ProductModel model = await ProductServices().getAllProducts(
        context,
        state,
        user.getUserDetails()!.data!.token.toString(),
        currentPage,
        widget.model.id.toString());
    return model;
  }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.model.children != null)
            if (widget.model.children!.isNotEmpty)
              Container(
                width: MediaQuery.of(context).size.width,
                color: Color(0xffF6F6F6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.model.children!.isNotEmpty) SizedBox(height: 20),
                    if (widget.model.children!.isNotEmpty)
                      Container(
                        height: 190,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            itemCount: widget.model.children!.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ExploreView(
                                                category: widget
                                                    .model.children![i])));
                                  },
                                  child: Container(
                                    width: 140,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 130,
                                          width: 130,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: widget
                                                  .model.children![i].image
                                                  .toString(),
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                'assets/images/ph.jpg',
                                                fit: BoxFit.fill,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                'assets/images/ph.jpg',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          widget.model.children![i].name
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                  ],
                ),
              ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.search, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchCategoryProductsView(
                                categoryID: widget.model.id.toString())));
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
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
                          physics: NeverScrollableScrollPhysics(),
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
                                outOfStock: _localList[i].outOfStock,
                                offer: _localList[i].offer,
                                salePrice: _localList[i].salePrice,
                              ),
                              categoryID:
                                  _localList[i].categories![0].id.toString(),
                            );
                          }),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
