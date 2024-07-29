import 'package:flutter/material.dart';
import '../../configurations/front_end_configs.dart';

class CustomSelectionContainer extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomSelectionContainer({
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xffBEBEBE)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
                color: FrontEndConfigs.kGreyColor
                    .withOpacity(0.6),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 17)
          ],
        ),
      ),
    );
  }
}
