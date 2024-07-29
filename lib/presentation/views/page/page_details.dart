import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../infrastructure/models/page.dart';

class PageDetailsView extends StatelessWidget {
  final Datum model;

  const PageDetailsView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset('assets/images/logo.png',
            color: Colors.white, width: 133.48, height: 23.57),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Html(
              data: """${model.page_content.toString()}""",
            )
          ],
        ),
      ),
    );
  }
}
