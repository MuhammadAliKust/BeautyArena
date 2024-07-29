import 'package:flutter/material.dart';

import '../../configurations/front_end_configs.dart';

class SelectTypeContainer extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectTypeContainer({
    required this.onTap,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 34.11,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: isSelected
                  ? FrontEndConfigs.kPrimaryColor
                  : const Color(0xffE8E8E8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xff313131)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
