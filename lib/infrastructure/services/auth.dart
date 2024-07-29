import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beauty_arena_app/infrastructure/models/login.dart';
import 'package:beauty_arena_app/infrastructure/models/order_error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../application/app_state.dart';
import '../../application/errorStrings.dart';
import '../../configurations/back_end_configs.dart';
import '../../configurations/end_points.dart';
import '../../configurations/enums.dart';
import '../models/brand.dart';
import '../models/delete.dart';
import '../models/error.dart';
import '../models/updated_user.dart';
import '../models/user.dart';

class AuthServices {
  /// Register User
  Future registerUser(BuildContext context,
      {required String number,
      required String password,
      required String fullName,
      required String governorate,
      required String city,
      required String? birthDay,
      required String? gender,
      required String deviceID,
      required String vipCard,
      required String firebaseToken,
      required AppState state}) async {
    try {
      state.stateStatus(AppCurrentState.IsBusy);
      var headers = {'Content-Type': 'application/json'};

      var request = http.Request(
          'POST',
          Uri.parse(
              BackendConfigs.apiUrl(context) + ApiEndPoints.kRegisterUser));
      request.body = json.encode({
        'full_name': fullName,
        'governorate': governorate,
        'city': city,
        'birthday': birthDay,
        'gender': gender,
        'mobile': number,
        'vip_card_number': vipCard,
        'password': password,
        'firebase_token': firebaseToken,
        'device_id': deviceID
      });
      request.headers.addAll(headers);
      var response = await request.send();
      print(request.body);
      debugPrint(request.url.toString());
      debugPrint(response.reasonPhrase.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
        state.stateStatus(AppCurrentState.IsFree);
      } else {
        model = await response.stream.bytesToString();
        var _model = ErrorModel.fromJson(json.decode(model));
        print(model);
        Provider.of<ErrorString>(context, listen: false)
            .saveErrorString(_model.message.toString());
        state.stateStatus(AppCurrentState.IsError);
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

  /// Login User
  Future<LoginModel> loginUser(BuildContext context,
      {required String number,
      required String password,
      required String deviceID,
      required String token,
      required AppState state}) async {
    try {
      state.stateStatus(AppCurrentState.IsBusy);
      var headers = {'Content-Type': 'application/json'};

      var request = http.Request('POST',
          Uri.parse(BackendConfigs.apiUrl(context) + ApiEndPoints.kLoginUser));
      request.body = json.encode({
        'mobile': number,
        'device': deviceID,
        'firebase_token': token,
      });
      request.headers.addAll(headers);
      var response = await request.send();
      print(number);
      debugPrint(request.body.toString());
      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
        state.stateStatus(AppCurrentState.IsFree);
      } else {
        var errorModel = await response.stream.bytesToString();
        log(json.decode(errorModel).toString());
        var _model = ErrorModel.fromJson(json.decode(errorModel));
        Provider.of<ErrorString>(context, listen: false)
            .saveErrorString(_model.message.toString());
        state.stateStatus(AppCurrentState.IsError);
      }
      if (model == null) {
        return LoginModel();
      } else {
        return LoginModel.fromJson(json.decode(model));
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

  /// Verify OTP
  Future<UserModel> verifyOTP(BuildContext context,
      {required String number,
      required String otp,
      required String token,
      required AppState state}) async {
    try {
      state.stateStatus(AppCurrentState.IsBusy);
      var headers = {'Content-Type': 'application/json'};

      var request = http.Request('POST',
          Uri.parse(BackendConfigs.apiUrl(context) + ApiEndPoints.kCheckOtp));
      request.body = json.encode({
        'mobile': number,
        'device_id': token,
        'otp': otp,
      });
      log({
        'mobile': number,
        'device_id': token,
        'otp': otp,
      }.toString());
      request.headers.addAll(headers);
      var response = await request.send();
      print(number);
      debugPrint(request.body.toString());
      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
      } else {
        var errorModel = await response.stream.bytesToString();
        log(json.decode(errorModel).toString());
        var _model = ErrorModel.fromJson(json.decode(errorModel));
        Provider.of<ErrorString>(context, listen: false)
            .saveErrorString(_model.message.toString());
        state.stateStatus(AppCurrentState.IsError);
      }
      log("Response Model: " + model.toString());
      if (model == null) {
        return UserModel();
      } else {  state.stateStatus(AppCurrentState.IsFree);
        return UserModel.fromJson(json.decode(model));
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

  /// Delete User
  Future deleteUser(BuildContext context,
      {required String token, required AppState state}) async {
    try {
      state.stateStatus(AppCurrentState.IsBusy);
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var request = http.Request(
          'DELETE',
          Uri.parse(
              BackendConfigs.apiUrl(context) + ApiEndPoints.kDeleteProfile));

      request.headers.addAll(headers);
      var response = await request.send();
      debugPrint(response.statusCode.toString());
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();

        state.stateStatus(AppCurrentState.IsFree);
      } else {
        model = await response.stream.bytesToString();
        var _model = ErrorModel.fromJson(json.decode(model));
        Provider.of<ErrorString>(context, listen: false)
            .saveErrorString(_model.message.toString());
        state.stateStatus(AppCurrentState.IsError);
      }

      return DeleteModel.fromJson(json.decode(model));
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

  /// Update Profile
  Future<Customer> updateProfile(BuildContext context,
      {required String userID,
      required String name,
      required String customerGender,
      required String customerCity,
      required String customerGovernorate,
      required String customerMobile,
      required String customerBirthday,
      required String vipCard,
      File? file,
      required String token,
      required String firebaseToken,
      required AppState state}) async {
    print(token);
    try {
      state.stateStatus(AppCurrentState.IsBusy);
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              BackendConfigs.apiUrl(context) + ApiEndPoints.kUpdateProfile));

      request.fields.addAll({
        'name': name,
        'customer_gender': customerGender,
        'customer_city': customerCity,
        'customer_governorate': customerGovernorate,
        'customer_mobile': customerMobile,
        'customer_birthday': customerBirthday,
        'vip_card_number': vipCard,

        '_method': 'PUT'
        // 'password': '12345678',
      });
      if (file != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', file.path));
      }

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      debugPrint(response.statusCode.toString());
      debugPrint(response.reasonPhrase.toString());
      var model;
      var decodedData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();

        decodedData = jsonDecode(model);
        log(jsonEncode(decodedData['message']));

        state.stateStatus(AppCurrentState.IsFree);
      } else {
        model = await response.stream.bytesToString();
log(model.toString());
        var _model = OrderErrorModel.fromJson(json.decode(model));
        log(_model.message.toString());
        Provider.of<ErrorString>(context, listen: false)
            .saveErrorString(_model.message.toString());
        state.stateStatus(AppCurrentState.IsError);


      }
      return Customer.fromJson(json.decode(jsonEncode(decodedData['message'])));
    } on HttpException catch (e) {
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    } on SocketException catch (e) {
      debugPrint("Socket Called");
      debugPrint(e.message.toString());
      state.stateStatus(AppCurrentState.IsError);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString("Kindly check your internet connection.");
      rethrow;
    }
  }
}
