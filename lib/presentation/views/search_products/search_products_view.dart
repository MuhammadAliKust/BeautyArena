import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../infrastructure/models/categories.dart';
import 'layout/body.dart';

class SearchProductsView extends StatelessWidget {
  final String brandID;
  final String brandName;

  const SearchProductsView(
      {Key? key, required this.brandID, required this.brandName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset('assets/images/logo.png',
            color: Colors.white, width: 133.48, height: 23.57),
      ),
      body: SearchProductsViewBody(
        brandID: brandID,
        brandName: brandName,
      ),
    );
  }
}
