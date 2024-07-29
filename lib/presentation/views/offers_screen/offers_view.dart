import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../elements/app_drawer.dart';
import '../../elements/custom_app_bar.dart';
import 'layout/body.dart';

class OffersView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:  OffersViewBody(),
    );
  }
}
