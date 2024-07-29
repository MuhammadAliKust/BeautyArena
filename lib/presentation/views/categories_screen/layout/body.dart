import 'dart:async';
import 'package:beauty_arena_app/presentation/views/categories_screen/layout/widgets/categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../application/app_state.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../infrastructure/models/categories.dart';
import '../../../../infrastructure/services/categories.dart';
import '../../../elements/processing_widget.dart';

class CategoryViewBody extends StatelessWidget {
  const CategoryViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context);
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
                Image.asset('assets/images/shop_img.png',
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
          FutureProvider.value(
            value: CategoriesServices().getAllCategories(
                context, state, user.getUserDetails()!.data!.token.toString()),
            initialData: CategoriesModel(),
            builder: (context, child) {
              var model = context.watch<CategoriesModel>();
              if (state.getStateStatus() == AppCurrentState.IsBusy) {
                return const Center(child: ProcessingWidget());
              } else if (state.getStateStatus() == AppCurrentState.IsError) {
                return const Text('No Internet');
              } else {
                return Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: model.data!.length,
                      itemBuilder: (BuildContext context, int i) {
                        return CategoriesWidget(
                          model: model.data![i],
                        );
                      }),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
