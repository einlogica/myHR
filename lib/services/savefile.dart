
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
// import 'dart:html' as html;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class savefile{

  Future<String> downloadCSVFile(String fileName, String data)async{
    print("Executing download file method");
    var filePath;
    var file;
    String status="";

    String directoryPath;
    // if(kIsWeb){
    //   print("Detected web activity");
    //   final blob = html.Blob([data]);
    //   final url = html.Url.createObjectUrlFromBlob(blob);
    //   final anchor = html.AnchorElement(href: url)
    //     ..setAttribute("download", fileName)
    //     ..click();
    //   html.Url.revokeObjectUrl(url);
    //   status = "Success";
    // }
    // else
    if (Platform.isAndroid) {
      // final directory = await getExternalStorageDirectory();
      // filePath = '$directory/$fileName';
      filePath = '/storage/emulated/0/Download/$fileName';
      // print(filePath);
      file = File(filePath);
      await file.writeAsString(data).whenComplete((){
        status = "File has been downloaded";
        downloadAndNotify(filePath);
      });
    } else if (Platform.isIOS) {
      directoryPath = (await getApplicationDocumentsDirectory()).path;
      filePath='$directoryPath/$fileName';
      file = File(filePath);
      await file.writeAsString(data).whenComplete((){
        status = "File has been downloaded";
        downloadAndNotify(filePath);
      });
    }
    else {
      print("unsupported operating system");
    }

    return status;

  }



  Future<String> downloadImage(String fileName, Uint8List data)async{
    print("Executing download file method");
    var filePath;
    var file;
    String status="";

    String directoryPath;

    // if(kIsWeb){
    //   print("Detected web activity");
    //   final blob = html.Blob([data]);
    //   final url = html.Url.createObjectUrlFromBlob(blob);
    //   final anchor = html.AnchorElement(href: url)
    //     ..setAttribute("download", fileName)
    //     ..click();
    //   html.Url.revokeObjectUrl(url);
    //   status = "Success";
    // }
    // else
    if (Platform.isAndroid) {
      // final directory = await getExternalStorageDirectory();
      // filePath = '$directory/$fileName';
      filePath = '/storage/emulated/0/Download/$fileName';
      file = File(filePath);
      await file.writeAsBytes(data).whenComplete((){
        status = "File downloaded to InternalStorage/downloads";
        downloadAndNotify(filePath);
      });

    } else if (Platform.isIOS) {
      directoryPath = (await getApplicationDocumentsDirectory()).path;
      filePath='$directoryPath/$fileName';
      file = File(filePath);
      await file.writeAsBytes(data).whenComplete((){
        status = "File downloaded to InternalStorage/downloads";
        downloadAndNotify(filePath);
      });
    }
    else {
      print("unsupported operating system");
    }

    return status;

  }


  Future<void> downloadAndNotify(String filePath) async {
    print("Showing notification");
    // final response = await HttpClient().getUrl(Uri.parse(url));
    // final bytes = await response.close().then((r) => r.fold<List<int>>([], (b, data) => b..addAll(data)));
    //
    // final directory = await getApplicationDocumentsDirectory();
    // final filePath = '${directory.path}/downloaded_file.ext';
    // final file = File(filePath);
    // await file.writeAsBytes(bytes);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'Tap to open the file',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

}