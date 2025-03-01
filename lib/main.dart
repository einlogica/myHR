import 'package:flutter/material.dart';
import 'package:einlogica_hr/Screens/login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:open_filex/open_filex.dart';
import 'firebase_options.dart';

// Declare the plugin globally
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  // print("=============");
  // print(Firebase.apps.toString());

  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase already initialized: $e");
  }

  // Android initialization
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS initialization
  final DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings();

  // Combine initialization settings
  final InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async{
      // print("response received");
      String? filePath = response.payload;
      if (filePath != null && filePath.isNotEmpty) {
        await OpenFilex.open(filePath);
        // print("$filePath");
        // final result = await OpenFilex.open(filePath);
        // print('OpenFile result: ${result.message}');
      }
    },
  );

  // await Upgrader.clearSavedSettings();
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

// Handle when a notification is received while the app is in the foreground on iOS
void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // Here, you can show a dialog or handle the notification in another way
  if (payload != null && payload.isNotEmpty) {
    OpenFilex.open(payload);
  }
}

// TODO: Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // if (kDebugMode) {
  //   print("Handling a background message: ${message.messageId}");
  //   print('Message data: ${message.data}');
  //   print('Message notification: ${message.notification?.title}');
  //   print('Message notification: ${message.notification?.body}');
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // theme: ThemeData(fontFamily: 'Mitr'),
      // home: Dashboard(),
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(Colors.blue),
          thickness: WidgetStateProperty.all(7.0),
          radius: const Radius.circular(10),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(

          data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1)),
          child: child!,
        );
      },
      home: login(),
      // home: UpgradeAlert(
      //   child: login(),
      // ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}


