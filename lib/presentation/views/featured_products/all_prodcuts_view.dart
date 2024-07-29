import 'package:flutter/material.dart';

import '../../../infrastructure/models/dashboard.dart';
import 'layout/body.dart';

class AllProductsView extends StatelessWidget {
  final List<Product> productList;
  final String categoryID;

  const AllProductsView(
      {Key? key, required this.productList, required this.categoryID})
      : super(key: key);

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
      body: AllProductsViewBody(
        productList: productList,
        categoryID: categoryID,
      ),
    );
  }
}
