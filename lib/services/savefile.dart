
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
// import 'dart:html' as html;

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
      filePath = '/storage/emulated/0/Download/$fileName';
      // print(filePath);
      file = File(filePath);
      await file.writeAsString(data).whenComplete((){
        status = "File has been downloaded";
      });
    } else if (Platform.isIOS) {
      directoryPath = (await getApplicationDocumentsDirectory()).path;
      filePath='$directoryPath/$fileName';
      file = File(filePath);
      await file.writeAsString(data).whenComplete((){
        status = "File has been downloaded";
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
      filePath = '/storage/emulated/0/Download/$fileName';
      file = File(filePath);
      await file.writeAsBytes(data).whenComplete((){
        status = "File downloaded to InternalStorage/downloads";
      });

    } else if (Platform.isIOS) {
      directoryPath = (await getApplicationDocumentsDirectory()).path;
      filePath='$directoryPath/$fileName';
      file = File(filePath);
      await file.writeAsBytes(data).whenComplete((){
        status = "File downloaded to InternalStorage/downloads";
      });
    }
    else {
      print("unsupported operating system");
    }

    return status;

  }

}