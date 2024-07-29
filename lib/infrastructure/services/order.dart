import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beauty_arena_app/infrastructure/models/order_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../application/app_state.dart';
import '../../application/errorStrings.dart';
import '../../configurations/back_end_configs.dart';
import '../../configurations/end_points.dart';
import '../../configurations/enums.dart';
import '../models/cart.dart';
import '../models/error.dart';
import '../models/offers.dart';
import '../models/order.dart';
import '../models/order_details.dart';
import '../models/order_error.dart';

class OrdersServices {
  /// Create New Order
  Future<OrderResponseModel> createNewOrder(BuildContext context,
      {required String number,
      required List<CartModel> list,
      required String fullName,
      required String governorate,
      required String token,
      required String address,
      required String shipping,
      required String paidBy,
      required String note,
      required String total,
      required String deviceID,
      required AppState state}) async {
    try {
      log(token);
      state.stateStatus(AppCurrentState.IsBusy);
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      var request = http.Request(
          'POST',
          Uri.parse(
              BackendConfigs.apiUrl(context) + ApiEndPoints.kCreateOrder));
      request.body = json.encode({
        'array': list
            .map((e) => {
                  'id': e.id,
                  'qty': e.quantity,
                  'price': e.price,
                  'offer_id': e.offer
                })
            .toList(),
        'customer_full_name': fullName,
        'governorate': governorate,
        'address': address,
        'notes': note,
        'mobile': number,
        'shipping': shipping,
        'paid_by': paidBy,
        'total': total,
        'device_id': deviceID
      });
      request.headers.addAll(headers);
      var response = await request.send();
      log(request.body.toString() + " Body");
      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var model;
        if (response.statusCode == 200 || response.statusCode == 201) {
          model = await response.stream.bytesToString();
          state.stateStatus(AppCurrentState.IsFree);
        } else {
          state.stateStatus(AppCurrentState.IsError);
        }
        log(model.toString());
        return OrderResponseModel.fromJson(json.decode(model));
      } else {
        model = await response.stream.bytesToString();
        log(model.toString());
        var _model = OrderErrorModel.fromJson(json.decode(model));
        Provider.of<ErrorString>(context, listen: false)
            .saveErrorString(_model.errors![0].toString());
        state.stateStatus(AppCurrentState.IsError);
        return OrderResponseModel();
      }
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

  ///Get All Orders
  Future<OrdersModel> getAllOrders(
    BuildContext context,
    AppState state,
    String token,
  ) async {
    try {
      var headers = {'Authorization': 'Bearer $token'};
      state.stateStatus(AppCurrentState.IsBusy, false);
      var request = http.Request('GET',
          Uri.parse(BackendConfigs.apiUrl(context) + ApiEndPoints.kGetOrders));
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
      return OrdersModel.fromJson(json.decode(model));
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

  ///Get Order Details
  Future<OrderDetailsModel> getOrderDetails(
    BuildContext context,
    AppState state,
    String token,
    String orderID,
  ) async {
    try {
      var headers = {'Authorization': 'Bearer $token'};
      state.stateStatus(AppCurrentState.IsBusy, false);
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kSingleOrder +
              orderID));
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
      return OrderDetailsModel.fromJson(json.decode(model));
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
