import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../application/user_provider.dart';
import '../../../../../infrastructure/models/categories.dart';
import '../../../../../infrastructure/models/dashboard.dart';
import '../../../../elements/flush_bar.dart';
import '../../../explore_screen/explore_view.dart';

class CategoryWidget extends StatelessWidget {
  final CategorySlider model;

  const CategoryWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        if (user.getUserDetails() == null) {
          getLoginFlushBar(context);
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExploreView(
                      category: Datum(
                          name: model.name.toString(),
                          id: model.id,
                          productCount: model.productCount,
                          image: model.image,
                          children: model.children!
                              .map((e) => Datum(
                                  id: e.id,
                                  productCount: e.productCount,
                                  image: e.image,
                                  name: e.name))
                              .toList()),
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          height: 34.11,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), color: Color(0xffE8E8E8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                model.name.toString().toUpperCase(),
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff313131)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
