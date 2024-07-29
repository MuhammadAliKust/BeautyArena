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
      body: const NotificationViewBody(),
    );
  }
}
