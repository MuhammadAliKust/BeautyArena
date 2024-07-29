import 'package:flutter/material.dart';

class ShopWidget extends StatelessWidget {
  final String categoryname;
  final String noofitems;
  final String image;
  final VoidCallback onTap;

  const ShopWidget({
    required this.onTap,
    required this.categoryname,
    required this.noofitems,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 88,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      'assets/images/shop_container_bg.png')),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.only(left: 15,right: 5,top: 7,bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text(
                      categoryname,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          noofitems,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0x66000000)),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'items',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0x66000000)),
                        ),
                      ],
                    )
                  ],
                ),
                Image.asset(image,
                    width: 76, height: 76)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
