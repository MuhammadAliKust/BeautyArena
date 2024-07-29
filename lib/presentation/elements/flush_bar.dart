import 'package:another_flushbar/flushbar.dart';
import 'package:beauty_arena_app/presentation/views/cart_screen/cart_view.dart';
import 'package:flutter/material.dart';

import '../views/login_screen/login_view.dart';

getFlushBar(
  BuildContext context, {
  required String title,
}) {
  return Flushbar(
    message: title,
    icon: const Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.blue,
    ),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
  )..show(context);
}

addToCartFlushBar(
  BuildContext context, {
  required String title,
}) {
  return Flushbar(
    message: title,
    icon: const Icon(
      Icons.check_circle_outline_rounded,
      size: 28.0,
      color: Colors.green,
    ),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
    mainButton: TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartView()));
      },
      child: Text(
        "Go to Cart",
        style: TextStyle(color: Colors.yellow),
      ),
    ),
  )..show(context);
}

getLoginFlushBar(BuildContext context) {
  return Flushbar(
    message: 'Kindly login in order to continue.',
    icon: const Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.blue,
    ),
    mainButton: TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      },
      child: Text(
        "Login",
        style: TextStyle(color: Colors.yellow),
      ),
    ),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
  )..show(context);
}
