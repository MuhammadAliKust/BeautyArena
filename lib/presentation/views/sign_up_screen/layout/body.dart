import 'dart:developer';
import 'dart:io';

import 'package:beauty_arena_app/presentation/views/otp_screen/otp_view.dart';
import 'package:country_picker/country_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../../../../application/app_state.dart';
import '../../../../application/errorStrings.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../configurations/front_end_configs.dart';
import '../../../../infrastructure/models/city.dart';
import '../../../../infrastructure/services/auth.dart';
import '../../../../infrastructure/services/city.dart';
import '../../../../infrastructure/services/local.dart';
import '../../../elements/app_button_primary.dart';
import '../../../elements/auth_text_field.dart';
import '../../../elements/country_code_container.dart';
import '../../../elements/flush_bar.dart';
import '../../../elements/processing_widget.dart';
import '../../../elements/selection_container.dart';
import '../../login_screen/login_view.dart';
import 'widgets/vip_card_container.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({Key? key}) : super(key: key);

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _vipCardController = TextEditingController();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? selectedGender;
  String selectedNumber = "+970";
  List<CityModel>? _citiesList;
  Datum? _selectedCity;
  DateTime? dateTime;
  List<String> genderList = ['Male', 'Female'];
  List<String> countryCodeList = ['+970', '+972'];
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

  @override
  void initState() {
    CacheServices.instance.readCities().then((value) {
      _citiesList = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    var user = Provider.of<UserProvider>(context);
    var error = Provider.of<ErrorString>(context);
    return _citiesList == null
        ? const Center(
            child: ProcessingWidget(),
          )
        : LoadingOverlay(
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
                                'Sign Up!',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Your account details',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 20),
                              AuthTextField(
                                hint: 'First Name',
                                validator: (val) {},
                                controller: _nameController,
                                onPwdTap: () {},
                              ),
                              const SizedBox(height: 15),
                              getGenderDropDown(),
                              const SizedBox(height: 15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: const Color(0xffBEBEBE)),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateTime == null
                                            ? "Your Birth Date" + " (Optional)"
                                            : DateFormat.yMMMEd()
                                                .format(dateTime!),
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                          color: FrontEndConfigs.kGreyColor
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _selectDate(context);
                                          },
                                          icon: Icon(
                                            Icons.calendar_month,
                                            color: FrontEndConfigs.kGreyColor,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              getCityDropDown(),
                              const SizedBox(height: 15),
                              AuthTextField(
                                controller: _addressController,
                                hint: 'Your Address' + " (Optional)",
                                onPwdTap: () {},
                                validator: (val) {},
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2, child: getCountryCodeDropDown()),
                                  // CountryCodeContainer(
                                  //     onTap: () {
                                  //       showCountryPicker(
                                  //         context: context,
                                  //         showPhoneCode: true,
                                  //         // optional. Shows phone code before the country name.
                                  //         onSelect: (Country country) {
                                  //           _country = country;
                                  //           setState(() {});
                                  //         },
                                  //       );
                                  //     },
                                  //     countrycode:
                                  //         '+' + _country.phoneCode.toString()),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    flex: 4,
                                    child: AuthTextField(
                                      controller: _numberController,
                                      keyBoardType: TextInputType.number,
                                      isNumberField: true,
                                      hint: 'Ex. 598114577',
                                      onPwdTap: () {},
                                      validator: (val) {},
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              getVIPTextField(),
                              const SizedBox(height: 20),
                              AppButtonPrimary(
                                  onTap: () async {
                                    if (_nameController.text.isEmpty) {
                                      getFlushBar(context,
                                          title: 'Name cannot be empty.');
                                      return;
                                    }
                                    // if (selectedGender == null) {
                                    //   getFlushBar(context,
                                    //       title: 'Kindly select gender.');
                                    //   return;
                                    // }
                                    // if (dateTime == null) {
                                    //   getFlushBar(context,
                                    //       title:
                                    //           'Kindly select date of birth.');
                                    //   return;
                                    // }
                                    if (_selectedCity == null) {
                                      getFlushBar(context,
                                          title: 'Kindly select governorate.');
                                      return;
                                    }
                                    // if (_addressController.text.isEmpty) {
                                    //   getFlushBar(context,
                                    //       title: 'Address cannot be empty.');
                                    //   return;
                                    // }
                                    if (_numberController.text.isEmpty) {
                                      getFlushBar(context,
                                          title:
                                              'Phone number cannot be empty.');
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
                                      await FirebaseMessaging.instance
                                          .getToken()
                                          .then((token) async {
                                        await getDeviceInfo()
                                            .then((value) async {
                                          log(value);
                                          await AuthServices().registerUser(
                                              context,
                                              number: selectedNumber +
                                                  _numberController.text,
                                              firebaseToken: token.toString(),
                                              fullName: _nameController.text,
                                              city: "N/A",
                                              governorate:
                                                  _selectedCity!.id.toString(),
                                              birthDay:
                                                  '${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}',
                                              gender: selectedGender == "Male"
                                                  ? "0"
                                                  : "1",
                                              password:
                                                  _passwordController.text,
                                              vipCard: result,
                                              deviceID: value,
                                              state: state);
                                        });
                                      });

                                      if (state.getStateStatus() ==
                                          AppCurrentState.IsFree) {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginView()));
                                      } else {
                                        getFlushBar(context,
                                            title: error.getErrorString());
                                      }
                                    } catch (e) {
                                      state
                                          .stateStatus(AppCurrentState.IsError);
                                      getFlushBar(context, title: e.toString());
                                    }
                                  },
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  text: 'SIGN UP'),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already have an account?',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black)),
                                  const SizedBox(width: 3),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginView()));
                                    },
                                    child: const Text('Sign in',
                                        style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 30),
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1960, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateTime) {
      setState(() {
        dateTime = picked;
      });
    }
  }

  Widget getCountryCodeDropDown() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xffBEBEBE)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
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

  Widget getGenderDropDown() {
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
          value: selectedGender,
          hint: Text(
            'Your Gender' + " (Optional)",
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: genderList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue!;
            });
          },
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

  Widget getCityDropDown() {
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
          value: _selectedCity,
          hint: Text(
            'Your Governorate',
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _citiesList![0].data!.map((Datum items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items.governorateName.toString()),
            );
          }).toList(),
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (Datum? newValue) {
            setState(() {
              _selectedCity = newValue!;
            });
          },
        ),
      ),
    );
  }

  String result = "";

  Widget getVIPTextField() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffC29927)),
          color: Color(0xffFFFAE5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              result == "" || result == "null" || result == "-1"   ? "Do you have VIP card? Scan It." : result,
              style: TextStyle(
                  color: Color(0xffBB9D83),
                  fontSize: 15,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  if (res is String) {
                    result = res;
                  }
                });
              },
              icon: Icon(
                CupertinoIcons.barcode,
                color: Colors.grey,
              ))
        ],
      ),
    );
    return TextFormField(
        controller: _vipCardController,
        style: const TextStyle(
            color: Color(0xffBB9D83),
            fontSize: 15,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500),
        cursorColor: FrontEndConfigs.kGreyColor.withOpacity(0.2),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffFFFAE5),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          hintText: 'Do you have VIP card? Type it here.',
          hintStyle: TextStyle(
            color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
            fontSize: 15,
            letterSpacing: 0.5,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC29927)),
            borderRadius: BorderRadius.circular(7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC29927)),
            borderRadius: BorderRadius.circular(7),
          ),
        ));
  }
}
