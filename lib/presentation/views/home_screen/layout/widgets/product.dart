import 'package:beauty_arena_app/infrastructure/models/dashboard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../application/user_provider.dart';
import '../../../../../configurations/front_end_configs.dart';
import '../../../../elements/flush_bar.dart';
import '../../../product_details/item_details_view.dart';

class ProductWidget extends StatelessWidget {
  final Product model;
  final String categoryID;

  const ProductWidget({Key? key, required this.model, required this.categoryID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    return InkWell(
      onTap: () {
        if (user.getUserDetails() == null) {
          getLoginFlushBar(context);
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetailsView(
                      model: model,
                      categoryID: categoryID,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: model.image.toString(),
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/ph.jpg',
                        fit: BoxFit.cover,
                        height: 140,
                        width: 140,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/ph.jpg',
                        height: 140,
                        width: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (model.outOfStock == 1)
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 20,
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6)),
                                color: FrontEndConfigs.kPrimaryColor),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey2,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(6),
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6)),
                                ),
                                child: Center(
                                    child: Text(
                                  "Out of Stock!",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                              ),
                            ),
                          )),
                    ),
                  if (model.salePrice != 0)
                    Positioned(
                      top: model.outOfStock == 1 ? 25 : 10,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            color: Color(0xffDE1D1D)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            '- ${model.offer_percentage.toString()}%',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 3),
              if (model.offer != 0)
                Row(
                  children: [
                    Text(
                      '₪${model.salePrice.toString()}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffDE1D1D)),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '₪${model.price.toString()}',
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff9B9B9B)),
                    ),
                  ],
                )
              else
                Text(
                  '₪${model.price.toString()}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              Text(
                model.name.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
