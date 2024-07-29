import 'package:beauty_arena_app/infrastructure/models/categories.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../explore_screen/explore_view.dart';

class CategoriesWidget extends StatelessWidget {
  final Datum model;

  const CategoriesWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4.5),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExploreView(category: model)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 88,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image:
                      AssetImage('assets/images/categories_container_bg.png')),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 5, top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: Text(
                        model.name.toString(),
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),

                  ],
                ),
                CachedNetworkImage(
                  imageUrl: model.image.toString(),
                  width: 76,
                  height: 76,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Image.asset(
                      'assets/images/categories_container_bg.png',
                      fit: BoxFit.cover,
                      width: 76,
                      height: 76),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/categories_container_bg.png',
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
