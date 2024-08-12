import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/activityModel.dart';
import 'package:einlogica_hr/Models/attendanceModel.dart';
import 'package:einlogica_hr/Models/reporteeModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Screens/Manager/claimApproval.dart';
import 'package:einlogica_hr/Screens/Manager/leaveApproval.dart';
import 'package:einlogica_hr/Screens/Manager/regularizePage.dart';
import 'package:einlogica_hr/Screens/profilePage.dart';
import 'package:einlogica_hr/Screens/timesheetPage.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

class dashboard extends StatefulWidget {


  final userModel currentUser;

  dashboard({super.key,required this.currentUser});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {

  var w=0.00,h=0.00,t=0.00;
  List<reporteeModel> employeeList = [];
  List<activityModel> actList =[];
  List<attendanceModel> regularizeList = [];
  TextEditingController commentsCtrl = TextEditingController();
  String formattedDate="";
  bool approved = false;
  bool imageDownloaded = false;
  bool refresh = true;
  var data;
  List summary = ["","","",""];
  bool loadSummary=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchEmployeeData();
    fetchSummary();

  }



  fetchEmployeeData()async{
    // employeeList
    formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    employeeList.clear();
    if(widget.currentUser.Permission=="Admin"){
      employeeList = await apiServices().getReportees(widget.currentUser.Mobile,"ALL");
    }
    else{
      employeeList = await apiServices().getReportees(widget.currentUser.Mobile,"MANAGER");
    }
    // await fetchSummary();
    setState(() {
      refresh = false;
    });
  }

  fetchSummary()async{
    data = jsonDecode(await apiServices().getDashboardSummary(widget.currentUser.Mobile, widget.currentUser.Permission));
    summary[0]=data['Regularization'].toString();
    summary[1]=data['Activity'].toString();
    summary[2]=data['Leave'].toString();
    summary[3]=data['Expense'].toString();
    // print(summary[0]);
    setState(() {
      loadSummary = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
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
                                child: Center(child: Icon(Icons.arrow_back,size: 20,color: Colors.white,)),
                              ),
                            ),
                            const Text("Manager Dashboard",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return regularizePage(currentUser: widget.currentUser,callback: fetchSummary,);
                        }));
                      },
                      child: Container(
                        width: w/2-20,
                        height: 50,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue.shade300,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Regularization",style: TextStyle(fontSize: 14,color: AppColors.buttonColorDark),),
                              !loadSummary?SizedBox(width: 10,height: 10,child: CircularProgressIndicator()):Text(summary[0],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.buttonColorDark),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        // setState(() {
                        //   _selected="Activity";
                        // });
                        if(widget.currentUser.Permission=="Admin"){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return timesheetPage(mobile: widget.currentUser.Mobile, name: widget.currentUser.Name,permission: "ALL",);
                          }));
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return timesheetPage(mobile: widget.currentUser.Mobile, name: widget.currentUser.Name,permission: "MAN",);
                          }));
                        }

                      },
                      child: Container(
                        width: w/2-20,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue.shade300,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Activities",style: TextStyle(fontSize: 14,color: AppColors.buttonColorDark),),
                              !loadSummary?SizedBox(width: 10,height: 10,child: CircularProgressIndicator()):Text(summary[1],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.buttonColorDark))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return leaveApprovalPage(currentUser: widget.currentUser,callback: fetchSummary,);
                        }));
                      },
                      child: Container(
                        width: w/2-20,
                        height: 50,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue.shade300,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Leave Requests",style: TextStyle(fontSize: 14,color: AppColors.buttonColorDark),),
                              !loadSummary?SizedBox(width: 10,height: 10,child: CircularProgressIndicator()):Text(summary[2],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.buttonColorDark),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        // setState(() {
                        //   _selected="Claim";
                        // });
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return claimApprovalPage(currentUser: widget.currentUser,callback: fetchSummary,);
                        }));
                      },
                      child: Container(
                        width: w/2-20,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue.shade300,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Claim Requests",style: TextStyle(fontSize: 14,color: AppColors.buttonColorDark),),
                              !loadSummary?SizedBox(width: 10,height: 10,child: CircularProgressIndicator()):Text(summary[3],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.buttonColorDark))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: Container(
                    child: reportees(),

                  ),
                )
              ],
            ),
          ),
          refresh?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }


  Widget reportees(){
    return Center(
      child: Column(
        children: [
          Container(
            width: w-20,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.themeStop,
            ),
            child: const Center(child: Text("Reportees",style: TextStyle(fontWeight: FontWeight.bold),)),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: SizedBox(
              width: w-20,

              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 50),
                  itemCount: employeeList.length,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // width: w-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                        child: ListTile(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return profilePage(permission: widget.currentUser.Permission,mobile: employeeList[index].Mobile,callback: (){},HLP: widget.currentUser.Permission,Image: '${employeeList[index].Mobile}.png',);
                            }));
                          },
                          title: Text(employeeList[index].Name,style: const TextStyle(color: AppColors.buttonColorDark,fontWeight: FontWeight.bold),),
                          subtitle: Row(
                            children: [
                              Text(employeeList[index].Position),
                              Spacer(),
                              Text(employeeList[index].Location,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: employeeList[index].Location=="Absent" || employeeList[index].Location=="Leave"?Colors.red:Colors.green),),
                            ],
                          ),
                          leading: const SizedBox(
                              width: 20,
                              height: 40,
                              child: Center(child: Icon(Icons.person,size: 25,color: AppColors.buttonColor))),
                          trailing: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(child: Icon(Icons.arrow_forward_ios_rounded,color: AppColors.buttonColorDark,)),
                          )
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

}