import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../configurations/front_end_configs.dart';
import '../../elements/app_drawer.dart';
import '../../elements/custom_app_bar.dart';
import 'layout/body.dart';

class MyAccountView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: FrontEndConfigs.kPrimaryColor,
      body:  MyAccountViewBody(),
    );
  }
}
