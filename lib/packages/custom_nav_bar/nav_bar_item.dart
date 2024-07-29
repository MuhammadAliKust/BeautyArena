import 'package:flutter/material.dart';

class BottomIndicatorNavigationBarItem {
  final Widget icon;
  final Color backgroundColor;
  final String label;

  BottomIndicatorNavigationBarItem({
    required this.icon,
    required this.label,
    this.backgroundColor = Colors.white,
  });
}
