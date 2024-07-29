import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'layout/body.dart';

class ShippingAddressEditView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Cart',
          style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white,size: 25), onPressed: () {},
        ),
      ),
      body: ShippingAddressEditViewBody(),
    );
  }
}
