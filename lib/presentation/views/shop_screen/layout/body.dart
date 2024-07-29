import 'package:flutter/material.dart';
import 'widgets/shop_widget.dart';

class ShopViewBody extends StatelessWidget {
  const ShopViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Colors.white),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Image.asset('assets/icons/shop_icon.png',
                    width: 28.34, height: 23.91),
                const SizedBox(width: 7),
                const Text(
                  'Shop',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return    ShopWidget(
                    onTap: (){},
                    categoryname: 'Perfumes',
                    noofitems: '1065',
                    image: 'assets/images/perfume_img.png',
                  );
                }),
          ),
        ],
      ),
    );
  }
}
