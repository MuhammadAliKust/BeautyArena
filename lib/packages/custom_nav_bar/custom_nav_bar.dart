import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../configurations/front_end_configs.dart';
import 'nav_bar_item.dart';

// ignore: must_be_immutable
class BottomIndicatorBar extends StatefulWidget {
  final Color? indicatorColor;
  final Color? activeColor;
  final Color inactiveColor;
  final bool shadow;
  final double fontSize;
  final double iconSize;

  int currentIndex;
  Widget? icon;
  final ValueChanged<int> onTap;
  final List<BottomIndicatorNavigationBarItem> items;

  BottomIndicatorBar({
    Key? key,
    required this.onTap,
    required this.items,
    this.activeColor,
    this.inactiveColor = Colors.grey,
    this.indicatorColor,
    this.shadow = true,
    this.currentIndex = 0,
    this.fontSize = 14,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  State createState() => _BottomIndicatorBarState();
}

class _BottomIndicatorBarState extends State<BottomIndicatorBar> {
  static const double BAR_HEIGHT = 54;
  static const double INDICATOR_HEIGHT = 5;

  List<BottomIndicatorNavigationBarItem> get items => widget.items;

  double width = 0;
  Color? activeColor;
  Duration duration = Duration(milliseconds: 170);

  double? _getIndicatorPosition(int index) {
    var isLtr = Directionality.of(context) == TextDirection.ltr;
    if (isLtr)
      return lerpDouble(-1.0, 1.0, index / (items.length - 1));
    else
      return lerpDouble(1.0, -1.0, index / (items.length - 1));
  }

  @override
  void initState() {
    super.initState();
    widget.icon = widget.items[0].icon;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    activeColor = widget.activeColor ?? Theme.of(context).indicatorColor;

    return Container(
      height: BAR_HEIGHT + MediaQuery.of(context).viewPadding.bottom,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Theme.of(context).cardColor,
        boxShadow: widget.shadow
            ? [
                BoxShadow(color: Colors.black12, blurRadius: 1),
              ]
            : null,
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: <Widget>[
          Positioned(
            top: INDICATOR_HEIGHT,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item) {
                var index = items.indexOf(item);
                return GestureDetector(
                  onTap: () => _select(index, item),
                  child: _buildItemWidget(item, index == widget.currentIndex),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            width: width,
            child: AnimatedAlign(
              alignment:
                  Alignment(_getIndicatorPosition(widget.currentIndex)!, 0),
              curve: Curves.linear,
              duration: duration,
              child: Stack(
                children: [
                  Container(
                    // color: widget.indicatorColor ?? activeColor,
                    width: width / items.length,
                    height: INDICATOR_HEIGHT,
                  ),
                  Positioned(
                    left: 15,
                    right: 15,
                    child: Container(
                      decoration: BoxDecoration(
                          color: FrontEndConfigs.kSelectedColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      width: width / items.length,
                      height: INDICATOR_HEIGHT,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _select(int index, BottomIndicatorNavigationBarItem item) {
    widget.currentIndex = index;
    widget.icon = item.icon;
    widget.onTap(widget.currentIndex);

    setState(() {});
  }

  Widget _buildItemWidget(
      BottomIndicatorNavigationBarItem item, bool isSelected) {
    final color = isSelected
        ? FrontEndConfigs.kSelectedColor
        : FrontEndConfigs.kBodyColor;
    return Container(
      color: item.backgroundColor,
      height: BAR_HEIGHT,
      width: width / items.length,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          item.icon,
          SizedBox(
            height: 3,
          ),
          Text(
            item.label,
            style: TextStyle(color: color, fontSize: 11),
          )
        ],
      ),
    );
  }
}
