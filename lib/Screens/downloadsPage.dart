import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:einlogica_hr/Models/billerModel.dart';
import 'package:einlogica_hr/Screens/upload_bill.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithCalendar.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithDropDown.dart';
import 'package:einlogica_hr/services/savefile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/activityModel.dart';
import 'package:einlogica_hr/Models/attendanceModel.dart';
import 'package:einlogica_hr/Models/userExpenseModel.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

import '../Models/collectionModel.dart';
import '../Models/reporteeModel.dart';

class downloadsPage extends StatefulWidget {

  final String name;
  final String mobile;
  final String permission;
  const downloadsPage({super.key, required this.name,required this.mobile,required this.permission});

  @override
  State<downloadsPage> createState() => _downloadsPageState();
}

class _downloadsPageState extends State<downloadsPage> {

  var w=0.00,h=0.00,t=0.00;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  List<String>ReportList=["Select","Attendance","Expense","Activity","Bill Image"];
  String reportDropDown = "Select";
  // List<trackerModel> trackerList = [];
  List<userExpenseModel> trackerList = [];
  List<attendanceModel> attendanceList = [];
  List<activityModel> activityList = [];
  List<collectionModel> collectionList =[];
  List<billerModel> billerList = [];

  List<reporteeModel> reporteeList =[];
  List<String> selectedUsers = [];
  List<String> employees = ["Select All"];
  bool enableList = false;
  bool tableView = false;

