import 'package:einlogica_hr/Models/locationModel.dart';
import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:flutter/material.dart';

import '../../Models/userModel.dart';
import '../../Widgets/loadingWidget.dart';
import '../../style/colors.dart';

class locationsPage extends StatefulWidget {

  final userModel currentUser;
  const locationsPage({super.key,required this.currentUser});

  @override
  State<locationsPage> createState() => _locationsPageState();
}

class _locationsPageState extends State<locationsPage> {

  var w=0.00,h=0.00,t=0.00;
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _latCtrl = TextEditingController();
  final TextEditingController _longCtrl = TextEditingController();
  final TextEditingController _rangeCtrl = TextEditingController();
  List<locationModel> locationList = [];

  bool _loading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchList();
  }


  Future fetchList()async{

    locationList=await apiServices().getDefaultLocations();
    // print(locationList.toString());
    _loading=false;
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton:FloatingActionButton(
        backgroundColor: AppColors.buttonColorDark,
        onPressed: (){
          showDialogBox();
        },
        child: const Icon(Icons.add_circle_outline,color: Colors.white,),
      ),
      body: SizedBox(
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
                            const Text("Location Settings",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
                  child: locationList.isNotEmpty?SizedBox(

                    child: ListView.builder(
                      itemCount: locationList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: w-20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .3),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child:  ListTile(
                                title: Text("${locationList[index].locationName} (${locationList[index].range}m)"),
                                leading: const Icon(Icons.location_on),
                                subtitle: Text("${locationList[index].posLat},${locationList[index].posLong}"),
                                trailing: InkWell(
                                  onTap: (){
                                    showMessage("Long press to delete location");
                                  },
                                  onLongPress: ()async{
                                    String status = await apiServices().deleteLocations(widget.currentUser.Mobile,locationList[index].ID);
                                    showMessage(status);
                                    if(status=="Success"){
                                      fetchList();
                                    }
                                  },
                                  child: const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Icon(Icons.delete)
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ):const Center(child: Text("Nothing to display"),),
                ),



              ],
            ),

            _loading?loadingWidget():const SizedBox(),
          ],
        ),
      ),
    );
  }

  Future showDialogBox(){
    return showDialog(
      context: context,
      builder: (ctx) => Container(
        width: w-20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: AlertDialog(
          // backgroundColor: AppColors.boxColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text("Add Holiday"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FieldArea(title: "Location", ctrl: _nameCtrl, type: TextInputType.text, len: 20),
                FieldArea(title: "Latitude", ctrl: _latCtrl, type: TextInputType.numberWithOptions(), len: 8),
                FieldArea(title: "Longitude", ctrl: _longCtrl, type: TextInputType.numberWithOptions(), len: 8),
                FieldArea(title: "Range (Meter)", ctrl: _rangeCtrl, type: TextInputType.numberWithOptions(), len: 3),
            
                const SizedBox(height: 20,),
            
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async{

                String status = await apiServices().saveLocations(widget.currentUser.Mobile, _nameCtrl.text, _latCtrl.text, _longCtrl.text, _rangeCtrl.text);
                clearFields();
                Navigator.of(ctx).pop();
                showMessage(status);
                if(status=="Success"){
                  clearFields();
                  fetchList();
                }


              },
              child: Container(
                color: AppColors.buttonColor,
                padding: const EdgeInsets.all(14),
                child: const Text("Save",style: TextStyle(color: Colors.white),),
              ),
            ),
            TextButton(
              onPressed: () {
                clearFields();
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

  void clearFields(){
    _nameCtrl.clear();
    _latCtrl.clear();
    _longCtrl.clear();
    _rangeCtrl.clear();
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }
}
