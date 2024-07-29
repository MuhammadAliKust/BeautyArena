import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProcessingWidget extends StatelessWidget {
  const ProcessingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black.withOpacity(0.5)),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: CupertinoActivityIndicator(
          radius: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
