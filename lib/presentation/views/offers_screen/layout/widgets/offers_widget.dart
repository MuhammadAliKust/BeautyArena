import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class OffersWidget extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  const OffersWidget({
    required this.onTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          color: Colors.black,
          dashPattern: [5,5],
          radius: const Radius.circular(4),
          strokeWidth: 2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 324,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: CachedNetworkImage(
              imageUrl: image,
              width: MediaQuery.of(context).size.width,
              height: 324,
              fit: BoxFit.fill,
              placeholder: (context, url) => Image.asset(
                'assets/images/ph.jpg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 324,
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/ph.jpg',
                width: MediaQuery.of(context).size.width,
                height: 324,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
