import 'package:flutter/material.dart';

class AppButtonSquareBorder extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AppButtonSquareBorder({
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Color(0x40000000),
                      //shadow for button
                      blurRadius: 4) //blur radius of shadow
                ]),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onSurface: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    )
                    //make color or elevated button transparent
                    ),
                onPressed: onTap,
                child: Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 0.7,
                      fontWeight: FontWeight.w700),
                ))),
      ),
    );
  }
}
