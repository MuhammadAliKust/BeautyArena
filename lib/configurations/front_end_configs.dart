import 'package:flutter/cupertino.dart';

import '../packages/custom_nav_bar/nav_bar_item.dart';

class FrontEndConfigs {
  static const Color kPrimaryColor = Color(0xff000000);
  static const Color kGreyColor = Color(0xff6B7280);
  static const Color kBodyColor = Color(0xff6B7280);
  static const Color kSelectedColor = Color(0xffDEB77A);

  static List<BottomIndicatorNavigationBarItem> getBottomNavBarItem(
      int selectedIndex) {
    var items = <BottomIndicatorNavigationBarItem>[
      BottomIndicatorNavigationBarItem(
          icon: Image.asset(
            'assets/images/home_icon.png',
            color: selectedIndex == 0
                ? FrontEndConfigs.kSelectedColor
                : FrontEndConfigs.kBodyColor,
            height: selectedIndex == 0 ? 20 : 16,
            width: 20,
          ),
          label: "Home"),
      BottomIndicatorNavigationBarItem(
          icon: Image.asset(
            'assets/images/user_img.png',
            color: selectedIndex == 1
                ? FrontEndConfigs.kSelectedColor
                : FrontEndConfigs.kBodyColor,
            height: selectedIndex == 1 ? 20 : 16,
            width: 20,
          ),
          label: "Profile"), BottomIndicatorNavigationBarItem(
          icon: Image.asset(
            'assets/images/heart.png',
            color: selectedIndex == 2
                ? FrontEndConfigs.kSelectedColor
                : FrontEndConfigs.kBodyColor,
            height: selectedIndex == 2 ? 20 : 16,
            width: 20,
          ),
          label: "Favorite"),
      BottomIndicatorNavigationBarItem(
          icon: Image.asset(
            'assets/images/offer.png',
            color: selectedIndex == 3
                ? FrontEndConfigs.kSelectedColor
                : FrontEndConfigs.kBodyColor,
            height: selectedIndex == 3 ? 20 : 16,
            width: 20,
          ),
          label: 'Offers'),
      BottomIndicatorNavigationBarItem(
          icon: Image.asset(
            'assets/images/makeover.png',
            color: selectedIndex == 4
                ? FrontEndConfigs.kSelectedColor
                : FrontEndConfigs.kBodyColor,
            height: selectedIndex == 4 ? 20 : 16,
            width: 20,
          ),
          label: "Marian’s Corner"),

    ];

    return items;
  }
}
