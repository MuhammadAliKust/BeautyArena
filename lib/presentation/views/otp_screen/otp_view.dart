import 'package:flutter/material.dart';
import 'layout/body.dart';

class OtpView extends StatelessWidget {
  final String number;

  OtpView(this.number);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: OtpViewBody(
        number: number,
      ),
    );
  }
}
