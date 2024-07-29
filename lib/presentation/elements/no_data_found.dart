import 'package:flutter/material.dart';

class NoDataFoundView extends StatelessWidget {
  final String description;

  const NoDataFoundView({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/no_data.png',
          height: 200,
        ),
        const SizedBox(
          height: 10,
        ),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Data Found!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9B9B9B)),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
