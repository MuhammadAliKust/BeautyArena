import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../application/app_state.dart';
import '../../application/errorStrings.dart';
import '../../configurations/back_end_configs.dart';
import '../../configurations/end_points.dart';
import '../../configurations/enums.dart';
import '../models/page.dart';

import 'package:http/http.dart' as http;

class PageServices {
  ///Get All Pages
  Future<PageModel> fetchPages(
    BuildContext context,

    String token,
  ) async {
    try {
      var headers = {'Authorization': 'Bearer $token'};
      // state.stateStatus(AppCurrentState.IsBusy, false);
      var request = http.Request('GET',
          Uri.parse(BackendConfigs.apiUrl(context) + ApiEndPoints.kGetPages));
      request.headers.addAll(headers);
      var response = await request.send();

      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
        // state.stateStatus(AppCurrentState.IsFree);
      } else {
        // state.stateStatus(AppCurrentState.IsError);
      }
      return PageModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      // state.stateStatus(AppCurrentState.IsError);
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Socket Called');
      debugPrint(e.message.toString());
      // state.stateStatus(AppCurrentState.IsError);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString('Kindly check your internet connection.');
      rethrow;
    }
  }
}