  DateTime? pickedDate1=DateTime.now();
  DateTime? pickedDate2=DateTime.now();
  bool refresh=true;
  String collectionTab='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchData(widget.department);
    fetchAll();
  }

  fetchAll()async{
    reporteeList = await apiServices().getReportees(widget.mobile,"ALL");
    // employees.clear();
    for (var d in reporteeList){
      employees.add(d.Name);
      // print(d.Name);
    }

    fetchData();
  }

  fetchData()async{
    // print("fetching data");
    collectionTab = await apiServices().getSettings('CollectionTab');
    // print(collectionTab);
    if(collectionTab=='1'){
      ReportList.addAll(["Material","Cash","Locations","Collection Image"]);
    }
    setState(() {
      refresh=false;
    });
  }

  dropdownCallback(String title,String selected){
    reportDropDown=selected;
  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      body: Container(
        width: w,
        height: h,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 80+t,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.themeStart,AppColors.themeStop]
                    ),
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
                            const Text("Reports",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            const SizedBox(
                              width: 60,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40,),
                SizedBox(
                  width: w-60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: w>h?w/2-100:w-100,
                        // color: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Employees:",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("${selectedUsers.length}  "),
                          ],
                        ),
                      ),

                      InkWell(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                              color: AppColors.buttonColorDark),
                          child: Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.white,),
                        ),
                        onTap: (){
                          setState(() {
                            enableList=true;
                          });
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                FieldAreaWithDropDown(title: "Reports", dropList: ReportList, dropdownValue: reportDropDown, callback: dropdownCallback),
                FieldAreaWithCalendar(title: "From Date", ctrl: fromController, type: TextInputType.text,days:800),
                FieldAreaWithCalendar(title: "To Date", ctrl: toController, type: TextInputType.text,days:800),
                const SizedBox(height: 40,),
                SizedBox(
                  width: w-50,
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.buttonColorDark)),
                      onPressed: ()async{
                    setState(() {
                      refresh=true;
                    });
                    await downloadTracker(selectedUsers,reportDropDown,fromController.text,toController.text);
                    setState(() {
                      refresh=false;
                    });

                  }, child: const Text("Fetch",style: TextStyle(color: Colors.white),)),
                ),
                const SizedBox(height: 20,),



              ],
            ),
            enableList?Container(
              width: w,
              height: h,
              color: Colors.black.withOpacity(.4),
              child: Center(
                child: Container(
                  width: w>h?w/2:w-20,
                  height: h*.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),

                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        width: w>h?w/2:w-20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                          color: Colors.blue
                        ),
                        child: Center(child: Text("Select Employees",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
                      ),
                      SizedBox(
                        height: (h*.8-110),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: employees.length,
                          itemBuilder: (context,index){
                            return ListTile(
                              title: Text("${employees[index]}"),
                              leading: SizedBox(
                                width: 40,
                                height: 40,
                                child: index==0?SizedBox():selectedUsers.contains(reporteeList[index-1].Mobile)?const Icon(Icons.check,color: Colors.green,):SizedBox(),
                              ),
                              onTap: (){

                                if(index==0){
                                  if(selectedUsers.length!=reporteeList.length){
                                    selectedUsers.clear();
                                    for(var d in reporteeList){
                                      selectedUsers.add(d.Mobile);
                                    }
                                  }
                                  else{
                                    selectedUsers.clear();
                                  }
                                }
                                else if(selectedUsers.contains(reporteeList[index-1].Mobile)){
                                  selectedUsers.remove(reporteeList[index-1].Mobile);
                                }
                                else{
                                  selectedUsers.add(reporteeList[index-1].Mobile);
                                }

                                // print(selectedUsers);
                                setState(() {

                                });
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        width:w>h?w/2:w-80,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.buttonColorDark)),
                          onPressed: (){
                            setState(() {
                              enableList=false;
                            });
                          },
                          child: const Text("Done",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(height: 10,)
                    ],
                  ),
                ),
              ),
            ):SizedBox(),

            tableView?SafeArea(
              child: Container(
                // width: w,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: tableWidget()),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: ()async{
                              setState(() {
                                refresh=true;
                              });
                              await _saveToFile(dropdownvalue);
                              setState(() {
                                refresh=false;
                              });
                            },
                            child: Text("Download"),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),foregroundColor: MaterialStateProperty.all(Colors.white)),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),foregroundColor: MaterialStateProperty.all(Colors.white)),
                            onPressed: (){
                              setState(() {
                                tableView=false;
                              });
                            },
                            child: Text("Close")),
                      ],
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ):SizedBox(),

            refresh?Container(
              width: w,
              height: h,
              color: Colors.black.withOpacity(.2),
              child: const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ):SizedBox(),
          ],
        ),
      ),
    );
  }


  Widget tableWidget(){

    if(reportDropDown=="Attendance"){
      return DataTable(
        // columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Location')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('In Time')),
          DataColumn(label: Text('Out Time')),
          // DataColumn(label: Text('Action')),
        ],
        rows: attendanceList.map((model) {
          return DataRow(
            cells: [
              DataCell(Text(model.Name)),
              DataCell(Text(model.location)),
              DataCell(Text(model.attDate)),
              DataCell(Text(model.attTime)),
              DataCell(Text(model.outTime)),
            ],
          );
        }).toList(),
      );
    }
    else if(reportDropDown=="Expense"){
      return DataTable(
        // columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Location')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Item')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Status')),

        ],
        rows: trackerList.map((model) {
          return DataRow(
            cells: [
              DataCell(Text(model.Date)),
              DataCell(Text(model.Name)),
              DataCell(Text(model.Site)),
              DataCell(Text(model.Type)),
              DataCell(Text(model.Item)),
              DataCell(Text(model.Amount)),
              DataCell(Text(model.Status)),

            ],
          );
        }).toList(),
      );
    }
    else if(reportDropDown=="Activity"){
      return DataTable(
        // columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Location')),
          // DataColumn(label: Text('Activity')),
          DataColumn(label: Text('Remarks')),
          // DataColumn(label: Text('Action')),
        ],
        rows: activityList.map((model) {
          return DataRow(
            cells: [
              DataCell(Text(model.name)),
              DataCell(Text(model.type)),
              DataCell(Text(model.site)),
              // DataCell(Text(model.)),
              DataCell(Text(model.remarks)),
            ],
          );
        }).toList(),
      );
    }
    else if(reportDropDown=="Material"){
      return DataTable(
        // columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Shop')),
          DataColumn(label: Text('Dry')),
          DataColumn(label: Text('Cloth')),
          DataColumn(label: Text('Rej Price')),
          DataColumn(label: Text('Amount')),
        ],
        rows: collectionList.map((model) {
          return DataRow(
            cells: [
              DataCell(Text(model.name)),
              DataCell(Text(model.shopname)),
              DataCell(Text(model.dry)),
              DataCell(Text(model.cloth)),
              DataCell(Text(model.amt)),
              DataCell(Text(model.tot)),
            ],
          );
        }).toList(),
      );
    }
    else if(reportDropDown=="Cash"){
      return DataTable(
        // columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Shop')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Time')),
          // DataColumn(label: Text('Rej Price')),
          DataColumn(label: Text('Amount')),
        ],
        rows: collectionList.map((model) {
          return DataRow(
            cells: [
              DataCell(Text(model.name)),
              DataCell(Text(model.shopname)),
              DataCell(Text(model.date)),
              DataCell(Text(model.time)),
              // DataCell(Text(model.amt)),
              DataCell(Text(model.tot)),
            ],
          );
        }).toList(),
      );
    }
    else if(reportDropDown=="Locations"){
      return DataTable(
        // columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Shop')),
          DataColumn(label: Text('Address')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Time')),
          // DataColumn(label: Text('Rej Price')),
          DataColumn(label: Text('Type')),
        ],
        rows: billerList.map((model) {
          return DataRow(
            cells: [
              DataCell(Text(model.createUser)),
              DataCell(Text(model.name)),
              DataCell(Text(model.addressl1)),
              DataCell(Text(model.createDate)),
              DataCell(Text(model.createTime)),
              // DataCell(Text(model.amt)),
              DataCell(Text(model.type)),
            ],
          );
        }).toList(),
      );
    }
    else{
      return SizedBox();
    }

  }






  Future<void> downloadTracker(List<String> users,String item,String fromDate, String toDate)async{

    if(item=='Select' || fromDate=="" || toDate==""){
      showMessage("Invalid input dates");
      return;
    }

    // Parse the date strings into DateTime objects
    DateTime date1 = DateTime.parse(fromDate);
    DateTime date2 = DateTime.parse(toDate);

    // Calculate the difference between the two dates
    int diff = date2.difference(date1).inDays;
    // print(diff);
    // return;

    if(diff<0){
      showMessage("Invalid input dates");
      return;
    }
    else if(diff>90){
      showMessage("Max 90 days data can be fetched !");
      return;
    }
    else if(selectedUsers.length==0){
      showMessage("No employee selected !");
      return;
    }
    // return;

    // print(item);
    trackerList.clear();
    attendanceList.clear();
    activityList.clear();
    collectionList.clear();
    billerList.clear();
    String status="No Files to download";
    if(item=="Bill Image"){
      final response = await apiServices().getZip(selectedUsers, fromDate, toDate,"Bill");
      // print("response = ${response.toString()}");
      if(response.isNotEmpty){
      status = await savefile().downloadImage("Bills-${DateFormat('ddMMyyyyhhmmss').format(DateTime.now())}.zip", response);

      }

      showMessage(status);
    }
    else if(item=="Collection Image"){
      final response = await apiServices().getZip(selectedUsers, fromDate, toDate,"Collection");
      // print("response = ${response.toString()}");
      if(response.isNotEmpty){
        status = await savefile().downloadImage("Bills-${DateFormat('ddMMyyyyhhmmss').format(DateTime.now())}.zip", response);

      }

      showMessage(status);
    }
    else{

      String response = await apiServices().getTracker(users,item, fromDate, toDate);
      // print(response);
      var data = jsonDecode(response);
      for (var d in data){
        if(item=="Expense"){
          // trackerList.add(trackerModel(Mobile: d['Mobile'], Name: d['Name'], Site: d['Site'],FromLoc: ,ToLoc: d['ToLoc'],KM: d['KM'], Date: d['Date'], Type: d['Type'], BillNo: d['BillNo'], Amount: double.parse(d['Amount']), Filename: d['Filename'],Status: d['Status']));

          trackerList.add(userExpenseModel(ID: d['ID'], Mobile: d['Mobile'], Name: d['Name'], Site: d['Site'], LabourName: d['LabourName'],LabourCount: d['LabourCount'], Duration: d['Duration'], FromLoc: d['FromLoc'],
              ToLoc: d['ToLoc'], KM: d['KM'], Date: d['Date'], Type: d['Type'],Item: d['Item'], ShopName: d['ShopName']??"", ShopDist: d['ShopDist']??"", ShopPhone: d['ShopPhone']??"", ShopGst: d['ShopGST']??"",
              BillNo: d['BillNo'], Amount: d['Amount'], Filename: d['Filename'], Status: d['Status'], L1Status: d['L1Status'], L1Comments: d['L1Comments'], L2Status: d['L2Status'],
              L2Comments: d['L2Comments'],FinRemarks: d['FinRemarks']));
        }
        else if(item=="Attendance"){
          attendanceList.add(attendanceModel(Name: d['Name'], Mobile: d['Mobile'], posLat: double.parse(d['PosLat']), posLong: double.parse(d['PosLong']), attDate: d['Date'], attTime: d['InTime'], posLat2: double.parse(d['PosLat2']),posLong2: double.parse(d['PosLong2']),outTime: d['OutTime'],flag: d['Flag'],status: d['Status'],location: d['Location'],comments: d['Comments']));
        }
        else if(item=="Activity"){
          activityList.add(activityModel(id: d['ID'], mobile: d['Mobile'], name: d['Name'],type: d['Type'], site: d['Site'], drive: bool.parse(d['Drive']), sKM: int.parse(d['StartKM']), eKM: int.parse(d['EndKM']), lat: d['PosLat'], long: d['PosLong'], date: d['Date'], time: d['Time'], cust: d['Customer'],remarks: d['Remarks']));
        }
        else if (item=='Material' || item=='Cash'){
          collectionList.add(collectionModel(id: d['ID'], mobile: d['Mobile'], name: d['Name'], shopid: d['ShopID'], shopname: d['ShopName'],l1: d['AddressL1'],l2:d['AddressL2'],l3:d['AddressL3'],dist: d['District'],phone: d['Phone'],gst: d['GST'],div: d['Division'],type: d['Type'], date: d['Date'],time: d['Time'], item: d['Item'],dry: d['DryWeight'],dryPrice: d['DryPrice'], cloth: d['ClothWeight'],clothPrice: d['ClothPrice'], amt: d['Amount'], file: d['Filename'],lat: d['Lat'],long: d['Long'],tot: d['Total']));
        }
        else if(item=='Locations'){
          billerList.add(billerModel(id: d['ShopID'], name: d['ShopName'], addressl1: d['AddressL1'], addressl2: d['AddressL2'], addressl3: d['AddressL3'], district: d['District'], mobile: d['Phone'], gst: d['GST'],division: d['Division'],type: d['Type'],createDate: d['CreateDate'],createTime: d['CreateTime'],createUser: d['CreateUser'],createMobile: d['CreateMobile']));
        }
      }
      // await _saveToFile(item);
      // print(billerList.length);
      if(trackerList.isNotEmpty || attendanceList.isNotEmpty || activityList.isNotEmpty || collectionList.isNotEmpty || billerList.isNotEmpty){
        setState(() {
          tableView=true;
        });
      }
      else{
        showMessage("Data not found");
      }

    }


  }



  _saveToFile(String item)async{
    // print("My Comments");
    // final directory = await getApplicationDocumentsDirectory();
    // print(directory?.path);

    // final file = File('${directory.path}/$item-File.csv');
    // final file = File('/storage/emulated/0/Download/$item-File.csv');

    List<List<dynamic>> rows = [];//List<List<dynamic>>();


    if(item=="Attendance"){
      rows.add(["Mobile","Name","PosLat","PosLong","Date","InTime","PosLat2","PosLong2","OutTime","Status","Location","Comments"]);

      attendanceList.forEach((element) async{
        List<dynamic> row = [];//List<dynamic>();
        row.add(element.Mobile);
        row.add(element.Name);
        row.add(element.posLat);
        row.add(element.posLong);
        row.add(element.attDate);
        row.add(element.attTime);
        row.add(element.posLat2);
        row.add(element.posLong2);
        row.add(element.outTime);
        row.add(element.status);
        row.add(element.location);
        row.add(element.comments);
        rows.add(row);
      });
    }
    else if(item=="Expense"){
      rows.add(["Mobile","Name","Site","LabourName","LabourCount","Duration","From","To","Km","Date","Type","Item","ShopName","ShopDist","ShopPhone","ShopGST","BillNo","Amount","Filename","Status","L1Status","L1Comments","L2Status","L2Comments"]);

      // trackerList.add(userExpenseModel(ID: d['ID'], Mobile: d['Mobile'], Name: d['Name'], Site: d['Site'], LabourName: d['LabourName'], Duration: d['Duration'],
      // FromLoc: d['FromLoc'], ToLoc: d['ToLoc'], KM: d['KM'], Date: d['Date'], Type: d['Type'], ShopName: d['ShopName'], ShopDist: d['ShopDist'],
      // ShopPhone: d['ShopPhone'], ShopGst: d['ShopGst'], BillNo: d['BillNo'], Amount: d['Amount'], Filename: d['Filename'], Status: d['Status'],
      // L1Status: d['L1Status'], L1Comments: d['L1Comments'], L2Status: d['L2Status'], L2Comments: d['L2Comments']));


      trackerList.forEach((element) async{
        List<dynamic> row = [];//List<dynamic>();
        row.add(element.Mobile);
        row.add(element.Name);
        row.add(element.Site);
        row.add(element.LabourName);
        row.add(element.LabourCount);
        row.add(element.Duration);
        row.add(element.FromLoc);
        row.add(element.ToLoc);
        row.add(element.KM);
        row.add(element.Date);
        row.add(element.Type);
        row.add(element.Item);
        row.add(element.ShopName);
        row.add(element.ShopDist);
        row.add(element.ShopPhone);
        row.add(element.ShopGst);
        row.add(element.BillNo);
        row.add(element.Amount);
        row.add(element.Filename);
        row.add(element.Status);
        row.add(element.L1Status);
        row.add(element.L1Comments);
        row.add(element.L2Status);
        row.add(element.L2Comments);
        rows.add(row);
      });
    }
    else if(item=="Activity"){
      rows.add(["Mobile","Name","Activity","Customer","Site","Drive","StartKM","EndKM","PosLat","PosLong","Date","Time","Remarks"]);

      activityList.forEach((element) async{
        List<dynamic> row = [];//List<dynamic>();
        row.add(element.mobile);
        row.add(element.name);
        row.add(element.type);
        row.add(element.cust);
        row.add(element.site);
        row.add(element.drive);
        row.add(element.sKM);
        row.add(element.eKM);
        row.add(element.lat);
        row.add(element.long);
        // row.add(element.activity);
        row.add(element.date);
        row.add(element.time);
        row.add(element.remarks);
        rows.add(row);
      });
    }
    else if(item=="Material"){
      rows.add(["Mobile","Name","Division","Type","BuildingName","AddressL1","AddressL2","AddressL3","District","Phone","GST","Date","DryWeight","DryPrice","ClothWeight","ClothPrice",'Amount(Rejected)','Total','FileName']);

      collectionList.forEach((element) async{
        if(element.item=="Material"){
          List<dynamic> row = [];//List<dynamic>();
          row.add(element.mobile);
          row.add(element.name);
          row.add(element.div);
          row.add(element.type);
          row.add(element.shopname);
          row.add(element.l1);
          row.add(element.l2);
          row.add(element.l3);
          row.add(element.dist);
          row.add(element.phone);
          row.add(element.gst);
          row.add(element.date);
          row.add(element.dry);
          row.add(element.dryPrice);
          row.add(element.cloth);
          row.add(element.clothPrice);
          row.add(element.amt);
          row.add(element.tot);
          row.add(element.file);
          rows.add(row);
        }

      });
    }
    else if(item=="Cash"){
      rows.add(["Mobile","Name","Division","Type","BuildingName","AddressL1","AddressL2","AddressL3","District","Phone","GST","Date",'Amount','FileName']);

      collectionList.forEach((element) async{
        if(element.item=="Cash"){
          List<dynamic> row = [];//List<dynamic>();
          row.add(element.mobile);
          row.add(element.name);
          row.add(element.div);
          row.add(element.type);
          row.add(element.shopname);
          row.add(element.l1);
          row.add(element.l2);
          row.add(element.l3);
          row.add(element.dist);
          row.add(element.phone);
          row.add(element.gst);
          row.add(element.date);
          row.add(element.tot);
          row.add(element.file);
          rows.add(row);
        }

      });
    }
    else if(item=="Location"){
      rows.add(["Mobile","Name","Division","Type","BuildingName","AddressL1","AddressL2","AddressL3","District","Phone","GST","Date",'Amount','FileName']);

      collectionList.forEach((element) async{
        if(element.item=="Cash"){
          List<dynamic> row = [];//List<dynamic>();
          row.add(element.mobile);
          row.add(element.name);
          row.add(element.div);
          row.add(element.type);
          row.add(element.shopname);
          row.add(element.l1);
          row.add(element.l2);
          row.add(element.l3);
          row.add(element.dist);
          row.add(element.phone);
          row.add(element.gst);
          row.add(element.date);
          row.add(element.tot);
          row.add(element.file);
          rows.add(row);
        }

      });
    }

    String csv = const ListToCsvConverter().convert(rows);

    final fileName = '$item-File-${DateTime.now().millisecond}.csv';

    String status = await savefile().downloadCSVFile(fileName, csv);
    // print(fileName);
    showMessage(status);


  }


  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }


}

