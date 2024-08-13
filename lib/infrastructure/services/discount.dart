import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beauty_arena_app/infrastructure/models/discount.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../application/app_state.dart';
import '../../application/errorStrings.dart';
import '../../configurations/back_end_configs.dart';
import '../../configurations/end_points.dart';
import '../../configurations/enums.dart';
import '../models/coupon_body.dart';
import '../models/offers.dart';

class DiscountServices {
  ///Get All Offers
  Future<DiscountModel> getDiscount(BuildContext context,
      {required AppState state,
      required String token,
      required String couponCode,
      required List<CouponBodyModel> list}) async {
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      state.stateStatus(AppCurrentState.IsBusy);
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kCheckCoupon +
              couponCode));
      log(request.url.toString());
      request.headers.addAll(headers);
      request.body = json.encode({
        "product_ids":
            list.map((e) => {"id": e.productID, "qty": e.quantity}).toList()
      });

      var response = await request.send();

      debugPrint(response.statusCode.toString());
      debugPrint(request.body.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
        state.stateStatus(AppCurrentState.IsFree);
      } else if (response.statusCode == 410) {
        model = await response.stream.bytesToString();
        log(json.decode(model)['errors'][0].toString());
        Provider.of<ErrorString>(context, listen: false)
            .saveErrorString(json.decode(model)['errors'][0].toString());
        state.stateStatus(AppCurrentState.IsFree);
      }else if (response.statusCode == 404) {
        model = await response.stream.bytesToString();
        log(json.decode(model)['errors'][0].toString());
        Provider.of<ErrorString>(context, listen: false)
            .saveErrorString(json.decode(model)['errors'][0].toString());
        state.stateStatus(AppCurrentState.IsFree);
      } else {
        log(response.reasonPhrase.toString());
        state.stateStatus(AppCurrentState.IsError);
      }
      log(json.decode(model).toString());
      return DiscountModel.fromJson(json.decode(model));
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
}
