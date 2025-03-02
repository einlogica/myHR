import 'package:flutter/material.dart';
import 'package:einlogica_hr/Models/attendanceModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

import '../../Widgets/loadingWidget.dart';

class regularizePage extends StatefulWidget {

  final userModel currentUser;
  final Function callback;
  const regularizePage({super.key, required this.currentUser,required this.callback});

  @override
  State<regularizePage> createState() => _regularizePageState();
}

class _regularizePageState extends State<regularizePage> {

  var w=0.00,h=0.00,t=0.00;
  // TextEditingController _commentsCtrl= TextEditingController();
  List<attendanceModel> regularizeList = [];
  bool _loading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData()async{
    regularizeList =  await apiServices().getRegularization(widget.currentUser.Mobile);
    // print(regularizeList);
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
                                child: Center(child: Icon(Icons.arrow_back,size: 20,color: Colors.white,)),
                              ),
                            ),
                            const Text("Attendance Regularization",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
                    child:regularizeList.isEmpty?const Center(child: Text("Nothing to display"),):ListView.builder(
                        padding: EdgeInsets.only(bottom: 50),
                        itemCount: regularizeList.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: w-50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                                color: Colors.white,
                              ),
                              child: ListTile(
                                onTap: (){

                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      title: const Text("Regularization approval"),
                                      // content: const Text("Are you sure to send regularize request?"),
                                      content: SizedBox(width:w-50,child: const Text("Are you sure to approve regularization")),
                                      actions: <Widget>[
                                        SizedBox(
                                          width:w-20,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                onPressed: () async{

                                                  String status = await apiServices().approveRegularization(regularizeList[index].Mobile,regularizeList[index].attDate,"Approved");
                                                  showMessage(status);
                                                  fetchData();
                                                  widget.callback();
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: Container(
                                                  width: w/4,
                                                  // color: AppColors.buttonColorDark,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: AppColors.buttonColorDark,
                                                  ),
                                                  padding: const EdgeInsets.all(14),
                                                  child: const Center(child: Text("Regularize",style: TextStyle(color: Colors.white),)),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async{
                                                  String status = await apiServices().approveRegularization(regularizeList[index].Mobile,regularizeList[index].attDate,"Rejected");
                                                  showMessage(status);
                                                  fetchData();
                                                  widget.callback();
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: Container(
                                                  width:w/4,
                                                  // color: AppColors.buttonColorDark,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: AppColors.buttonColorDark,
                                                  ),
                                                  padding: const EdgeInsets.all(14),
                                                  child: const Center(child: Text("Reject",style: TextStyle(color: Colors.white))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Center(
                                          child: TextButton(
                                            onPressed: () async{
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Container(
                                              width:w/2,
                                              // color: AppColors.buttonColorDark,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: AppColors.buttonColorDark,
                                              ),
                                              padding: const EdgeInsets.all(14),
                                              child: const Center(child: Text("Close",style: TextStyle(color: Colors.white))),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );


                                },
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(regularizeList[index].Name,style: const TextStyle(fontWeight: FontWeight.bold),),
                                    Text(regularizeList[index].attDate,style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Check In : ${regularizeList[index].attTime}"),
                                    Text("Check Out : ${regularizeList[index].outTime}"),
                                    Text(regularizeList[index].comments),
                                  ],
                                ),
                                leading: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Center(child: Icon(Icons.person),),
                                ),
                                // trailing: const SizedBox(
                                //   width: 100,
                                //   // height: 50,
                                //   // color: AppColors.boxColor,
                                //   child: Padding(
                                //     padding: EdgeInsets.all(8.0),
                                //     child: Center()
                                //   ),
                                // ),
                              ),
                            ),
                          );
                        })
                ),

              ],
            ),
          ),
          _loading?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }


  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

}

