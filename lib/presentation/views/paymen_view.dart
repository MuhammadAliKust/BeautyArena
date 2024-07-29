import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:beauty_arena_app/presentation/elements/flush_bar.dart';
import 'package:beauty_arena_app/presentation/views/shopping_cart_done_screen/shopping_cart_done_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyInAppBrowser extends InAppBrowser {
  final String paymentUrl;

  MyInAppBrowser(
      {required this.paymentUrl,
      int? windowId,
      UnmodifiableListView<UserScript>? initialUserScripts})
      : super(windowId: windowId, initialUserScripts: initialUserScripts);

  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {
    _redirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    print("\n\nStopped: $url\n\n");
    _redirect(url.toString());
  }

  @override
  Future<PermissionResponse> onPermissionRequest(request) async {
    return PermissionResponse(
        resources: request.resources, action: PermissionResponseAction.GRANT);
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    print("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  void onMainWindowWillClose() {
    close();
  }

  bool _canRedirect = true;

  void _redirect(String url) {
    log(url.toString());
    log(url.contains('https://api.lahza.io/close').toString() + " Check");
    log(paymentUrl + " Check");
    if (url.contains('https://api.lahza.io/close')) {
      _redirect(paymentUrl);
    }
    // if(_canRedirect) {
    //   bool _isSuccess = url.contains('success') && url.contains(AppConstants.BASE_URL);
    //   bool _isFailed = url.contains('fail') && url.contains(AppConstants.BASE_URL);
    //   bool _isCancel = url.contains('cancel') && url.contains(AppConstants.BASE_URL);
    //   if (_isSuccess || _isFailed || _isCancel) {
    //     _canRedirect = false;
    //     close();
    //   }
    //   // if (_isSuccess) {
    //   //   Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success', orderAmount));
    //   // } else if (_isFailed || _isCancel) {
    //   //   Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'fail', orderAmount));
    //   // }
    // }
  }
}

class PaymentView extends StatefulWidget {
  final String url;

  const PaymentView({super.key, required this.url});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;

  @override
  Widget build(BuildContext context) {
    log(widget.url.toString());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset('assets/images/logo.png',
            color: Colors.white, width: 133.48, height: 23.57),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(widget.url.toString()),
        ),
        onWebViewCreated: (controller) async {
          webViewController = controller;
        },
        onLoadStart: (controller, url) async {

          if (url
              .toString()
              .contains('callback')) {
            await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ShoppingCartDoneView()));
          }
        },
        initialSettings: InAppWebViewSettings(
            javaScriptCanOpenWindowsAutomatically: true,
            supportMultipleWindows: true),
        onCreateWindow: (webViewController, request) async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: InAppWebView(
                      windowId: request.windowId,
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(),
                      ),
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) async {
                        if (url
                            .toString()
                            .contains('https://api.lahza.io/close')) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                );
              });
          return true;
        },
      ),
    );
  }
}
