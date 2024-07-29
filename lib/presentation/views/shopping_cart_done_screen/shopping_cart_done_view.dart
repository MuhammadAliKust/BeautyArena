import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../bottom_bar.dart';
import 'layout/body.dart';

class ShoppingCartDoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Container()
      ),
      body: ShoppingCartDoneViewBody(),
    );
  }
}
