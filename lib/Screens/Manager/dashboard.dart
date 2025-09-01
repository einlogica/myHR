import 'dart:convert';
import 'package:einlogica_hr/Screens/Manager/reportees.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/activityModel.dart';
import 'package:einlogica_hr/Models/attendanceModel.dart';
import 'package:einlogica_hr/Models/reporteeModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Screens/Manager/claimApproval.dart';
import 'package:einlogica_hr/Screens/Manager/leaveApproval.dart';
import 'package:einlogica_hr/Screens/Manager/regularizePage.dart';
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
  List<reporteeModel> inactiveEmployeeList = [];
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
  String collectionTab='0';
  DateTime currDate = DateTime.now();
  List<Map<String, dynamic>> attendanceData = [];
  List<Map<String, dynamic>> fetchedAttendanceData = [];
  List<Map<String, dynamic>> expenseData = [];
  double employeeCount=0;
  double presentCount=0,absentCount=0,leaveCount=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchEmployeeData();
    fetchMonthlyData();
    fetchSummary();

  }

  fetchMonthlyData()async{
    //Attendance
    fetchedAttendanceData = await apiServices().getMonthlyAttendance(widget.currentUser.Mobile,currDate.month.toString(),currDate.year.toString());
    print(fetchedAttendanceData.length);
    if(fetchedAttendanceData.length>8){
      attendanceData=fetchedAttendanceData.sublist(fetchedAttendanceData.length-8,fetchedAttendanceData.length-1);
    }
    else{
      attendanceData=fetchedAttendanceData;
    }

    employeeCount=attendanceData[0]['Total'];
    // print(fetchedAttendanceData.last['Day']);
    if(fetchedAttendanceData.last['Day']==DateTime.now().day){
      presentCount=fetchedAttendanceData.last['PresentCount'];
      leaveCount=fetchedAttendanceData.last['LeaveCount'];
      absentCount=employeeCount-presentCount-leaveCount;
    }
    else{
      attendanceData=fetchedAttendanceData.sublist(fetchedAttendanceData.length-7,fetchedAttendanceData.length);
    }

    //Expense
    expenseData = await apiServices().getMonthlyExpense(widget.currentUser.Mobile,currDate.month.toString(),currDate.year.toString());
    // print(expenseData);

    setState(() {

    });

    // expenseData = await apiServices().getMonthlyExpense(widget.currentUser.Mobile,currDate.month.toString(),currDate.year.toString());
  }


  fetchEmployeeData()async{
    // employeeList
    formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    collectionTab = await apiServices().getSettings('CollectionTab');
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

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(height: 20,),
                      InkWell(
                        onTap: (){

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return reporteesPage(currentUser: widget.currentUser);
                          }));
                        },
                        child: Container(
                          width: w-20,
                          height: 80,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Reportees",style: TextStyle(fontSize: 18,color: AppColors.buttonColorDark,fontWeight: FontWeight.bold),),
                                !loadSummary?const SizedBox(width: 10,height: 18,child: CircularProgressIndicator()):Text(employeeCount.toStringAsFixed(0),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.buttonColorDark),),

                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
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
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Regularization",style: TextStyle(fontSize: 14,color: AppColors.buttonColorDark,fontWeight: FontWeight.bold),),
                                    !loadSummary?const SizedBox(width: 10,height: 10,child: CircularProgressIndicator()):Text(summary[0],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.buttonColorDark),),
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
                                  return timesheetPage(mobile: widget.currentUser.Mobile, name: widget.currentUser.Name,permission: "ALL",collection: collectionTab,callback: (){},);
                                }));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return timesheetPage(mobile: widget.currentUser.Mobile, name: widget.currentUser.Name,permission: "MAN",collection: collectionTab,callback: (){},);
                                }));
                              }

                            },
                            child: Container(
                              width: w/2-20,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Activities",style: TextStyle(fontSize: 14,color: AppColors.buttonColorDark,fontWeight: FontWeight.bold),),
                                    !loadSummary?const SizedBox(width: 10,height: 10,child: CircularProgressIndicator()):Text(summary[1],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.buttonColorDark))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20,),
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

                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(10),
                              //   color: Colors.lightBlue.shade300,
                              // ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Leave Requests",style: TextStyle(fontSize: 14,color: AppColors.buttonColorDark,fontWeight: FontWeight.bold),),
                                    !loadSummary?const SizedBox(width: 10,height: 10,child: CircularProgressIndicator()):Text(summary[2],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.buttonColorDark),)
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
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(10),
                              //   color: Colors.lightBlue.shade300,
                              // ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Claim Requests",style: TextStyle(fontSize: 14,color: AppColors.buttonColorDark,fontWeight: FontWeight.bold),),
                                    !loadSummary?const SizedBox(width: 10,height: 10,child: CircularProgressIndicator()):Text(summary[3],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.buttonColorDark))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Container(
                          width: w-10,
                          height: 30,
                          color: Colors.lightBlue.shade300,
                          child: const Center(child: Text("Summary",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))),
                      const SizedBox(height: 20,),
                      employeeCount>0?Column(
                        children: [

                          const Padding(
                            padding:  EdgeInsets.only(left: 20.0),
                            child: Align(alignment: Alignment.bottomLeft,child: Text("Today's Attendance",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo),)),
                          ),
                          SizedBox(
                            width: w-10,
                            height: 200,
                            child: (presentCount+leaveCount+absentCount==0)?const Center(child: Text("No Attendance yet")):pieChartWidget(),
                          ),
                          const SizedBox(height: 40,),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Align(alignment: Alignment.bottomLeft,child: Text("Weekly Attendance",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo))),
                          ),
                          SizedBox(
                            width: w-10,
                            height: 200,
                            child: monthlyChartWidget(),
                          ),
                          const SizedBox(height: 40,),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Align(alignment: Alignment.bottomLeft,child: Text("Employee Expense",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo))),
                          ),
                          SizedBox(
                            width: w-10,
                            // height: exp,
                            child: expenseTable(),
                          ),
                          const SizedBox(height: 60,),
                        ],
                      ):const Center(child:Text("Nothing to display"))



                    ],),
                  ),
                ),

              ],
            ),
          ),
          refresh?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }


  Widget pieChartWidget(){
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
            width: 80,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: _buildPieChartSections(),
                ),
              ),
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                legendWidget("Present", Colors.green),
                legendWidget("Absent", Colors.orange),
                legendWidget("Leave", Colors.red),

              ],
            ),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    // final total = presentCount + absentCount + leaveCount;
    return [
      PieChartSectionData(
        color: Colors.green,
        value: presentCount.toDouble(),
        title: '$presentCount',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: absentCount.toDouble(),
        title: '$absentCount',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: leaveCount.toDouble(),
        title: '$leaveCount',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }


  Widget monthlyChartWidget(){
    // print(employeeCount);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (employeeCount/10).ceil()*10,  // Adjust maxY based on your data range
          barTouchData: BarTouchData(enabled: true),
          // titlesData: FlTitlesData(
          //   leftTitles: AxisTitles(
          //     sideTitles: SideTitles(
          //       showTitles: true,
          //       getTitlesWidget: (value, _) {
          //         return Text(value.toInt().toString(), style: TextStyle(color: Colors.black, fontSize: 10));
          //       },
          //     ),
          //   ),
          //   bottomTitles: AxisTitles(
          //     sideTitles: SideTitles(
          //       showTitles: true,
          //       getTitlesWidget: (value, _) {
          //         return Text('Day ${value.toInt() + 1}', style: TextStyle(color: Colors.black, fontSize: 10));
          //       },
          //     ),
          //   ),
          // ),
          gridData: const FlGridData(show: false),

          borderData: FlBorderData(
            show: false,
            border: Border.all(color: Colors.black.withValues(alpha: .2), width: 1),
          ),
          barGroups: attendanceData.map((data) {
            return BarChartGroupData(
              x: data['Day'],
              barRods: [
                // BarChartRodData(toY: double.parse(data['LeaveCount'].toString()), color: Colors.blue, width: 15),
                // BarChartRodData(toY: double.parse(data['AbsentCount'].toString()), color: Colors.red, width: 15),
                // BarChartRodData(toY: double.parse(data['PresentCount'].toString()), color: Colors.green, width: 15),
                BarChartRodData(
                  borderRadius: BorderRadius.circular(1),
                  // toY: data['LeaveCount']+data['AbsentCount']+data['PresentCount'],
                  toY: data['PresentCount'] + data['AbsentCount']+data['LeaveCount'],
                  rodStackItems: [
                    BarChartRodStackItem(0, data['PresentCount'], Colors.green),
                    BarChartRodStackItem(data['PresentCount'], data['PresentCount'] + data['AbsentCount'], Colors.orange),
                    BarChartRodStackItem(data['PresentCount'] + data['AbsentCount'], data['PresentCount'] + data['AbsentCount'] + data['LeaveCount'], Colors.red),
                  ],
                  width: 12,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget expenseTable(){
    return SizedBox(
      // height: expenseData.length*50,
      child: DataTable(
        // headingRowColor: WidgetStateColor.resolveWith(
        //         (states) => Colors.blue),
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Amount')),
        ],
        rows: expenseData.map((model) {
          return DataRow(
            cells: [
              DataCell(Text(model['Type'],style: TextStyle(fontWeight: model['Type']=='Total'?FontWeight.bold:FontWeight.normal),)),
              DataCell(Text(model['Amount'].toString(),style: TextStyle(fontWeight: model['Type']=='Total'?FontWeight.bold:FontWeight.normal),)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget legendWidget(String name,Color col){
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: SizedBox(
        width: 80,
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: col,
            ),
            const SizedBox(width: 5,),
            Center(child: Text(name,style: const TextStyle(color: Colors.black,fontSize: 12),)),
          ],
        ),
      ),
    );
  }


}