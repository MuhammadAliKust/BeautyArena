import 'package:beauty_arena_app/infrastructure/models/brand.dart';
import 'package:flutter/material.dart';

class SearchProviders extends ChangeNotifier {
  List<Datum> _brandList = [];

  void saveBrandList(List<Datum> list) {
    _brandList = list;
  }

  List<Datum> get getBrandList => _brandList;
}
