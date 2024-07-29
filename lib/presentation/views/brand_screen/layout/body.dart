import 'dart:async';
import 'package:beauty_arena_app/presentation/views/categories_screen/layout/widgets/categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../application/app_state.dart';
import '../../../../application/search_providers.dart';
import '../../../../application/user_provider.dart';
import '../../../../configurations/enums.dart';
import '../../../../configurations/front_end_configs.dart';
import '../../../../infrastructure/models/brand.dart';
import '../../../../infrastructure/services/brands.dart';
import '../../../elements/no_data_found.dart';
import '../../../elements/processing_widget.dart';
import 'widgets/categories_widget.dart';

class BrandsViewBody extends StatefulWidget {
  const BrandsViewBody({Key? key}) : super(key: key);

  @override
  State<BrandsViewBody> createState() => _BrandsViewBodyState();
}

class _BrandsViewBodyState extends State<BrandsViewBody> {
  TextEditingController _searchController = TextEditingController();
  List<Datum> searchBrand = [];
  List<Datum> brandsList = [];

  bool isSearchingAllow = false;

  bool isSearched = false;

  void _searchData(String val) async {
    searchBrand.clear();
    var search = Provider.of<SearchProviders>(context, listen: false);
    for (var i in search.getBrandList) {
      var lowerCaseString = i.title.toString().toLowerCase();
      ;

      var defaultCase = i.title.toString();
      if (lowerCaseString.contains(val) || defaultCase.contains(val)) {
        isSearched = true;

        searchBrand.add(i);
      } else {
        isSearched = true;
      }

      setState(() {});
    }
  }


  @override
  void initState() {
    var user = Provider.of<UserProvider>(context,listen: false);
    var state = Provider.of<AppState>(context, listen: false);
    BrandServices().getAllBrands(context, state,
        user.getUserDetails()!.data!.token.toString()).then((value) {
      brandsList = value.data!;
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    var user = Provider.of<UserProvider>(context);
    var search = Provider.of<SearchProviders>(context);
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Colors.white),
      child: brandsList.isEmpty ? Center(child: ProcessingWidget(),) : Column(
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
                  'Brands',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onChanged: (val) {
                        if (val == "") {
                          isSearchingAllow = false;
                          searchBrand.clear();
                          setState(() {});
                        } else {
                          isSearchingAllow = true;
                          _searchData(val);
                        }
                      },
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500),
                      cursorColor: FrontEndConfigs.kGreyColor.withOpacity(0.2),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 17, horizontal: 15),
                        hintText: "What are you searching for?",
                        hintStyle: TextStyle(
                          color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Color(0xffBEBEBE)),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Color(0xffBEBEBE)),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (searchBrand.isEmpty && isSearchingAllow == true)
            NoDataFoundView(
              description:
              "Sorry! We cannot find any user related to your search.",
            )
          else
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchBrand.isNotEmpty
                      ? searchBrand.length
                      : brandsList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return BrandsWidget(
                      model: searchBrand.isNotEmpty
                          ? searchBrand[i]
                          : brandsList[i],
                    );
                  }),
            )
        ],
      ),
    );
  }
}
