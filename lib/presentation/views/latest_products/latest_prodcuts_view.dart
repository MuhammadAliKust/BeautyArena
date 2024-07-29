import 'package:flutter/material.dart';

import '../../../infrastructure/models/dashboard.dart';
import 'layout/body.dart';

class LatestProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset('assets/images/logo.png',
            color: Colors.white, width: 133.48, height: 23.57),
      ),
      body: LatestProductsViewBody(),
    );
  }
}
