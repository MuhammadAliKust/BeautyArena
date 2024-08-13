import 'package:flutter/material.dart';

class AppButtonPrimary extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const AppButtonPrimary({
    required this.onTap,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: MediaQuery.of(context).size.width,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(7),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Color(0x40000000),
                    //shadow for button
                    blurRadius: 4) //blur radius of shadow
              ]),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledForegroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  )
                  //make color or elevated button transparent
                  ),
              onPressed: () => onTap(),
              child: Text(
                text,
                style:  TextStyle(
                    color: textColor,
                    fontSize: 16,
                    letterSpacing: 0.7,
                    fontWeight: FontWeight.w500),
              ))),
    );
  }
}
