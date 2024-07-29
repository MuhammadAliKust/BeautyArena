import 'package:flutter/material.dart';

class CustomAppDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset('assets/images/dp.png',
                            fit: BoxFit.fill),
                      ),
                      const SizedBox(width: 17),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Marian Moura',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            '+970598114577',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0x66000000),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Image.asset('assets/icons/drawer_home_icon.png',
                  height: 20, width: 17.12),
              title: _getCustomText('Home'),
            ),
            ListTile(
              leading: Image.asset('assets/icons/drawer_my_account_icon.png',
                  height: 20, width: 17.12),
              title: _getCustomText('My Account'),
            ),
            ListTile(
              leading: Image.asset('assets/icons/drawer_categories_icon.png',
                  height: 20, width: 17.12),
              title: _getCustomText('Categories')
            ),
            ListTile(
              leading: Image.asset('assets/icons/drawer_brands_icon.png',
                  height: 20, width: 17.12),
              title: _getCustomText('Brands')
            ),
            ListTile(
              leading: Image.asset('assets/icons/drawer_settings_icon.png',
                  height: 20, width: 17.12),
              title: _getCustomText('Settings')
            ),
            ListTile(
              leading: Image.asset('assets/icons/drawer_logout_icon.png',
                  height: 20, width: 17.12),
              title: _getCustomText('Logout')
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: InkWell(
                onTap: (){},
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_phone_sharp, color: Colors.white),
                        const SizedBox(width: 7),
                        const Text(
                          'Contact Support',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
    );
  }

  Widget _getCustomText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
    );
  }
}
