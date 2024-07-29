import 'package:flutter/material.dart';
import '../../configurations/front_end_configs.dart';

class CountryCodeContainer extends StatelessWidget {
  final String countrycode;
  final VoidCallback onTap;

  const CountryCodeContainer({
    required this.onTap,
    required this.countrycode,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: const Color(0xffBEBEBE)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Code',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                      color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    countrycode,
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w700,
                      color: FrontEndConfigs.kGreyColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 17)
            ],
          ),
        ),
      ),
    );
  }
}
