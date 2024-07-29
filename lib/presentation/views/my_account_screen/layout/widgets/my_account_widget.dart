import 'package:flutter/material.dart';

class MyAccountWidget extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback onTap;

  const MyAccountWidget({
    required this.onTap,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return   InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: const Color(0x66000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 53,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              children: [
                Image.asset(image,width: 17.5,height: 22),
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
          ),
        ),
      ),
    );
  }
}
