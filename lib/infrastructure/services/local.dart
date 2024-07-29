import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/city.dart';
import '../models/dashboard.dart';
import '../models/page.dart';

class CacheServices {
  // Makes this a singleton class, as we want only want a single
  // instance of this object for the whole application
  CacheServices._privateConstructor();

  static final CacheServices instance = CacheServices._privateConstructor();

  static File? _allCitiesFile;
  static File? _allDashBoardFile;
  static File? _pageListingFile;

  static const _cityFileName = 'cityFile.txt';
  static const _dashBoardFileName = 'dashFile.txt';
  static const _pageFileName = 'pageFile.txt';

  static final Set<CityModel> _allCitySet = {};
  static final Set<DashboardModel> _allDashboardSet = {};
  static final Set<PageModel> _pageListingSet = {};

  /// Initialize file
  Future<File> _initCityFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$_cityFileName');
  }

  Future<File> _initDashboardFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$_dashBoardFileName');
  }

  Future<File> _initPageFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$_pageFileName');
  }

  /// Get the data file
  Future<File> get allCities async {
    if (_allCitiesFile != null) return _allCitiesFile!;

    _allCitiesFile = await _initCityFile();
    return _allCitiesFile!;
  }

  Future<File> get allDashboard async {
    if (_allDashBoardFile != null) return _allDashBoardFile!;

    _allDashBoardFile = await _initDashboardFile();
    return _allDashBoardFile!;
  }

  Future<File> get allPageListing async {
    if (_pageListingFile != null) return _pageListingFile!;

    _pageListingFile = await _initPageFile();
    return _pageListingFile!;
  }

  /// Write Data
  Future<void> writeCities(CityModel dataModel) async {
    _allCitySet.clear();
    final File fl = await allCities;
    _allCitySet.add(dataModel);
    final cityListMap = _allCitySet.map((e) => e.toJson()).toList();
    await fl.writeAsString(jsonEncode(cityListMap));
  }

  Future<void> writeDashboardData(DashboardModel dataModel) async {
    _allDashboardSet.clear();
    final fl = await allDashboard;
    _allDashboardSet.add(dataModel);
    final dashboardListMap = _allDashboardSet.map((e) => e.toJson()).toList();
    await fl.writeAsString(jsonEncode(dashboardListMap));
  }

  Future<void> writePageListing(PageModel dataModel) async {
    _pageListingSet.clear();
    final File fl = await allPageListing;
    _pageListingSet.add(dataModel);
    final pageListingDaaMap = _pageListingSet.map((e) => e.toJson()).toList();

    await fl.writeAsString(jsonEncode(pageListingDaaMap));
  }

  /// Read Data
  Future<List<CityModel>> readCities() async {
    try {
      final File fl = await allCities;
      final content = await fl.readAsString();
      final List<dynamic> jsonData = jsonDecode(content);

      final data = jsonData
          .map(
            (e) => CityModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<DashboardModel>> readDashboardData() async {
    try {
      final fl = await allDashboard;
      final content = await fl.readAsString();
      final List<dynamic> jsonData = jsonDecode(content);

      final data = jsonData
          .map(
            (e) => DashboardModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List<PageModel>> readPageListing() async {
    try {
      final File fl = await allPageListing;

      final content = await fl.readAsString();

      log(content.toString() + " Page Listing");
      final List<dynamic> jsonData = jsonDecode(content);
      List<PageModel> data = jsonData
          .map(
            (e) => PageModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
