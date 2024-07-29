import 'dart:io';

import 'package:beauty_arena_app/presentation/views/otp_screen/otp_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../application/app_state.dart';
import '../../../../application/errorStrings.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../configurations/front_end_configs.dart';
import '../../../../infrastructure/models/user.dart';
import '../../../../infrastructure/services/auth.dart';
import '../../../../infrastructure/services/dashboard.dart';
import '../../../../infrastructure/services/local.dart';
import '../../../elements/app_button_primary.dart';
import '../../../elements/auth_text_field.dart';
import '../../../elements/country_code_container.dart';
import 'package:country_picker/country_picker.dart';

import '../../../elements/flush_bar.dart';
import '../../../elements/processing_widget.dart';
import '../../bottom_bar.dart';
import '../../home_view.dart';
import '../../sign_up_screen/sign_up_view.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({Key? key}) : super(key: key);

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Country _country = Country(
      phoneCode: '970',
      countryCode: 'countryCode',
      e164Sc: 234,
      geographic: true,
      level: 234,
      name: 'name',
      example: 'example',
      displayName: 'displayName',
      displayNameNoCountryCode: 'displayNameNoCountryCode',
      e164Key: '23423');
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<void> _initFcm(String userID) async {
    await FirebaseMessaging.instance.subscribeToTopic('BEAUTY_ARENA');
    await FirebaseMessaging.instance.getToken().then((token) {
      if (kDebugMode) {
        print(token);
      }
      FirebaseFirestore.instance.collection('deviceTokens').doc(userID).set(
        {
          'deviceTokens': token,
        },
      );
    });
  }

  String selectedNumber = "+970";
  List<String> countryCodeList = ['+970', '+972'];

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    var user = Provider.of<UserProvider>(context);
    var error = Provider.of<ErrorString>(context);
    return LoadingOverlay(
      isLoading: state.getStateStatus() == AppCurrentState.IsBusy,
      progressIndicator: const ProcessingWidget(),
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/login_bg.png'))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.black),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'LOGIN',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        _getCustomText(
                            'You need to have an account to be able to browse and use our app. For better customization and product personalization.'),
                        const SizedBox(height: 40),
                        _getCustomText('Your number & Password'),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(flex: 2, child: getCountryCodeDropDown()),
                            const SizedBox(width: 3),
                            Expanded(
                              flex: 4,
                              child: AuthTextField(
                                controller: _numberController,
                                keyBoardType: TextInputType.number,
                                hint: 'Ex. 598114577',
                                isNumberField: true,
                                onPwdTap: () {},
                                validator: (val) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AppButtonPrimary(
                            onTap: () async {
                              var prefs = await SharedPreferences.getInstance();
                              if (_numberController.text.isEmpty) {
                                getFlushBar(context,
                                    title: 'Phone number cannot be empty.');
                                return;
                              }
                              if (_numberController.text
                                  .substring(0, 1) ==
                                  '0') {
                                getFlushBar(context,
                                    title:
                                    'Kindly enter valid phone number.');
                                return;
                              }

                              try {
                                var model;
                                await FirebaseMessaging.instance
                                    .getToken()
                                    .then((token) async {
                                  await getDeviceInfo().then((value) async {
                                    model = await AuthServices().loginUser(
                                        context,
                                        number: selectedNumber +
                                            _numberController.text,
                                        password: _passwordController.text,
                                        token: token.toString(),
                                        deviceID: value,
                                        state: state);
                                  });
                                });

                                // if (model.data != null) {
                                //
                                // }
                                // if (model.data != null) {
                                //   await _initFcm(
                                //       model.data!.customer!.id.toString());
                                //   await DashboardServices()
                                //       .getLocalDashboardData(
                                //           context, model.data!.token.toString())
                                //       .then(CacheServices
                                //           .instance.writeDashboardData);
                                //   state.stateStatus(AppCurrentState.IsFree);
                                // }

                                if (state.getStateStatus() ==
                                    AppCurrentState.IsFree) {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtpView(
                                              selectedNumber +
                                                  _numberController.text)));
                                  // user.saveUserDetails(model);
                                  // await prefs.setString(
                                  //     'USER_DATA', userModelToJson(model));
                                  // await prefs.setString(
                                  //     'LOGIN_STATUS', 'exist');
                                  // await Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             BottomNavBar()));
                                } else {
                                  getFlushBar(context,
                                      title: error.getErrorString());
                                }
                              } catch (e) {
                                state.stateStatus(AppCurrentState.IsError);
                                getFlushBar(context, title: e.toString());
                                rethrow;
                              }
                            },
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            text: 'LOGIN'),
                        const SizedBox(height: 90),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black)),
                            SizedBox(width: 3),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpView()));
                              },
                              child: Text('Sign Up',
                                  style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getDeviceInfo() async {
    if (Platform.isAndroid) {
      var deviceID = await deviceInfo.androidInfo;
      return deviceID.id;
    } else {
      var deviceID = await deviceInfo.iosInfo;
      return deviceID.identifierForVendor.toString();
    }
  }

  Widget getCountryCodeDropDown() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xffBEBEBE)),
          color: Colors.white),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: DropdownButton(
          value: selectedNumber,
          hint: Text(
            'Code',
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: countryCodeList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (String? newValue) {
            setState(() {
              selectedNumber = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _getCustomText(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}
