import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../services/savefile.dart';

bool refresh=false;

class imageViewer extends StatefulWidget {

  final Uint8List imagefile;
  final String mobile;
  final bool download;
  // final Function callback;
  const imageViewer({super.key,required this.imagefile,required this.mobile,required this.download});

  @override
  State<imageViewer> createState() => _imageViewerState();
}

class _imageViewerState extends State<imageViewer> {



  @override
  Widget build(BuildContext context) {

    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    // print(widget.imagefile.toString());

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        children: [
          Container(
            width: w,
            height: h,
            color: Colors.black,
            child: Center(
              child: SizedBox(
                width: w-50,
                height: h-50,
                child: PhotoView(
                  imageProvider: Image.memory(widget.imagefile).image,
                ),
              ),
            ),
          ),
          SafeArea(
              child:Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: w,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.download?ElevatedButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                          onPressed: ()async{

                            setState(() {
                              refresh=true;
                            });
                            String status = await savefile().downloadImage("${widget.mobile}-${DateTime.now().millisecond}.png" , widget.imagefile);
                            showMessage(status);
                            setState(() {
                              refresh=false;
                            });
                          }, child: const Text("Download",style: TextStyle(color: Colors.white),)):const SizedBox(),
                      widget.download?const SizedBox(width: 10,):const SizedBox(),
                      ElevatedButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                          onPressed: (){
                            // widget.callback();
                            Navigator.pop(context);
                          }, child: const Text("Close",style: TextStyle(color: Colors.white),))
                    ],
                  ),
                ),
              )
          ),
          refresh?Container(
            width: w,
            height: h,
            color: Colors.black.withValues(alpha: .4),
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white
                ),
                child: const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              ),

          ):const SizedBox(),
        ],
      ),
    );
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

}
