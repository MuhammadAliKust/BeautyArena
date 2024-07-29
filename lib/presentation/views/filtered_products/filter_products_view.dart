import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../infrastructure/models/categories.dart';
import 'layout/body.dart';

class FilteredProductsView extends StatelessWidget {
  final String name;
  final String brandID;
  final String categoryID;
  final String productType;
  final int priceOrder;

  const FilteredProductsView(
      {Key? key,
      required this.name,
      required this.categoryID,
      required this.productType,
      required this.priceOrder,
      required this.brandID})
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
      body: FilteredProductsViewBody(
        name: name,
        brandID: brandID,
        categoryID: categoryID,
        productType: productType,
        priceOrder: priceOrder,
      ),
    );
  }
}
