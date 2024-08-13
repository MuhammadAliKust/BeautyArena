import 'package:beauty_arena_app/presentation/elements/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../elements/custom_app_bar.dart';
import 'layout/body.dart';

class NotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset('assets/images/logo.png',
            color: Colors.white, width: 133.48, height: 23.57),
      ),
      body: const NotificationViewBody(),
    );
  }
}
