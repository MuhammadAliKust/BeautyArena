import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:beauty_arena_app/application/search_providers.dart';
import 'package:beauty_arena_app/presentation/views/splash_screen/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'application/discount_provider.dart';
import 'firebase_options.dart';
import 'application/app_state.dart';
import 'application/bottom_index.dart';
import 'application/cart_provider.dart';
import 'application/errorStrings.dart';
import 'application/remote_config_provider.dart';
import 'application/user_provider.dart';
import 'presentation/views/cart_screen/cart_view.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  await createNotification(
    title: message.data['title'].toString(),
    body: message.data['body'].toString(),
  );
}

Future<void> createNotification(
    {required String title, required String body}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 1, channelKey: 'basic_channel', title: title, body: body),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance.requestPermission();
  await AwesomeNotifications().initialize(
    'resource://drawable/res_notification_app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        channelDescription: 'Test',
      ),
    ],
  );
  ErrorWidget.builder = (FlutterErrorDetails details) => Container(
    child: Text(details.summary.value.toString()),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ErrorString()),
      ChangeNotifierProvider(create: (_) => RemoteConfigProvider()),
      ChangeNotifierProvider(create: (_) => BottomIndexProvider()),
      ChangeNotifierProvider(create: (_) => SearchProviders()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => DiscountProvider()),
      ChangeNotifierProvider(create: (_) => AppState()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getPermission()async{
    await FirebaseMessaging.instance.requestPermission();
  }
  @override
  void initState() {
    getPermission();
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content:
                  const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      log("Listen");
      if(Platform.isAndroid){
        print(message);
        createNotification(
          title: message.data['title'].toString(),
          body: message.data['body'].toString(),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      createNotification(
        title: message.data['title'].toString(),
        body: message.data['body'].toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Beauty Arena',

      theme: ThemeData(
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),

        ),
        scaffoldBackgroundColor: Colors.white,
useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: SplashView(),
    );
  }
}
