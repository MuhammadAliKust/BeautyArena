import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:share_plus/share_plus.dart';


class DeepLinkView extends StatelessWidget {
  const DeepLinkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(

      title: Text("Deep Link"),
    ),
    body: Center(child: ElevatedButton(
      onPressed: ()async{
        // You can add CustomMetaData to use different behaviours for links
        BranchUniversalObject buo = BranchUniversalObject(
          canonicalIdentifier: 'flutter/branch',
          //canonicalUrl: '',
          title: 'Clinic On App',
          imageUrl:
          'https://drive.google.com/file/d/14Cox2rNHi2Fq81mXtd_DK4XKAIORtRGK/view?usp=sharing',
          contentDescription:
          'Download App And Manage clinics effortlessly.Create, add doctors, and schedule appointments.',
          keywords: ['Plugin', 'Branch', 'Flutter'],
          publiclyIndex: true,
          locallyIndex: true,
          contentMetadata: BranchContentMetaData()
            ..addCustomMetadata('custom_string', 'abc')
            ..addCustomMetadata('custom_number', 12345)
            ..addCustomMetadata('custom_bool', true)
            ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
            ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
        );
        FlutterBranchSdk.registerView(buo: buo); // Register a view to see the analytics
        BranchLinkProperties lp = BranchLinkProperties(
          //alias: 'flutterplugin', //define link url,
            channel: 'facebook',
            feature: 'sharing',
            stage: 'new share',
            tags: ['one', 'two', 'three']);
        // lp.addControlParam('\$uri_redirect_mode', '1'); // this will redirect the link to application
        BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
        if (response.success) {
          print('Link generated: ${response.result}');
        } else {
          print('Error : ${response.errorCode} - ${response.errorMessage}');
        }
        Share.share(response.result);
      },
      child: Icon(Icons.add),
    ),),);
  }
}
