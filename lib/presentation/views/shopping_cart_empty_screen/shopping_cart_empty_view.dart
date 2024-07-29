import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'layout/body.dart';

class ShoppingCartEmptyView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Cart',
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white,size: 25), onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_2_circlepath, color: Colors.white,size: 25), onPressed: () {},
          ),
        ],
      ),
      body: const ShoppingCartEmptyViewbody(),
    );
  }
}
