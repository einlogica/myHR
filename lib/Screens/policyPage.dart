
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/policyModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

class policyPage extends StatefulWidget {

  final String permission;
  const policyPage({super.key, required this.permission});

  @override
  State<policyPage> createState() => _policyPageState();
}

class _policyPageState extends State<policyPage> {

  var w=0.00,h=0.00,t=0.00;
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _fileCtrl = TextEditingController();
  File? _selectedFile;
  bool pdfSelected=false;
  List<policyModel> policyList=[];
  bool _loading=true;
  var pdfString;

  @override
  void dispose() {
    // TODO: implement dispose
    _titleCtrl.dispose();
    _fileCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData()async{
    policyList = await apiServices().getPolicy();
    // print(policyList);
    setState(() {
      _loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;



    return Scaffold(
        floatingActionButton:widget.permission=='Admin'?FloatingActionButton(
        backgroundColor: AppColors.buttonColorDark,
        onPressed: (){
          showDialogBox();
        },
        child: const Icon(Icons.add_circle_outline,color: Colors.white,),
      ):const SizedBox(),
      body: Stack(
        children: [
          SizedBox(
            width: w,
            height: h,
            child: Column(
              children: [
                Container(
                  height: 80+t,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.themeStart,AppColors.themeStop]
                    ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: t,),
                      SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap:(){
                                // widget.callback();
                                Navigator.pop(context);
                              },
                              child: const SizedBox(
                                width: 60,
                                height: 40,

                                // color: Colors.grey,
                                child: Center(child: Icon(Icons.arrow_back,size: 20,color: Colors.white,)),
                              ),
                            ),
                            const Text("Policy Documents",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            const SizedBox(
                              width: 60,
                              height: 40,
                              // child: Icon(Icons.calendar_month,color: Colors.white,),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: policyList.isNotEmpty?ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: policyList.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: w-50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              title: Text(policyList[index].title),
                              leading: const Icon(Icons.policy),
                              trailing: SizedBox(
                                width: 100,
                                // color: Colors.green,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: ()async{
                                        savePDF(policyList[index].fileName,policyList[index].title);
                                      },
                                      child: const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(Icons.download),
                                      ),
                                    ),
                                    InkWell(
                                      onLongPress: ()async{
                                        // print(policyList[index].id);
                                        await apiServices().deletePolicy(policyList[index].id);
                                        // print(status);
                                        fetchData();
                                      },
                                      child: const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(Icons.delete),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }):const Center(child: SizedBox( child: Text("Nothing to display"),)),
                )

              ],
            ),
          ),
          _loading?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }



  Future showDialogBox(){
    return showDialog(
      context: context,
      builder: (ctx) => Container(
        width: w-50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: AlertDialog(
          // backgroundColor: AppColors.boxColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text("Upload policy"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FieldArea("Title",_titleCtrl,TextInputType.text),
              SizedBox(
                width: w-20,
                height: 50,
                // color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: w*.2,
                      // color: Colors.green,
                      child: const Text("PDF File :",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                        width: w*.3,
                        child: TextFormField(

                          enabled: false,
                          controller: _fileCtrl,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.password),
                            // hintText: "Pin",

                            filled: true,
                            fillColor: Colors.white,
                            enabled: true,
                            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        )
                    ),
                    SizedBox(
                        width: w*.2,
                        child: ElevatedButton(
                          onPressed: ()async{
                            FilePickerResult? result = await FilePicker.platform.pickFiles();

                            if (result != null) {
                              setState(() {

                                pdfSelected=true;
                                _selectedFile = File(result.files.single.path!);
                                _fileCtrl.text=path.basename(_selectedFile!.path);
                              });
                            }
                          },
                          child: const Text("Browse"),
                        )
                      ),
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                Navigator.of(ctx).pop();
                if(_titleCtrl.text!="" && _fileCtrl.text!=""){

                  setState(() {
                    _loading=true;
                  });
                  await apiServices().uploadPolicy(_selectedFile, _titleCtrl.text);

                  fetchData();
                }

                _titleCtrl.clear();
                _fileCtrl.clear();
                pdfSelected=false;

              },
              child: Container(
                color: AppColors.buttonColor,
                padding: const EdgeInsets.all(14),
                child: const Text("Confirm",style: TextStyle(color: Colors.white),),
              ),
            ),
            TextButton(
              onPressed: () {
                _titleCtrl.clear();
                _fileCtrl.clear();
                pdfSelected=false;
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: AppColors.buttonColor,
                padding: const EdgeInsets.all(14),
                child: const Text("Cancel",style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget FieldArea(String title,TextEditingController ctrl,TextInputType type){
    return SizedBox(
      width: w-20,
      height: 50,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: w*.2,
            // color: Colors.green,
            child: Text("$title :",style: const TextStyle(fontWeight: FontWeight.bold),),
          ),
          SizedBox(
              width: w*.4,
              child: TextFormField(
                keyboardType: type,
                enabled: true,
                controller: ctrl,
                maxLength: 30,
                decoration: InputDecoration(
                  // icon: Icon(Icons.password),
                  // hintText: "Pin",
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  enabled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )
          ),
        ],
      ),
    );
  }



  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }


  savePDF(String fileName,String policy)async{
    setState(() {
      _loading=true;
    });
    pdfString = await apiServices().getBill(fileName, "Policy");

    // var decodedBytes = base64Decode(pdfString);

    if(Platform.isAndroid){
      final filePath = '/storage/emulated/0/Download/Policy-$policy-${DateFormat('yyyyMMddss').format(DateTime.now())}.pdf';
      final file = File(filePath);
      // final file = File('/storage/emulated/0/Download/$item-File.csv');
      await file.writeAsBytes(pdfString).whenComplete((){
        showDialog(context: context,
            builder: (BuildContext context)=>AlertDialog(
              title: const Text("Success"),
              content: const Text("Policy saved to downloads folder"),
              actions: [
                TextButton(
                  onPressed: () async{

                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(14),
                    child: const Text("OK",style: TextStyle(color: Colors.black),),
                  ),
                ),
              ],
            ));
      });
    }

    setState(() {
      _loading=false;
    });

  }


}

