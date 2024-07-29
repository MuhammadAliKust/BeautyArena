import 'package:badges/badges.dart' as B;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

customAppBar() {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.black,
    title: Image.asset('assets/images/logo.png',
        color: Colors.white, width: 133.48, height: 23.57),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                  onTap: () {},
                  child: const Icon(Icons.search, color: Colors.white)),
            ),
            const SizedBox(width: 5),
            B.Badge(
              badgeContent: Text('3'),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                    onTap: () {},
                    child:
                        const Icon(CupertinoIcons.cart, color: Colors.white)),
              ),
            ),
          ],
        ),
      )
    ],
  );
}
