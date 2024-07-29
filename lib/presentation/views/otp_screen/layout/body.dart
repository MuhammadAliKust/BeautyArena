import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../application/app_state.dart';
import '../../../../application/errorStrings.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/user.dart';
import '../../../../infrastructure/services/auth.dart';
import '../../../../infrastructure/services/dashboard.dart';
import '../../../../infrastructure/services/local.dart';
import '../../../elements/app_button_primary.dart';
import '../../../elements/flush_bar.dart';
import '../../../elements/processing_widget.dart';
import '../../bottom_bar.dart';

class OtpViewBody extends StatefulWidget {
  final String number;

  const OtpViewBody({Key? key, required this.number}) : super(key: key);

  @override
  State<OtpViewBody> createState() => _OtpViewBodyState();
}

class _OtpViewBodyState extends State<OtpViewBody> {
  String? code;
  String token = "";

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) {
      token = value.toString();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var error = Provider.of<ErrorString>(context);
    var state = Provider.of<AppState>(context);

    var user = Provider.of<UserProvider>(context);
    return LoadingOverlay(
      isLoading: state.getStateStatus() == AppCurrentState.IsBusy,
      progressIndicator: const ProcessingWidget(),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _getCustomText(
                  'A verification code has been sent to your phone number, please enter it here.'),
              const SizedBox(height: 20),
              FittedBox(
                child: Container(
                  height: 44,
                  child: OtpTextField(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    fieldWidth: 44,
                    borderRadius: BorderRadius.circular(7),
                    numberOfFields: 6,
                    borderColor: const Color(0xffBEBEBE),
                    focusedBorderColor: const Color(0xffBEBEBE),
                    enabledBorderColor: const Color(0xffBEBEBE),
                    fillColor: Colors.white,
                    showFieldAsBox: true,
                    filled: true,
                    textStyle: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    borderWidth: 1,
                    onCodeChanged: (String otpCode) {},
                    onSubmit: (String verificationCode) {
                      code = verificationCode;
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AppButtonPrimary(
                    onTap: () async {
                      var prefs = await SharedPreferences.getInstance();
                      if (code == null) {
                        getFlushBar(context, title: 'Kindly enter otp.');
                        return;
                      }

                      try {
                        var model = await AuthServices().verifyOTP(context,
                            number: widget.number,
                            otp: code!,
                            token: token,
                            state: state);

                        if (state.getStateStatus() == AppCurrentState.IsFree) {
                          state.stateStatus(AppCurrentState.IsBusy);
                          if (model.data != null) {
                            await DashboardServices()
                                .getLocalDashboardData(
                                    context, model.data!.token.toString())
                                .then(
                                    CacheServices.instance.writeDashboardData);
                            state.stateStatus(AppCurrentState.IsFree);
                            user.saveUserDetails(model);
                            await prefs.setString(
                                'USER_DATA', userModelToJson(model));
                            await prefs.setString('LOGIN_STATUS', 'exist');
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNavBar()));
                          }
                        } else {
                          getFlushBar(context, title: error.getErrorString());
                        }
                      } catch (e) {
                        state.stateStatus(AppCurrentState.IsError);
                        getFlushBar(context, title: e.toString());
                        rethrow;
                      }
                    },
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    text: 'VERIFY'),
              ),
              const SizedBox(height: 20),
              // _getCustomText(
              //     'You can resend the verification code one more time after 23 seconds.'),
              // const SizedBox(height: 30),
              Image.asset('assets/images/otp_img.png', height: 326, width: 326),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCustomText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
    );
  }
}
