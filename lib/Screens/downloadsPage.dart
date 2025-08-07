import 'dart:convert';
// import 'dart:js_interop';
import 'package:csv/csv.dart';
import 'package:einlogica_hr/Models/billerModel.dart';
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
  String collectionTab='0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchData(widget.department);
    fetchAll();
  }

  fetchAll()async{
    reporteeList = await apiServices().getReportees(widget.mobile,"ALL",DateTime.now().toString());

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
    if(int.parse(collectionTab)>0){
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
                            const Text("Employees:",style: TextStyle(fontWeight: FontWeight.bold),),
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
                          child: const Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.white,),
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
                const SizedBox(height: 20,),
                FieldAreaWithDropDown(title: "Reports", dropList: ReportList, dropdownValue: reportDropDown, callback: dropdownCallback),
                // SizedBox(height: 10,),
                FieldAreaWithCalendar(title: "From Date", ctrl: fromController, type: TextInputType.text,days:800,fdays: 0,),
                FieldAreaWithCalendar(title: "To Date", ctrl: toController, type: TextInputType.text,days:800,fdays: 0,),
                const SizedBox(height: 40,),
                SizedBox(
                  width: w-50,
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
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
              color: Colors.black.withValues(alpha: .4),
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
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                          color: Colors.blue
                        ),
                        child: const Center(child: Text("Select Employees",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
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
                                child: index==0?const SizedBox():selectedUsers.contains(reporteeList[index-1].Mobile)?const Icon(Icons.check,color: Colors.green,):const SizedBox(),
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
                      const SizedBox(height: 10,),
                      SizedBox(
                        width:w>h?w/2-80:w-80,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                          onPressed: (){
                            setState(() {
                              enableList=false;
                            });
                          },
                          child: const Text("Done",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      const SizedBox(height: 10,)
                    ],
                  ),
                ),
              ),
            ):const SizedBox(),

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
                              // print(dropdownvalue);
                              await _saveToFile(reportDropDown);
                              setState(() {
                                refresh=false;
                              });
                            },
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue),foregroundColor: WidgetStateProperty.all(Colors.white)),
                            child: const Text("Download"),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue),foregroundColor: WidgetStateProperty.all(Colors.white)),
                            onPressed: (){
                              setState(() {
                                tableView=false;
                              });
                            },
                            child: const Text("Close")),
                      ],
                    ),
                    const SizedBox(height: 10,)
                  ],
                ),
              ),
            ):const SizedBox(),

            refresh?Container(
              width: w,
              height: h,
              color: Colors.black.withValues(alpha: .2),
              child: const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ):const SizedBox(),
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
          DataColumn(label: Text('Status')),
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
              DataCell(Text(model.status)),
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
      return collectionTab=='1'?DataTable(
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
      ):DataTable(
        // columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Shop')),
          DataColumn(label: Text('Dry Weight (KG)')),
          DataColumn(label: Text('Liquid Weight (L)')),
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
          DataColumn(label: Text('Method')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Bill No')),
          DataColumn(label: Text('Amount')),
        ],
        rows: collectionList.map((model) {
          return DataRow(
            cells: [
              DataCell(Text(model.name)),
              DataCell(Text(model.shopname)),
              DataCell(Text(model.item)),
              DataCell(Text(model.date)),
              DataCell(Text(model.time)),
              DataCell(Text(model.billno)),
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
      return const SizedBox();
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
    else if(diff>366){
      showMessage("Max 1 year data can be fetched !");
      return;
    }
    else if(selectedUsers.isEmpty){
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
      // print("================response");
      // print(response);
      var data = jsonDecode(response);
      for (var d in data){
        if(item=="Expense"){
          // trackerList.add(trackerModel(Mobile: d['Mobile'], Name: d['Name'], Site: d['Site'],FromLoc: ,ToLoc: d['ToLoc'],KM: d['KM'], Date: d['Date'], Type: d['Type'], BillNo: d['BillNo'], Amount: double.parse(d['Amount']), Filename: d['Filename'],Status: d['Status']));

          trackerList.add(userExpenseModel(ID: d['ID'], Mobile: d['Mobile'], Name: d['Name'], Site: d['Site'], LabourName: d['LabourName'],LabourCount: d['LabourCount'], Duration: d['Duration'], FromLoc: d['FromLoc'],
              ToLoc: d['ToLoc'], KM: d['KM'], Date: d['Date'], Type: d['Type'],Item: d['Item'], ShopName: d['ShopDesc']??"", ShopDist: d['ShopDist']??"", ShopPhone: d['ShopPhone']??"", ShopGst: d['ShopGST']??"",
              BillNo: d['BillNo'], Amount: d['Amount'], Filename: d['Filename'], Status: d['Status'], L1Status: d['L1Status'], L1Comments: d['L1Comments'], L2Status: d['L2Status'],
              L2Comments: d['L2Comments'],FinRemarks: d['FinRemarks']));
        }
        else if(item=="Attendance"){
          attendanceList.add(attendanceModel(Name: d['Name'], Mobile: d['Mobile'], posLat: double.parse(d['PosLat']), posLong: double.parse(d['PosLong']), attDate: d['Date'], attTime: d['InTime'], posLat2: double.parse(d['PosLat2']),posLong2: double.parse(d['PosLong2']),outDate: d['OutDate'],outTime: d['OutTime'],duration: d['Duration'],flag: d['Flag'],status: d['Status'],location: d['Location'],comments: d['Comments']));
        }
        else if(item=="Activity"){
          activityList.add(activityModel(id: d['ID'], mobile: d['Mobile'], name: d['Name'],type: d['Type'], site: d['Site'], drive: bool.parse(d['Drive']), sKM: int.parse(d['StartKM']), eKM: int.parse(d['EndKM']), lat: d['PosLat'], long: d['PosLong'], date: d['Date'], time: d['Time'], cust: d['Customer'],remarks: d['Remarks']));
        }
        else if (item=='Material' || item=='Cash'){
          collectionList.add(collectionModel(id: d['ID'], mobile: d['Mobile'], name: d['Name'], shopid: d['ShopID'], shopname: d['ShopName'],vehicle: d['Vehicle'],l1: d['AddressL1'],l2:d['AddressL2'],l3:d['AddressL3'],dist: d['District'],phone: d['Phone'],gst: d['GST'],div: d['Division'],type: d['Type'], date: d['Date'],time: d['Time'], item: d['Item'],dry: d['DryWeight'],dryPrice: d['DryPrice'], cloth: d['ClothWeight'],clothPrice: d['ClothPrice'], amt: d['Amount'], file: d['Filename'],lat: d['Lat'],long: d['Long'],tot: d['Total'],billno: d['BillNo']));
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
      rows.add(["Mobile","Name","PosLat","PosLong","Date","InTime","PosLat2","PosLong2","OutDate","OutTime","Status","Location","Duration","Comments"]);

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
        row.add(element.outDate);
        row.add(element.outTime);
        row.add(element.status);
        row.add(element.location);
        row.add(element.outTime);
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

      if(collectionTab=='2'){
        rows.add(["Mobile","Name","Activity","Site","Drive","StartKM","EndKM","PosLat","PosLong","Date","Time","Remarks"]);
      }
      else{
        rows.add(["Mobile","Name","Activity","Customer","Site","Drive","StartKM","EndKM","PosLat","PosLong","Date","Time","Remarks"]);
      }


      activityList.forEach((element) async{
        List<dynamic> row = [];//List<dynamic>();
        row.add(element.mobile);
        row.add(element.name);
        row.add(element.type);
        collectionTab=='2'?null:row.add(element.cust);
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
      if(collectionTab=='2'){
        rows.add(["Mobile","Name","Division","Type","BuildingName","AddressL1","AddressL2","AddressL3","Phone","GST","Date","DryWeight","DryPrice","ClothWeight","ClothPrice",'Amount(Rejected)','Total','FileName']);
      }
      else{
        rows.add(["Mobile","Name","Division","Type","BuildingName","AddressL1","AddressL2","AddressL3","District","Phone","GST","Date","DryWeight","DryPrice","ClothWeight","ClothPrice",'Amount(Rejected)','Total','FileName']);
      }


      collectionList.forEach((element) async{
          List<dynamic> row = [];//List<dynamic>();
          row.add(element.mobile);
          row.add(element.name);
          row.add(element.div);
          row.add(element.type);
          row.add(element.shopname);
          row.add(element.l1);
          row.add(element.l2);
          row.add(element.l3);
          collectionTab=='2'?null:row.add(element.dist);
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
      });
    }
    else if(item=="Cash"){
      if(collectionTab=='2'){
        rows.add(["Mobile","Name","Division","Method","Type","BuildingName","AddressL1","AddressL2","AddressL3","Phone","GST","Date",'Amount','BillNo','FileName']);
      }
      else{
        rows.add(["Mobile","Name","Division","Method","Type","BuildingName","AddressL1","AddressL2","AddressL3","District","Phone","GST","Date",'Amount','BillNo','FileName']);
      }


      collectionList.forEach((element) async{
          List<dynamic> row = [];//List<dynamic>();
          row.add(element.mobile);
          row.add(element.name);
          row.add(element.div);
          row.add(element.item);
          row.add(element.type);
          row.add(element.shopname);
          row.add(element.l1);
          row.add(element.l2);
          row.add(element.l3);
          collectionTab=='2'?null:row.add(element.dist);
          row.add(element.phone);
          row.add(element.gst);
          row.add(element.date);
          row.add(element.tot);
          row.add(element.billno);
          row.add(element.file);
          rows.add(row);
      });
    }
    else if(item=="Locations"){
      if(collectionTab=='2'){
        rows.add(["ShopName","Address L1","Address L2","Address L3","Phone","GST","Division","Type","Date","Time","User",'UserMobile']);
      }
      else{
        rows.add(["ShopName","Address L1","Address L2","Address L3","District","Phone","GST","Division","Type","Date","Time","User",'UserMobile']);
      }

      // billerList.add(billerModel(id: d['ShopID'], name: d['ShopName'], addressl1: d['AddressL1'], addressl2: d['AddressL2'], addressl3: d['AddressL3'], district: d['District'], mobile: d['Phone'], gst: d['GST'],division: d['Division'],type: d['Type'],createDate: d['CreateDate'],createTime: d['CreateTime'],createUser: d['CreateUser'],createMobile: d['CreateMobile']));

      billerList.forEach((element) async{
          List<dynamic> row = [];//List<dynamic>();

          row.add(element.name);
          row.add(element.addressl1);
          row.add(element.addressl2);
          row.add(element.addressl3);
          collectionTab=='2'?null:row.add(element.district);
          row.add(element.mobile);
          row.add(element.gst);
          row.add(element.division);
          row.add(element.type);
          row.add(element.createDate);
          row.add(element.createTime);
          row.add(element.createUser);
          row.add(element.createMobile);
          rows.add(row);
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

