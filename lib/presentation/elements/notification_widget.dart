import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configurations/front_end_configs.dart';

class NotificationWidget extends StatelessWidget {
  final String text;
  final String image;
  final bool isEnabled;
  final Function(bool) onTap;

  const NotificationWidget({
    required this.onTap,
    required this.text,
    required this.isEnabled,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: const Color(0x66000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 53,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: Colors.black,
                    size: 19,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              Transform.scale(
                scale: 0.5,
                child: CupertinoSwitch(
                  onChanged: onTap,
                  value: isEnabled,
                  activeColor: FrontEndConfigs.kPrimaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
