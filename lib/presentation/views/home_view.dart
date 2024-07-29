import 'package:flutter/material.dart';

import 'categories_screen/categories_view.dart';
import 'home_screen/home_view.dart';
import 'my_account_screen/my_account_view.dart';
import 'my_orders_screen/my_orders_view.dart';
import 'notification_screen/notification_view.dart';
import 'offers_screen/offers_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationView()));
              },
              child: Text("Notification")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OffersView()));
              },
              child: Text("Offers")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoriesView()));
              },
              child: Text("Categories")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyOrdersView()));
              },
              child: Text("Orders")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyAccountView()));
              },
              child: Text("Profile")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreenView()));
              },
              child: Text("Home")),
        ],
      ),
    );
  }
}
