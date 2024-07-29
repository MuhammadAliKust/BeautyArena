import 'package:flutter/material.dart';
import '../../elements/app_drawer.dart';
import '../../elements/custom_app_bar.dart';
import 'layout/body.dart';

class ShopView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(),
      drawer: CustomAppDrawer(),
      body: const ShopViewBody(),
    );
  }
}
