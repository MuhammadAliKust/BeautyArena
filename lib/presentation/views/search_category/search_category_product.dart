import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../infrastructure/models/categories.dart';
import 'layout/body.dart';

class SearchCategoryProductsView extends StatelessWidget {
  final String categoryID;

  const SearchCategoryProductsView({Key? key, required this.categoryID})
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
      body: SearchCategoryProductsViewBody(
        categoryID: categoryID,
      ),
    );
  }
}
