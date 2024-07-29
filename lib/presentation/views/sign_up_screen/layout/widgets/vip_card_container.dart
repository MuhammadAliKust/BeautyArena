import 'package:flutter/material.dart';

class VIPCardContainer extends StatelessWidget {
  final VoidCallback onTap;

  const VIPCardContainer({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xffC29927)),
          color: const Color(0xffFFFAE5)),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Text('Do you have VIP card? Type it here.',
            style: TextStyle(
                fontSize: 14,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
                color: Color(0xffBB9D83))),
      ),
    );
  }
}
