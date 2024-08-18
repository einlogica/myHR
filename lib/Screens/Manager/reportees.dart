import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Models/reporteeModel.dart';
import '../../Models/userModel.dart';
import '../../Widgets/loadingWidget.dart';
import '../../services/apiServices.dart';
import '../../style/colors.dart';
import '../profilePage.dart';

class reporteesPage extends StatefulWidget {

  // final List<reporteeModel> reportees;
  final userModel currentUser;
  const reporteesPage({super.key,required this.currentUser});

  @override
  State<reporteesPage> createState() => _reporteesPageState();
}

class _reporteesPageState extends State<reporteesPage> {

  List<reporteeModel> employeeList = [];
  var w=0.00,h=0.00,t=0.00;
  bool _loading=false;
  DateTime? _selected=DateTime.now();
  String formattedDate="";

  @override
  void initState() {
    // TODO: implement initState
    // employeeList.clear();
    // employeeList=widget.reportees;
    fetchEmployeeData();
    super.initState();
  }

  fetchEmployeeData()async{
    // employeeList
    formattedDate = DateFormat('yyyy-MM-dd').format(_selected!);
    employeeList.clear();
    if(widget.currentUser.Permission=="Admin"){
      employeeList = await apiServices().getReportees(widget.currentUser.Mobile,"ALL",formattedDate);
      // inactiveEmployeeList = await apiServices().getReportees(widget.currentUser.Mobile,"INACTIVE");
    }
    else{
      employeeList = await apiServices().getReportees(widget.currentUser.Mobile,"MANAGER",formattedDate);
    }
    // await fetchSummary();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
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
                            const Text("Reportees",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            InkWell(
                              onTap: ()async{
                                setState(() {
                                  _loading=true;
                                });

                                _selected = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(), //get today's date
                                    firstDate:DateTime(2022), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2030)
                                );
                                // print(_selected);
                                if(_selected!=null){
                                  await fetchEmployeeData();
                                }
                                else{
                                  setState(() {
                                    _loading=false;
                                  });
                                }

                              },
                              child: const SizedBox(
                                width: 60,
                                height: 40,
                                child: Icon(Icons.calendar_month,color: Colors.white,),
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Expanded(child: reportees()),

              ],
            ),

            _loading?loadingWidget():const SizedBox(),
          ],
        ),
      ),
    );
  }


  Widget reportees(){
    return Center(
      child: Column(
        children: [
          // Container(
          //   width: w-20,
          //   height: 30,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(5),
          //     color: AppColors.themeStop,
          //   ),
          //   child: const Center(child: Text("Reportees",style: TextStyle(fontWeight: FontWeight.bold),)),
          // ),
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
                          color: employeeList[index].Status=='ACTIVE'?Colors.white:Colors.red.shade100,
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

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

}
