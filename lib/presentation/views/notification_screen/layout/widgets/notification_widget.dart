import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationWidget extends StatelessWidget {
  final Color backgroundcolor;
  final String image;
  final String heading;
  final String subHeading;
  final String time;
  final VoidCallback onTap;

  const NotificationWidget(
      {required this.onTap,
      required this.backgroundcolor,
      required this.image,
      required this.heading,
      required this.subHeading,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: backgroundcolor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xffF3F3F3)),
              child: Center(
                  child: Image.asset(
                image,
                width: 20,
                height: 20,
              )),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    heading,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    subHeading,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000)),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  DateFormat.yMMMMEEEEd().format(DateTime.parse(time)),
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0x66000000)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
