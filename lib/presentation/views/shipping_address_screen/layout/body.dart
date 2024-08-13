import 'dart:async';
import 'dart:developer';
import 'package:beauty_arena_app/infrastructure/models/order_response.dart';
import 'package:beauty_arena_app/presentation/views/paymen_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../../../application/app_state.dart';
import '../../../../application/cart_provider.dart';
import '../../../../application/errorStrings.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../configurations/front_end_configs.dart';
import '../../../../infrastructure/models/city.dart';
import '../../../../infrastructure/services/city.dart';
import '../../../../infrastructure/services/local.dart';
import '../../../../infrastructure/services/order.dart';
import '../../../elements/auth_text_field.dart';
import '../../../elements/flush_bar.dart';
import '../../../elements/processing_widget.dart';
import '../../bottom_bar.dart';
import '../../shipping_address_edit_screen/layout/body.dart';
import '../../shopping_cart_done_screen/shopping_cart_done_view.dart';
import '../shipping_address_view.dart';

class ShippingAddressViewBody extends StatefulWidget {
  final num discount;

  const ShippingAddressViewBody({super.key, required this.discount});

  @override
  State<ShippingAddressViewBody> createState() =>
      _ShippingAddressViewBodyState();
}

class _ShippingAddressViewBodyState extends State<ShippingAddressViewBody> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  List<CityModel>? _citiesList;
  Datum? _selectedCity;
  String selectedPayment = "1";
  bool isPickUpEnabled = false;

  @override
  void initState() {
    var user = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(
        text: user.getUserDetails()!.data!.customer!.name.toString());
    _addressController = TextEditingController(
        text: user.getUserDetails()!.data!.customer!.customerCity.toString());
    _numberController = TextEditingController(
        text: user.getUserDetails()!.data!.customer!.customerMobile.toString());
    CacheServices.instance.readCities().then((value) {
      _citiesList = value;
      setState(() {});
    });

    _selectedCity = Datum(
      id: user.getUserDetails()!.data!.customer!.customerGovernorate!.id,
      governoratePrice: user
          .getUserDetails()!
          .data!
          .customer!
          .customerGovernorate!
          .governoratePrice,
      governorateName: user
          .getUserDetails()!
          .data!
          .customer!
          .customerGovernorate!
          .governorateName,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    var state = Provider.of<AppState>(context);
    var user = Provider.of<UserProvider>(context);
    var error = Provider.of<ErrorString>(context);
    return LoadingOverlay(
      isLoading: state.getStateStatus() == AppCurrentState.IsBusy,
      progressIndicator: const ProcessingWidget(),
      color: Colors.transparent,
      child: Scaffold(
        bottomNavigationBar: cart.cartItems.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Payment Methods",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  selectedPayment = '1';
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/cod.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Cash of Delivery - الدفع عند الإستلام",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      selectedPayment == '1'
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      size: 18,
                                      color: FrontEndConfigs.kPrimaryColor,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  selectedPayment = '2';
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/card.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Pay Online - الدفع أون لاين",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      selectedPayment == '2'
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      size: 18,
                                      color: FrontEndConfigs.kPrimaryColor,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 0),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  isPickUpEnabled = !isPickUpEnabled;
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Pickup from store – الإستلام من المحل",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ],
                                    ),
                                    Transform.scale(
                                      scale: 0.6,
                                      child: CupertinoSwitch(
                                          value: isPickUpEnabled,
                                          onChanged: (val) {
                                            isPickUpEnabled = val;
                                            setState(() {});
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sub total',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0x66000000)),
                                  ),
                                  Text(
                                    '₪${cart.getSubTotal()}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0x66000000)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discount',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0x66000000)),
                                  ),
                                  Text(
                                    '₪${widget.discount}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0x66000000)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              if (isPickUpEnabled)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pick up from store – الإستلام من المحل',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0x66000000)),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Shipping to ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0x66000000)),
                                        ),
                                        Text(
                                          _selectedCity!.governorateName
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xffD0021B)),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '₪${_selectedCity!.governoratePrice.toString()}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0x66000000)),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '₪${cart.getSubTotal() + (isPickUpEnabled ? 0 : _selectedCity!.governoratePrice!) - widget.discount}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_nameController.text.isEmpty) {
                        getFlushBar(context, title: "Name cannot be empty.");
                        return;
                      }
                      if (_selectedCity == null) {
                        getFlushBar(context, title: 'Kindly select city.');
                        return;
                      }
                      if (_addressController.text.isEmpty) {
                        getFlushBar(context, title: 'Address cannot be empty.');
                        return;
                      }
                      if (_numberController.text.isEmpty) {
                        getFlushBar(context,
                            title: 'Phone number cannot be empty.');
                        return;
                      }

                      try {
                        OrderResponseModel model = await OrdersServices()
                            .createNewOrder(context,
                                list: cart.cartItems,
                                note: _noteController.text,
                                address: _addressController.text,
                                deviceID: '123',
                                number: _numberController.text,
                                token: user
                                    .getUserDetails()!
                                    .data!
                                    .token
                                    .toString(),
                                fullName: _nameController.text,
                                governorate: _selectedCity!.id.toString(),
                                shipping:
                                    _selectedCity!.governoratePrice!.toString(),
                                paidBy: selectedPayment,
                                total: (cart.getSubTotal() +
                                        _selectedCity!.governoratePrice!)
                                    .toString(),
                                state: state);
                        if (state.getStateStatus() == AppCurrentState.IsFree) {
                          cart.emptyCart();
                          if (selectedPayment == '2') {
                            log(model.data!.authorizationUrl.toString());

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentView(
                                        url: model.data!.authorizationUrl
                                            .toString())));
                          } else {
                            await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShoppingCartDoneView()));
                          }
                        } else {
                          getFlushBar(context, title: error.getErrorString());
                        }
                      } catch (e) {
                        state.stateStatus(AppCurrentState.IsError);
                        getFlushBar(context, title: e.toString());
                      }
                    },
                    child: Container(
                      height: 75,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          'COMPLETE ORDER',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : null,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                if (!isPickUpEnabled) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/shipping_address_icon.png',
                              width: 30, height: 30),
                          SizedBox(width: 10),
                          Text(
                            'Shipping Address',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Text(
                    'This is the address that we will ship to.',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff515151)),
                  ),
                  SizedBox(height: 10),
                  AuthTextField(
                    controller: _nameController,
                    hint: 'Your Name',
                    lines: 1,
                    onPwdTap: () {},
                    validator: (String) {},
                  ),
                  SizedBox(height: 13),
                  if (_citiesList != null) getCityDropDown(),
                  SizedBox(height: 13),
                  AuthTextField(
                    controller: _addressController,
                    hint: 'Your Address',
                    lines: 1,
                    onPwdTap: () {},
                    validator: (String) {},
                  ),
                  SizedBox(height: 13),
                  AuthTextField(
                    controller: _numberController,
                    hint: 'Your Phone Number',
                    lines: 1,
                    onPwdTap: () {},
                    validator: (String) {},
                  ),
                  SizedBox(height: 13),
                ],
                AuthTextField(
                  controller: _noteController,
                  hint: 'Any specific instruction..',
                  lines: 3,
                  onPwdTap: () {},
                  validator: (String) {},
                ),
                SizedBox(height: 20),
                if (!isPickUpEnabled)
                  Text(
                    '*The shipping period is usually between 2-5 working days. We will contact you with more details.',
                    style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff515151)),
                  ),
              ],
            ),
          ),
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
}
