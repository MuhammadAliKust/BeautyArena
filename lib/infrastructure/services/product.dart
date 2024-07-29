import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beauty_arena_app/infrastructure/models/related_products.dart';
import 'package:beauty_arena_app/infrastructure/models/searched_product.dart';
import 'package:beauty_arena_app/infrastructure/models/single_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../application/app_state.dart';
import '../../application/errorStrings.dart';
import '../../configurations/back_end_configs.dart';
import '../../configurations/end_points.dart';
import '../../configurations/enums.dart';
import '../models/categories.dart';
import '../models/dashboard.dart';
import '../models/error.dart';
import '../models/offers.dart';
import '../models/product.dart';

class ProductServices {
  ///Get All Products
  Future<ProductModel> getAllProducts(
    BuildContext context,
    AppState state,
    String token,
    num page,
    String categoryID,
  ) async {
    log(token);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      state.stateStatus(AppCurrentState.IsBusy, false);
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kGetProducts +
              '?categoryid=$categoryID' +
              '&page=$page'));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(request.url.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
        state.stateStatus(AppCurrentState.IsFree);
      } else {
        state.stateStatus(AppCurrentState.IsError);
      }
      return ProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  ///Get Products By Brand ID
  Future<ProductModel> getProductsByBrandID(
    BuildContext context,
    AppState state,
    String token,
    String brandID,
    num page,
  ) async {
    log("Brand ID : $brandID");
    try {
      var headers = {'Authorization': 'Bearer $token'};
      state.stateStatus(AppCurrentState.IsBusy, false);
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kGetProducts +
              '?brandid=$brandID' +
              '&page=$page'));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
        state.stateStatus(AppCurrentState.IsFree);
      } else {
        state.stateStatus(AppCurrentState.IsError);
      }
      return ProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  ///Get Products By Brand ID
  Future<SingleProductModel> getProductByID(
    BuildContext context,
    AppState state,
    String token,
    String productID,
  ) async {
    log(token);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      state.stateStatus(AppCurrentState.IsBusy, false);
      var request = http.Request('GET',
          Uri.parse(BackendConfigs.apiUrl(context) + 'product/$productID'));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(response.statusCode.toString());
      log(request.url.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
        state.stateStatus(AppCurrentState.IsFree);
      } else {
        state.stateStatus(AppCurrentState.IsError);
      }
      log(model.toString());
      return SingleProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  ///Get Featured Products
  Future<ProductModel> getFavProducts(
      BuildContext context, String token, int page) async {
    log(token);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kFavProducts +
              '?page=$page&paginator=10'));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
      } else {}
      return ProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  ///Get Featured Products
  Future<ProductModel> getFeaturedProducts(
      BuildContext context, String token, int page) async {
    log(token);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kGetProducts +
              '?filter=3&page=$page&paginator=10'));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
      } else {}
      return ProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  ///Get Related Products
  Future<RelatedProductsModel> getRelatedProducts(
    BuildContext context,
    AppState state,
    String token,
    String categoryID,
  ) async {
    log(token);
    state.stateStatus(AppCurrentState.IsBusy, false);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kRelatedProducts +
              "/$categoryID"));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        state.stateStatus(AppCurrentState.IsFree);
        model = await response.stream.bytesToString();
        log(model.toString());
      } else {
        state.stateStatus(AppCurrentState.IsError);
      }
      return RelatedProductsModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      state.stateStatus(AppCurrentState.IsError);
      debugPrint(e.message.toString());
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      state.stateStatus(AppCurrentState.IsError);
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  ///Get Recent Products
  Future<ProductModel> getRecentProducts(
    BuildContext context,
    String token,
    int page,
  ) async {
    log(token);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kGetProducts +
              '?filter=1&page=$page&paginator=10'));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(request.url.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
      } else {}
      return ProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  ///Get Top Selling Products
  Future<ProductModel> getTopSellingProducts(
    BuildContext context,
    String token,
    int page,
  ) async {
    log(token);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kGetProducts +
              '?filter=2&page=$page&paginator=10'));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(request.url.toString());
      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
      } else {}
      return ProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  ///Get Products By Brand ID
  Future<SearchedProductModel> getSearchedProducts(
      BuildContext context,
      AppState state,
      String token,
      String? name,
      String? brandID,
      String? categoryID,
      String? productType,
      int page,
      int? priceOrder) async {
    log(token);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      state.stateStatus(AppCurrentState.IsBusy, false);
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              'search-products' +
              '?searchvalue=$name&brandid=$brandID&categoryid=$categoryID&producttype=$productType&priceOrder=$priceOrder&version=2&page=$page&paginator=10'));

      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(request.url.toString());
      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("20 Callled");
        state.stateStatus(AppCurrentState.IsFree);
        model = await response.stream.bytesToString();
      } else {
        state.stateStatus(AppCurrentState.IsError);
      }
      return SearchedProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  ///Get Products By Brand ID
  Future<SearchedProductModel> getSearchProductsByCategoryID(
      BuildContext context,
      AppState state,
      String token,
      String? name,
      String? categoryID) async {
    log(token);
    try {
      var headers = {'Authorization': 'Bearer $token'};
      state.stateStatus(AppCurrentState.IsBusy, false);
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              'search-products?category_id=$categoryID&searchvalue=$name'));

      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(request.url.toString());
      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("20 Callled");
        state.stateStatus(AppCurrentState.IsFree);
        model = await response.stream.bytesToString();
      } else {
        state.stateStatus(AppCurrentState.IsError);
      }
      return SearchedProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }

  String getSearchValue(String? name) {
    if (name == null) {
      return '';
    } else {
      return 'searchvalue=$name';
    }
  }

  String getBrandID(String? brandID) {
    if (brandID == null) {
      return '';
    } else {
      return 'brandid=$brandID';
    }
  }

  String getCategoryID(String? categoryID) {
    if (categoryID == null) {
      return '';
    } else {
      return 'categoryid=$categoryID';
    }
  }

  /// Add Product to Favorite
  Future<ProductModel> addProductToFavorite(BuildContext context,
      {required String productID, required String token}) async {
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      var request = http.Request(
          'POST',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kFavProducts +
              "/$productID"));

      request.headers.addAll(headers);
      var response = await request.send();
      log(request.url.toString() + " Body");
      debugPrint(response.statusCode.toString());
      var model;

      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
        log(model.toString());
      } else {
        model = await response.stream.bytesToString();

        var _model = ErrorModel.fromJson(json.decode(model));
        Provider.of<ErrorString>(context, listen: false)
            .saveErrorString(_model.message.toString());
      }
      return ProductModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }
}
