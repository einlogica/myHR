import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:einlogica_hr/Models/reporteeModel.dart';
import 'package:einlogica_hr/services/savefile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/payRollModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';
import 'package:month_year_picker/month_year_picker.dart';

class generatePayrollPage extends StatefulWidget {

  final userModel currentUser;
  const generatePayrollPage({super.key,required this.currentUser});

  @override
  State<generatePayrollPage> createState() => _generatePayrollPageState();
}

class _generatePayrollPageState extends State<generatePayrollPage> {

  var w=0.00,h=0.00,t=0.00;

  List<payRollModel> payrollList = [];
  bool _loading = true;
  String type="NONE";

  final TextEditingController _monthCtrl = TextEditingController();
  // TextEditingController _typeCtrl = TextEditingController();
  DateTime? _selected=DateTime.now();
  // String _editID = "";
  payRollModel editPaySlip = payRollModel(Mobile: "", Name: "",Month: 0,Year: 0, Days: 0, WorkingDays: 0, LeaveDays: 0, LOP: 0, PresentDays: 0, TotalLOP: 0, Basic: 0, Allowance: 0, HRA: 0, TA: 0, DA: 0, Incentive: 0, GrossIncome: 0, PF: 0, ESIC: 0, ProTax: 0, Advance: 0, GrossDeduction: 0, NetPay: 0);
  double _totPF=0,_totESIC=0,_totDed=0,_totNetPay=0;
  bool enableLOP=true;
  List<reporteeModel> reporteeList =[];
  List<String> selectedUsers = [];
  List<String> employees = ["Select All"];
  bool enableList = false;

  // TextEditingController _lopCtrl= TextEditingController();
  // TextEditingController _advCtrl= TextEditingController();
  // TextEditingController _lopCtrl= TextEditingController();
  // TextEditingController _lopCtrl= TextEditingController();
  // TextEditingController _lopCtrl= TextEditingController();

  @override
  void dispose() {
    _monthCtrl.dispose();
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAll();
  }

  fetchAll()async{
    reporteeList = await apiServices().getReportees(widget.currentUser.Mobile,"ALL");
    // employees.clear();
    for (var d in reporteeList){
      employees.add(d.Name);
      // print(d.Name);
    }
    // print(reporteeList.toString());
    type="Template";
    fetchData(type);
  }

