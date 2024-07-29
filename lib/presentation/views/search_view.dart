import 'dart:developer';

import 'package:beauty_arena_app/infrastructure/models/dashboard.dart';
import 'package:beauty_arena_app/infrastructure/models/searched_product.dart'
    as SP;
import 'package:beauty_arena_app/presentation/elements/no_data_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../application/app_state.dart';
import '../../application/cart_provider.dart';
import '../../application/errorStrings.dart';
import '../../application/user_provider.dart';
import '../../configurations/enums.dart';
import '../../configurations/front_end_configs.dart';
import '../../infrastructure/models/brand.dart' as Brand;
import '../../infrastructure/models/categories.dart' as Category;
import '../../infrastructure/models/product.dart';
import '../../infrastructure/models/related_products.dart';
import '../../infrastructure/services/brands.dart';
import '../../infrastructure/services/categories.dart';
import '../../infrastructure/services/product.dart';
import '../elements/app_button_primary.dart';
import '../elements/auth_text_field.dart';
import '../elements/flush_bar.dart';
import '../elements/processing_widget.dart';
import '../elements/select_type_container.dart';
import 'brands_products/layout/widgets/explore_product_widget.dart';
import 'cart_screen/cart_view.dart';
import 'filtered_products/filter_products_view.dart';
import 'home_screen/layout/widgets/featured_product.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  int productType = 0;
  int priceOrder = 1;
  Brand.Datum? _selectedBrand;
  Category.Datum? _selectedCategory;

  Category.CategoriesModel? _categoryList;
  Brand.BrandModel? _brandList;
  bool showSearchData = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool? isConnected;
  bool isNetworkCall = false;
  List<SP.Datum> _localList = [];
  ProductModel? _model;
  int currentPage = 1;

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

  Future<bool> getApiData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      isNetworkCall = true;
    } else {
      log("Current Page: $currentPage");
      log("Total Page: $totalPages");
      if (currentPage >= totalPages) {
        _refreshController.loadNoData();
        return false;
      }
    }

    return await getApiCall(isRefresh).then((value) async {
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
        log(_localList.length.toString() + " Local List");
      }

      totalPages = value.data!.meta!.lastPage!;
      setState(() {});
    }).then((value) async {
      return true;
    }).catchError((e) async {
      return false;
    });
  }

  Future<SP.SearchedProductModel> getApiCall(bool isRefresh) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var state = Provider.of<AppState>(context, listen: false);
    if (!isRefresh) {
      currentPage += 1;
      setState(() {});
    } else {
      currentPage = 1;
      setState(() {});
      _refreshController.loadComplete();
    }

    SP.SearchedProductModel searchedProductModel = await ProductServices()
        .getSearchedProducts(
            context,
            state,
            user.getUserDetails()!.data!.token.toString(),
            _searchController.text,
            'null',
            'null',
            'null',
            currentPage,
            priceOrder);
    return searchedProductModel;
  }

  @override
  void initState() {
    var user = Provider.of<UserProvider>(context, listen: false);
    var state = Provider.of<AppState>(context, listen: false);
    CategoriesServices()
        .getAllCategories(
            context, state, user.getUserDetails()!.data!.token.toString())
        .then((value) {
      _categoryList = value;
      setState(() {});
    });
    BrandServices()
        .getAllBrands(
            context, state, user.getUserDetails()!.data!.token.toString())
        .then((value) {
      _brandList = value;
      setState(() {});
    });
    super.initState();
  }

  bool showAdvanceFilter = false;
  ProductModel? model;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context);
    var error = Provider.of<ErrorString>(context, listen: false);
    var cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: cart.cartItems.isEmpty
                ? const Icon(CupertinoIcons.cart, color: Colors.white)
                : Badge(
                    largeSize: 12,
                    smallSize: 12,
                    label: Text(cart.cartItems.length.toString()),
                    child:
                        const Icon(CupertinoIcons.cart, color: Colors.white)),
            onPressed: () {
              if (user.getUserDetails() != null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartView()));
              } else {
                getLoginFlushBar(context);
              }
            },
          ),
        ],
      ),
      body: _categoryList == null || _brandList == null
          ? Center(
              child: ProcessingWidget(),
            )
          : SafeArea(
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
                                showSearchData = true;
                                setState(() {});

                                ProductServices()
                                    .getSearchedProducts(
                                        context,
                                        state,
                                        user
                                            .getUserDetails()!
                                            .data!
                                            .token
                                            .toString(),
                                        _searchController.text,
                                        'null',
                                        'null',
                                        'null',
                                        1,
                                        priceOrder)
                                    .then((value) {
                                  _localList = value.data!.data!;
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
                                  color: FrontEndConfigs.kGreyColor
                                      .withOpacity(0.6),
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffBEBEBE)),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffBEBEBE)),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.black),
                            color: !showAdvanceFilter
                                ? Colors.white
                                : Colors.black,
                          ),
                          child: IconButton(
                              onPressed: () {
                                showAdvanceFilter = !showAdvanceFilter;
                                _localList.clear();
                                setState(() {});
                              },
                              icon: Image.asset(
                                'assets/images/filter.png',
                                height: 25,
                                width: 25,
                                color: showAdvanceFilter
                                    ? Colors.white
                                    : Colors.black,
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!showAdvanceFilter) ...[
                    if (_localList.isNotEmpty)
                      isLoading
                          ? Center(
                              child: ProcessingWidget(),
                            )
                          : _localList.isEmpty
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
                              : Expanded(
                                  child: SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    controller: _refreshController,
                                    onRefresh: () async {},
                                    header: WaterDropHeader(),
                                    onLoading: () async {
                                      log("Loading Called");
                                      isNetworkCall = true;
                                      setState(() {});
                                      final result =
                                          await getApiData(isRefresh: false);
                                      log("Result : $result");
                                      if (result) {
                                        _refreshController.loadComplete();
                                      } else {
                                        log("Current Page: $currentPage");
                                        if (currentPage >= totalPages) {
                                          _refreshController.loadNoData();
                                        } else {
                                          _refreshController.loadFailed();
                                        }
                                      }
                                    },
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _localList.length,
                                        itemBuilder: (BuildContext ctx, i) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: FeaturedProducts(
                                              model: Product(
                                                id: _localList[i].id,
                                                name: _localList[i].name,
                                                price: _localList[i].price,
                                                image: _localList[i].image,
                                                images: _localList[i].images,
                                                description:
                                                    _localList[i].description,
                                                inventory:
                                                    _localList[i].inventory,
                                                status: _localList[i].status,
                                                sku: _localList[i].sku,
                                                type: _localList[i].type,
                                                brand: _localList[i].brand,
                                                crossSellingProducts: [],
                                                categories:
                                                    _localList[i].categories,
                                                offer: _localList[i].offer,
                                                salePrice:
                                                    _localList[i].salePrice,
                                                offer_percentage: _localList[i]
                                                    .offerPercentage,
                                                favorite:
                                                    _localList[i].favorite,
                                                outOfStock:
                                                    _localList[i].outOfStock,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                )
                  ] else
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/filter.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Advance Filters",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _getCustomText('Select Categories'),
                              const SizedBox(height: 10),
                              getCategoryDropDown(),
                              const SizedBox(height: 20),
                              _getCustomText('Select Brands'),
                              const SizedBox(height: 10),
                              getBrandDropDown(),
                              const SizedBox(height: 20),
                              const Divider(),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _getCustomText('Type'),
                                  const SizedBox(width: 10),
                                  SelectTypeContainer(
                                    text: 'For Men',
                                    onTap: () {
                                      productType = 1;
                                      setState(() {});
                                    },
                                    isSelected: productType == 1,
                                  ),
                                  SelectTypeContainer(
                                    text: 'For Women',
                                    onTap: () {
                                      productType = 2;
                                      setState(() {});
                                    },
                                    isSelected: productType == 2,
                                  ),
                                  SelectTypeContainer(
                                    text: 'Both',
                                    onTap: () {
                                      productType = 3;
                                      setState(() {});
                                    },
                                    isSelected: productType == 3,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _getCustomText('Order by'),
                                  const SizedBox(width: 10),
                                  SelectTypeContainer(
                                    text: 'Lowest Price',
                                    onTap: () {
                                      priceOrder = 1;
                                      setState(() {});
                                    },
                                    isSelected: priceOrder == 1,
                                  ),
                                  SelectTypeContainer(
                                    text: 'Highest Price',
                                    onTap: () {
                                      priceOrder = 2;
                                      setState(() {});
                                    },
                                    isSelected: priceOrder == 2,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              const Divider(),
                              const SizedBox(height: 25),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _selectedCategory = null;
                                      _selectedBrand = null;
                                      productType = 0;
                                      priceOrder = 0;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffE8E8E8),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/eraser.png',
                                              height: 25,
                                              width: 25,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              "Clear",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  letterSpacing: 0.7,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AppButtonPrimary(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FilteredProductsView(
                                                        name: _searchController
                                                                .text.isEmpty
                                                            ? 'null'
                                                            : _searchController
                                                                .text,
                                                        brandID:
                                                            _selectedBrand ==
                                                                    null
                                                                ? 'null'
                                                                : _selectedBrand!
                                                                    .id
                                                                    .toString(),
                                                        categoryID:
                                                            _selectedCategory ==
                                                                    null
                                                                ? 'null'
                                                                : _selectedCategory!
                                                                    .id
                                                                    .toString(),
                                                        priceOrder: priceOrder,
                                                        productType:
                                                            productType == 0
                                                                ? 'null'
                                                                : productType
                                                                    .toString(),
                                                      )));
                                        },
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        text: 'Search'),
                                  ),
                                ],
                              ),
                            ]))
                ],
              ),
            ),
    );
  }

  Widget _getCustomText(
    String text,
  ) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }

  Widget getBrandDropDown() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xffBEBEBE)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: DropdownButton(
          value: _selectedBrand,
          hint: Text(
            'Brands',
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _brandList!.data!.map((Brand.Datum? items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items!.title.toString()),
            );
          }).toList(),
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (Brand.Datum? newValue) {
            setState(() {
              _selectedBrand = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget getCategoryDropDown() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xffBEBEBE)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: DropdownButton(
          value: _selectedCategory,
          hint: Text(
            'Categories',
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _categoryList!.data!.map((Category.Datum? items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items!.name.toString()),
            );
          }).toList(),
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (Category.Datum? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
        ),
      ),
    );
  }
}
