import 'package:flutter/material.dart';

import '../../../../infrastructure/models/dashboard.dart';
import '../../../../infrastructure/models/product.dart';
import '../../explore_screen/layout/widgets/explore_product_widget.dart';

class AllProductsViewBody extends StatelessWidget {
  final List<Product> productList;
  final String categoryID;

  const AllProductsViewBody({Key? key, required this.productList, required this.categoryID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 4.3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20),
          itemCount: productList.length,
          itemBuilder: (BuildContext ctx, i) {
            return ExploreProductWidget(
              model: Datum(
                id: productList[i].id,
                name: productList[i].name,
                price:  productList[i].price,
                image: productList[i].image,
                status:  productList[i].status,
                images:  productList[i].images,
                description: productList[i].description,
                inventory: productList[i].inventory,
                type: '',
                offer:  productList[i].offer,
                salePrice: productList[i].salePrice,
              ),
              categoryID: categoryID,
            );
          }),
    );
  }
}
