import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
import '../models/offers.dart';

class DashboardServices {
  ///Get Dashboard Data
  Future<DashboardModel> getDashboardData(
    BuildContext context,
    AppState state,
    String token,
  ) async {
    try {
      var headers = {'Authorization': 'Bearer $token'};
      state.stateStatus(AppCurrentState.IsBusy, false);
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kGetDashboardData +
              "?lastest_product_counter=10&most_selling_product_counter=10&category_counter=10&featured_product_counter=10"));
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
      return DashboardModel.fromJson(json.decode(model));
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

  ///Get Local Dashboard Data
  Future<DashboardModel> getLocalDashboardData(
    BuildContext context,
    String token,
  ) async {
    try {
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request(
          'GET',
          Uri.parse(BackendConfigs.apiUrl(context) +
              ApiEndPoints.kGetDashboardData +
              "?lastest_product_counter=10&most_selling_product_counter=10&category_counter=10&featured_product_counter=10"));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
      } else {}
      return DashboardModel.fromJson(json.decode(model));
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