  fetchData(String type)async{
    // print("AAAA");
      setState(() {
        _loading=true;
      });
      payrollList.clear();
      if(type=="PayRoll"){
        payrollList = await apiServices().fetchPayRoll(_selected!.month,_selected!.year);
      }
      else if(type=="Template"){
        payrollList = await apiServices().getPayrollTemplate();
      }

      _totPF=0;_totESIC=0;_totDed=0;_totNetPay=0;
      for (var d in payrollList){
        _totPF=_totPF+d.PF;
        _totESIC=_totESIC+d.ESIC;
        _totDed=_totDed+d.GrossDeduction;
        _totNetPay=_totNetPay+d.NetPay;
      }
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
                            const Text("Payroll",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            payrollList.isNotEmpty?SizedBox(
                              width: 60,
                              height: 40,
                              // child: Icon(Icons.calendar_month,color: Colors.white,),
                              child: PopupMenuButton<String>(

                                icon: const Icon(Icons.more_vert,color: Colors.white,),
                                color:Colors.white,
                                onSelected: (String choice) async{
                                  // Handle menu item selection here
                                  if(choice=="Delete"){
                                    String status = await apiServices().deleteTemplate();
                                    if(status=="Success"){
                                      payrollList.clear();
                                      _monthCtrl.clear();
                                      setState(() {

                                      });
                                    }
                                  }
                                  else if(choice=='Download'){
                                    await _saveToFile();
                                  }
                                  else if(choice=='Rollout'){
                                    setState(() {
                                      _loading=true;
                                    });
                                    String status = await apiServices().rolloutPaySlip();
                                    showMessage(status);
                                    status = await apiServices().deleteTemplate();
                                    if(status=="Success"){
                                      payrollList.clear();
                                      _monthCtrl.clear();
                                    }
                                    type="Template";
                                    fetchData(type);
                                  }
                                },
                                itemBuilder: (BuildContext context) {

                                  return <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'Delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(width: 10,),
                                          Text('Clear All'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Download',
                                      child: Row(
                                        children: [
                                          Icon(Icons.download),
                                          SizedBox(width: 10,),
                                          Text('Download'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      enabled: type=="PayRoll"?false:true,
                                      value: 'Rollout',
                                      child: const Row(
                                        children: [
                                          Icon(Icons.account_tree_outlined),
                                          SizedBox(width: 10,),
                                          Text('Rollout'),
                                        ],
                                      ),
                                    ),

                                  ];
                                },
                              ),
                            ):InkWell(
                              onTap: ()async{
                                type="Template";
                                _processFile();
                              },
                              child: const SizedBox(
                                width: 60,
                                height: 40,
                                child: Icon(Icons.upload,color: Colors.white,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                payrollList.isEmpty?SizedBox(
                  width: w>h?w/2:w-10,

                  child: SizedBox(
                    width: w>h?w/2:w-10,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    //   border: Border.all(color: Colors.black),
                    //   color: Colors.white
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: w>h?w/2-100:w-100,
                                  child: FieldArea("Month/Year", _monthCtrl, TextInputType.text,false)),

                              InkWell(
                                onTap: ()async{
                                  _selected = await showMonthYearPicker(

                                    context: context,
                                    initialDate: _selected ?? DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2030),
                                    // locale: localeObj,
                                  );
                                  if(_selected!=null){
                                    _monthCtrl.text = "${_selected!.month.toString()} / ${_selected!.year.toString()}";
                                  }
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                                      color: AppColors.buttonColorDark),
                                  child: const Icon(Icons.calendar_month_sharp,color: Colors.white,),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20,),

                          Row(
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

                          const SizedBox(height: 20,),

                          Row(
                            children: [
                              SizedBox(
                                width: w>h?w/2-100:w-100,
                                // color: Colors.grey,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      // width: w>h?w*.1:w*.25,
                                      // color: Colors.green,
                                      child: Text("Consider LOP:",style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Checkbox(

                                      value: enableLOP,
                                      onChanged: (value){
                                        enableLOP=!enableLOP;
                                        setState(() {

                                        });

                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 40,)
                            ],
                          ),

                          const SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: w>h?w/5:w/2.5,
                                height: 40,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: Colors.blue),
                                    onPressed: (){
                                  type="PayRoll";
                                  fetchData(type);
                                }, child: const Text("Fetch Payroll",)),
                              ),
                              SizedBox(
                                width: w>h?w/5:w/2.5,
                                height: 40,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: Colors.blue),
                                    onPressed: ()async{
                                  // print(selectedUsers);
                                  if(_monthCtrl.text==""){
                                    showMessage("Choose a month to generate payroll");
                                    return;
                                  }
                                  setState(() {
                                    _loading=true;
                                  });
                                  String status = await apiServices().generatePayroll(_selected!.month.toString(),_selected!.year.toString(),enableLOP.toString(),selectedUsers);
                                  if(status == "Success"){
                                    type="Template";
                                    await fetchData(type);
                                  }
                                  else{
                                    setState(() {
                                      _loading=false;
                                    });
                                  }
                                }, child: const Text("Create New")),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 20,),
                          // SizedBox(
                          //   width: w-70,
                          //   height: 40,
                          //   child: ElevatedButton(onPressed: (){
                          //     type="PayRoll";
                          //     fetchData(type);
                          //   }, child: const Text("Import Template")),
                          // ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                ):const SizedBox(),

                // const SizedBox(height: 20,),
                payrollList.isNotEmpty?SizedBox(
                  width: w,

                  child: Column(
                    children: [
                      Container(width: w,
                      height: 40,
                      color: AppColors.boxColor,
                      child: Center(child: Text('${DateFormat('MMM').format(DateTime(2023,payrollList[0].Month))} ${payrollList[0].Year.toString()} - $type',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          summaryField("Gross Net Pay",_totNetPay.toString()),
                          summaryField("Gross Deduction",_totDed.toString()),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          summaryField("Gross PF",_totPF.toString()),
                          summaryField("Gross ESIC",_totESIC.toString()),
                        ],
                      )
                    ],
                  ),
                ):Container(),
                const SizedBox(height: 20,),
                Expanded(
                  child: _loading?Container():payrollList.isNotEmpty?SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            // DataColumn(label: Text('Month')),
                            // DataColumn(label: Text('Year')),
                            DataColumn(label: Text('Days')),
                            DataColumn(label: Text('WorkingDays')),
                            DataColumn(label: Text('Leave Days')),
                            DataColumn(label: Text('Present Days')),
                            DataColumn(label: Text('LOP')),
                            DataColumn(label: Text('Basic')),
                            DataColumn(label: Text('HRA')),
                            DataColumn(label: Text('TA')),
                            DataColumn(label: Text('DA')),
                            DataColumn(label: Text('Incentive')),
                            DataColumn(label: Text('Gross Income')),
                            DataColumn(label: Text('PF')),
                            DataColumn(label: Text('ESIC')),
                            DataColumn(label: Text('Pro Tax')),
                            DataColumn(label: Text('Advance')),
                            DataColumn(label: Text('Gross Deduction')),
                            DataColumn(label: Text('Net Pay')),
                            // type=="Template"?const DataColumn(label: Text('Action')):const DataColumn(label: Text("")),
                          ],
                          rows: payrollList.map((model) {
                            return DataRow(
                              cells: [
                                DataCell(Text(model.Name)),
                                // DataCell(Text('${DateFormat('MMM').format(DateTime(2023,model.Month))} ${model.Year.toString()}')),
                                // DataCell(Text(model.Year.toString())),
                                DataCell(Text(model.Days.toString())),
                                DataCell(Text(model.WorkingDays.toString())),
                                DataCell(Text(model.LeaveDays.toString())),
                                DataCell(Text(model.PresentDays.toString())),
                                DataCell(Text(model.LOP.toString())),
                                DataCell(Text(model.Basic.toString())),
                                DataCell(Text(model.HRA.toString())),
                                DataCell(Text(model.TA.toString())),
                                DataCell(Text(model.DA.toString())),
                                DataCell(Text(model.Incentive.toString())),
                                DataCell(Text(model.GrossIncome.toString())),
                                DataCell(Text(model.PF.toString())),
                                DataCell(Text(model.ESIC.toString())),
                                DataCell(Text(model.ProTax.toString())),
                                DataCell(Text(model.Advance.toString())),
                                DataCell(Text(model.GrossDeduction.toString())),
                                DataCell(Text(model.NetPay.toString())),
                                // type=="Template"?DataCell(ElevatedButton(
                                //     onPressed: (){
                                //
                                // }, child: Icon(Icons.edit))):DataCell(Text("")),

                              ],
                            );
                          }).toList(),
                        )

                      ),
                    ),
                  ):const SizedBox(),
                )


              ],
            ),
          ),
          enableList?Container(
            width: w,
            height: h,
            color: Colors.grey.withOpacity(.4),
            child: Center(
              child: Container(
                width: w>h?w/2:w-20,
                height: h*.75,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: (h*.75-50),
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
                    SizedBox(
                      width:w>h?w/2:w-20,
                      height: 50,
                      child: ElevatedButton(
                        child: const Text("Done"),
                        onPressed: (){
                          setState(() {
                            enableList=false;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ):SizedBox(),
          _loading?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }


  Widget FieldArea(String title,TextEditingController ctrl,TextInputType type,bool edit){
    return SizedBox(
      // width: w>h?w/2-100:w-200,
      height: 50,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            // width: w>h?(w/2-50)*.25:w*.25,
            width: w>h?w/8:w/4,
            child: Text("$title :",style: const TextStyle(fontWeight: FontWeight.bold),),
          ),
          SizedBox(
              // width: w>h?(w/2-50)*.3:w*.3,
              width: w>h?w/8:w/3,
              child: TextFormField(

                keyboardType: type,
                enabled: edit,
                controller: ctrl,
                decoration: InputDecoration(
                  // icon: Icon(Icons.password),
                  // hintText: "Pin",

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

  Widget summaryField(String title,String value){
    return Container(
      width: w*.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.lightBlue.shade300,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            const SizedBox(height: 10,),
            Text(value,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
          ],
        ),
      ),
    );
  }




  _saveToFile()async{

    // final String directory = (await getApplicationSupportDirectory()).path;
    // final path = "$directory/";
    // print(path);
    // return;

    List<List<dynamic>> rows = [];//List<List<dynamic>>();

    rows.add(["Mobile","Name","Month","Year","Days","WorkingDays","LeaveDays","LOP","PresentDays","TotalLOP","Basic","Allowance","HRA","TA","DA","Incentive","GrossIncome","PF","ESIC","ProTax","Advance","GrossDeduction","NetPay"]);

    payrollList.forEach((element) async{
      List<dynamic> row = [];//List<dynamic>();
      row.add(element.Mobile);
      row.add(element.Name);
      row.add(element.Month);
      row.add(element.Year);
      row.add(element.Days);
      row.add(element.WorkingDays);
      row.add(element.LeaveDays);
      row.add(element.LOP);
      row.add(element.PresentDays);
      row.add(element.TotalLOP);
      row.add(element.Basic);
      row.add(element.Allowance);
      row.add(element.HRA);
      row.add(element.TA);
      row.add(element.DA);
      row.add(element.Incentive);
      row.add(element.GrossIncome);
      row.add(element.PF);
      row.add(element.ESIC);
      row.add(element.ProTax);
      row.add(element.Advance);
      row.add(element.GrossDeduction);
      row.add(element.NetPay);
      rows.add(row);
    });

    String csv = const ListToCsvConverter().convert(rows);

    // var filePath="";
    var fileName = 'Payroll-${DateFormat('MMM').format(DateTime(2023,payrollList[0].Month))} ${payrollList[0].Year.toString()}-${DateTime.timestamp().microsecond}.csv';

    String status = await savefile().downloadCSVFile(fileName, csv);
    showMessage(status);

    // String directoryPath;
    // if (Platform.isAndroid) {
    //   filePath = '/storage/emulated/0/Download/$fileName';
    // } else if (Platform.isIOS) {
    //   directoryPath = (await getApplicationDocumentsDirectory()).path;
    //   filePath='$directoryPath/$fileName';
    // } else {
    //   throw UnsupportedError('Unsupported platform');
    // }
    //
    // final file = File(filePath);
    // print(file.path);

    // await file.writeAsString(csv).whenComplete((){
    //   showDialog(context: context,
    //       builder: (BuildContext context)=>AlertDialog(
    //         title: const Text("Success"),
    //         content: const Text("File saved successfully"),
    //         actions: [
    //           TextButton(
    //             onPressed: () async{
    //
    //               Navigator.of(context).pop();
    //             },
    //             child: Container(
    //               color: Colors.green,
    //               padding: const EdgeInsets.all(14),
    //               child: const Text("OK",style: TextStyle(color: Colors.black),),
    //             ),
    //           ),
    //         ],
    //       ));
    // });

  }



  _processFile()async{
    // print("executing process file Method");

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _loading=true;
      });
      File file = File(result.files.single.path!);

      String csvString = await File(file.path).readAsString();
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);

      // Assuming the first row of CSV contains headers
      List<Map<String, dynamic>> jsonData = [];

      List<String> headers = List.from(csvTable[0]);
      for (var i = 1; i < csvTable.length; i++) {
        var row = csvTable[i];
        Map<String, dynamic> data = {};
        for (var j = 0; j < headers.length; j++) {
          data[headers[j]] = row[j];
        }
        jsonData.add(data);
      }

      String jsonString = jsonEncode(jsonData);
      // print(jsonString);
      String status = await apiServices().importPayRoll(jsonString);
      // print(status);
      fetchData("Template");
      showMessage(status);

    } else {
      return;
    }
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

}

