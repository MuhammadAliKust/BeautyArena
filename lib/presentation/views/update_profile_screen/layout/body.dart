import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
import '../../../../infrastructure/models/user.dart';
import '../../../../infrastructure/services/auth.dart';
import '../../../../infrastructure/services/city.dart';
import '../../../../infrastructure/services/local.dart';
import '../../../elements/app_button_primary.dart';
import '../../../elements/auth_text_field.dart';
import '../../../elements/flush_bar.dart';
import '../../../elements/processing_widget.dart';

class UpdateProfileViewBody extends StatefulWidget {
  const UpdateProfileViewBody({Key? key}) : super(key: key);

  @override
  State<UpdateProfileViewBody> createState() => _UpdateProfileViewBodyState();
}

class _UpdateProfileViewBodyState extends State<UpdateProfileViewBody> {
  final TextEditingController _addressController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  String? selectedGender;
  List<String> genderList = ['Male', 'Female'];
  File? _image;
  List<CityModel>? _citiesList;
  Datum? _selectedCity;
String result = "";
  DateTime? dateTime;

  List<String> countryCodeList = ['+970', '+972'];

  String selectedNumber = "+970";

  TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    var user = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(
        text: user.getUserDetails()!.data!.customer!.name);
    _cityController = TextEditingController(
        text: user.getUserDetails()!.data!.customer!.customerCity);
    result = user.getUserDetails()!.data!.customer!.vip_card_number.toString();
    _numberController = TextEditingController(
        text: user
            .getUserDetails()!
            .data!
            .customer!
            .customerMobile!
            .replaceAll('+970', '')
            .replaceAll('+972', ''));
    dateTime = user.getUserDetails()!.data!.customer!.customerBirthday;
    selectedGender = user.getUserDetails()!.data!.customer!.customerGender;
    _selectedCity = Datum(
      id: user.getUserDetails()!.data!.customer!.customerGovernorate!.id,
      governorateName: user
          .getUserDetails()!
          .data!
          .customer!
          .customerGovernorate!
          .governorateName,
      governoratePrice: user
          .getUserDetails()!
          .data!
          .customer!
          .customerGovernorate!
          .governoratePrice,
    );
    CacheServices.instance.readCities().then((value) {
      _citiesList = value;
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    var user = Provider.of<UserProvider>(context, listen: false);
    var error = Provider.of<ErrorString>(context);
    log(user.getUserDetails()!.data!.token.toString());
    return LoadingOverlay(
      isLoading: state.getStateStatus() == AppCurrentState.IsBusy,
      color: Colors.transparent,
      progressIndicator: ProcessingWidget(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Color(0xffF9F9F9)),
        child: _citiesList == null
            ? Center(
                child: ProcessingWidget(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Image.asset('assets/images/user_img.png',
                              width: 21.09, height: 24.52),
                          SizedBox(width: 10),
                          Text(
                            'My Profile',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                  height: 130.44,
                                  width: 130.44,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(70),
                                    child: _image != null
                                        ? Image.file(
                                            _image!,
                                            height: 130.44,
                                            width: 130.44,
                                            fit: BoxFit.fill,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: user
                                                .getUserDetails()!
                                                .data!
                                                .customer!
                                                .image
                                                .toString(),
                                            height: 130.44,
                                            width: 130.44,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/images/user_ph.jpeg',
                                              fit: BoxFit.cover,
                                              height: 130.44,
                                              width: 130.44,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/images/user_ph.jpeg',
                                              height: 130.44,
                                              width: 130.44,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  )),
                              InkWell(
                                onTap: () {
                                  getProfileImage();
                                },
                                child: Container(
                                    height: 130.44,
                                    width: 130.44,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0x66000000)),
                                    child: Center(
                                        child: Image.asset(
                                      'assets/images/upload_icon.png',
                                      height: 30,
                                      width: 30,
                                    ))),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          AuthTextField(
                            controller: _nameController,
                            hint: 'Full Name',
                            lines: 1,
                            onPwdTap: () {},
                            validator: (String) {},
                          ),
                          SizedBox(
                            height: 19,
                          ),
                          getGenderDropDown(),
                          SizedBox(
                            height: 19,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border:
                                    Border.all(color: const Color(0xffBEBEBE)),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateTime == null
                                        ? "Your Birth Date"
                                        : DateFormat.yMMMEd().format(dateTime!),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w500

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
                          SizedBox(
                            height: 19,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2, child: getCountryCodeDropDown()),
                              const SizedBox(width: 3),
                              Expanded(
                                flex: 4,
                                child: AuthTextField(
                                  controller: _numberController,
                                  isNumberField: true,
                                  keyBoardType: TextInputType.number,
                                  hint: 'Ex. 598114577',
                                  onPwdTap: () {},
                                  validator: (val) {},
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 19,
                          ),
                          AuthTextField(
                            controller: _cityController,
                            hint: 'Address',
                            lines: 3,
                            onPwdTap: () {},
                            validator: (String) {},
                          ),
                          SizedBox(
                            height: 19,
                          ),
                          getCityDropDown(),
                          SizedBox(height: 19,),
                          getVIPTextField(),
                          SizedBox(
                            height: 40,
                          ),
                          AppButtonPrimary(
                              onTap: () async {
                                if (_nameController.text.isEmpty) {
                                  getFlushBar(context,
                                      title: 'Name cannot be empty.');
                                  return;
                                }
                                if (selectedGender == null) {
                                  getFlushBar(context,
                                      title: 'Kindly select gender.');
                                  return;
                                }
                                if (dateTime == null) {
                                  getFlushBar(context,
                                      title: 'Kindly select date of birth.');
                                  return;
                                }
                                if (_selectedCity == null) {
                                  getFlushBar(context,
                                      title: 'Kindly select governorate.');
                                  return;
                                }

                                if (_numberController.text.isEmpty) {
                                  getFlushBar(context,
                                      title: 'Phone number cannot be empty.');
                                  return;
                                }if (_numberController.text.length < 9) {
                                  getFlushBar(context,
                                      title: 'Kindly enter valid phone number.');
                                  return;
                                }
                                if (_cityController.text.isEmpty) {
                                  getFlushBar(context,
                                      title: 'Address cannot be empty.');
                                  return;
                                }
                                var model;

                                try {
                                  await FirebaseMessaging.instance
                                      .getToken()
                                      .then((token) async {
                                    model = await AuthServices().updateProfile(
                                        context,
                                        customerMobile: selectedNumber +
                                            _numberController.text,
                                        name: _nameController.text,
                                        customerCity: _cityController.text,
                                        customerGovernorate:
                                            _selectedCity!.id.toString(),
                                        customerBirthday:
                                            '${dateTime!.year.toString()}-${dateTime!.month.toString()}-${dateTime!.day.toString()}',
                                        customerGender: selectedGender == 'Male'
                                            ? '2'
                                            : '1',
                                        userID: user
                                            .getUserDetails()!
                                            .data!
                                            .customer!
                                            .id
                                            .toString(),
                                        file: _image,
                                        vipCard: result,

                                        token: user
                                            .getUserDetails()!
                                            .data!
                                            .token
                                            .toString(),
                                        firebaseToken: token.toString(),
                                        state: state);
                                  });

                                  if (state.getStateStatus() ==
                                      AppCurrentState.IsFree) {
                                    user.saveUserDetails(UserModel(
                                        success: user.getUserDetails()!.success,
                                        message: user.getUserDetails()!.message,
                                        data: Data(
                                            token: user
                                                .getUserDetails()!
                                                .data!
                                                .token,
                                            customer: model)));
                                    Navigator.pop(context);
                                  } else {
                                    getFlushBar(context,
                                        title: error.getErrorString());
                                  }
                                } catch (e) {
                                  state.stateStatus(AppCurrentState.IsError);
                                  getFlushBar(context, title: error.getErrorString());
                                }
                              },
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              text: 'UPDATE'),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }



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
              result == "" || result == "null" || result == "-1" ? "Do you have VIP card? Scan It." : result,
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
            'Your Gender',
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

  Future getProfileImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    pickedFile = await picker.getImage(
      imageQuality: 20,
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
      height: 54,
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
}
