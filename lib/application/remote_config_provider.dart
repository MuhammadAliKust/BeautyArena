import 'package:flutter/cupertino.dart';
import '../infrastructure/models/user.dart';

class RemoteConfigProvider extends ChangeNotifier {
  RemoteConfigModel? _model;

  void saveRemoteConfig(RemoteConfigModel? model) {
    _model = model;
    notifyListeners();
  }

  RemoteConfigModel? getRemoteConfig() => _model;
}

class RemoteConfigModel {
  final String baseUrl;
  final bool enableGuestBrowsing;
  final bool couponSection;
  final bool featuredSection;
  final bool onBoardingSection;
  final bool sliderSection;
  final String whatsappNumber;

  RemoteConfigModel(
      {required this.baseUrl,
      required this.enableGuestBrowsing,
      required this.couponSection,
      required this.featuredSection,
      required this.onBoardingSection,
      required this.sliderSection,
      required this.whatsappNumber});
}
