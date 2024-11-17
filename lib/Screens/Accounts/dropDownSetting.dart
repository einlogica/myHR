import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:flutter/material.dart';

import '../../Models/userModel.dart';
import '../../Widgets/loadingWidget.dart';
import '../../style/colors.dart';

class dropDownSettingsPage extends StatefulWidget {

  final userModel currentUser;
  const dropDownSettingsPage({super.key,required this.currentUser});

  @override
  State<dropDownSettingsPage> createState() => _dropDownSettingsPageState();
}

class _dropDownSettingsPageState extends State<dropDownSettingsPage> {

  var w=0.00,h=0.00,t=0.00;
  final TextEditingController _addCtrl = TextEditingController();
  String selectedOption = "";
  bool optionSelected=false;
  bool _loading=false;
  List<String> selectedList = [];
  List<String> settings = [];
  bool changeFlag = false;

  @override
  void initState() {
    // TODO: implement initState
    if(widget.currentUser.Permission=="Admin"){
      settings = ["Department","Position","Bank","Activity","Customer","Vehicle","Site Name"];
    }
    else{
      settings = ["Department","Position","Activity","Customer","Vehicle","Site Name"];
    }
    super.initState();
  }

  Future fetchList(String selectedOption)async{
    // print(selectedOption);
    selectedList.clear();
    selectedList=await apiServices().fetchSettingsList(selectedOption,widget.currentUser.Mobile);
    optionSelected=true;
  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: w,
        height: h,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 60+t,
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
                        height: 60,
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
                            const Text("Configure Drop Downs",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            const SizedBox(
                              width: 60,
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    // width: w,
                    // height: h-80-t,
                    child: ListView.builder(
                        itemCount: settings.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: ()async{
                                setState((){
                                  _loading=true;
                                });
                                selectedOption=settings[index];
                                await fetchList(selectedOption);
                                setState(() {
                                  _loading=false;
                                });
                              },
                              child: Container(
                                width: w-20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child:  ListTile(
                                  title: Text("${settings[index]}"),
                                  leading: Icon(Icons.list),
                                  trailing: SizedBox(
                                      width: 30,
                                      child: Icon(Icons.arrow_forward_ios_rounded)
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),

              ],
            ),
            optionSelected?SafeArea(
              child: Container(
                // width: w,
                // height: h-80-t,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                        width: w,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppColors.themeStart,AppColors.themeStop]
                          ),
                        ),

                        child: Center(child: Text("${selectedOption}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),))
                    ),
                    Expanded(
                      child: SizedBox(
                        child: ListView.builder(
                            itemCount: selectedList.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context,index){
                              return Container(
                                width: w-20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,

                                ),
                                child:  ListTile(
                                  title: Text("${selectedList[index]}"),
                                  leading: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Center(child: Text("${index+1}",style: TextStyle(fontSize: 14),)),
                                  ),
                                  trailing: InkWell(
                                    onTap: (){
                                      changeFlag=true;
                                      selectedList.remove(selectedList[index]);
                                      setState(() {

                                      });
                                    },
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(Icons.delete)
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    // Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width:w-w/3,
                            child: FieldArea(title: "${selectedOption}", ctrl: _addCtrl, type: TextInputType.text, len: 30)),
                        SizedBox(
                          width: w/4,
                          height: 60,
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue),foregroundColor: WidgetStateProperty.all(Colors.white)),
                            onPressed: (){
                              selectedList.add(_addCtrl.text.trim());
                              _addCtrl.clear();
                              changeFlag=true;
                              setState(() {

                              });
                            },
                            child: Text("Add"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: w,
                      // height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width:w/2-5,
                            height: 60,
                            color: Colors.blue.shade100,
                            child: TextButton(onPressed: ()async{
                              // if(selectedList.isEmpty){
                              //   return;
                              // }
                              setState(() {
                                _loading=true;
                              });
                              String status = await apiServices().updateSettingsList(selectedList, selectedOption,widget.currentUser.Mobile);
                              if(status=="Success"){
                                optionSelected=false;
                              }
                              showMessage(status);
                              setState(() {
                                _loading=false;
                              });

                            }, child: const Text("Save")),
                          ),

                          Container(
                            width: w/2-5,
                            height: 60,
                            color: Colors.blue.shade100,
                            child: TextButton(onPressed: (){
                              if(changeFlag){
                                showDialogBox();
                              }
                              else{
                                setState(() {
                                  optionSelected=false;
                                });
                              }


                            }, child: const Text("Cancel")),
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ):SizedBox(),
            _loading?loadingWidget():const SizedBox(),
          ],
        ),
      ),
    );
  }


  Future showDialogBox(){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.all(8),
        insetPadding: EdgeInsets.all(8),
        // backgroundColor: AppColors.boxColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text("Unsaved changes!!"),
        content: SizedBox(
          width: w-50,
          child: const Text("Do you want to save the changes?")
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () async{
              // if(selectedList.isEmpty){
              //   return;
              // }
              Navigator.pop(context);
              changeFlag=false;
              setState(() {
                _loading=true;
              });
              String status = await apiServices().updateSettingsList(selectedList, selectedOption,widget.currentUser.Mobile);
              if(status=="Success"){
                optionSelected=false;
              }
              showMessage(status);
              setState(() {
                _loading=false;
              });

            },
            child: Container(
              color: AppColors.buttonColor,
              padding: const EdgeInsets.all(14),
              child: const Text("Yes",style: TextStyle(color: Colors.white),),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              changeFlag=false;
              setState(() {
                optionSelected=false;
              });
            },
            child: Container(
              color: AppColors.buttonColor,
              padding: const EdgeInsets.all(14),
              child: const Text("No",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }



  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }
}
