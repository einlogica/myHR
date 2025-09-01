import 'dart:convert';

import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithCalendar.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithDropDown.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

class addEmployeePage extends StatefulWidget {

  final String mobile;
  final String name;
  final String employer;
  // final String permission;

  const addEmployeePage({super.key,required this.mobile,required this.name,required this.employer});

  @override
  State<addEmployeePage> createState() => _addEmployeePageState();
}

class _addEmployeePageState extends State<addEmployeePage> {

  var w=0.00,h=0.00,t=0.00;
  List<userModel> managerList =[];
  List<String> manageridList = ["Select"];
  bool _loading=false;

  String dropdownvalue = 'Select';
  int dropIndex =0;

  String dropdownUser = 'User';
  List<String> users =['User','Manager','Admin'];

  String dropdownSex = 'Others';
  List<String> sex =['Others','Female','Male'];

  String dropdownblood = 'Select';
  List<String> blood =['Select','A+','A-','B+','B-','O+','O-','AB+','AB-'];

  String dropdownDep = 'Select';
  String dropdownPos = 'Select';
  List<String> departments =['Select'];
  List<String> positions =['Select'];

  final TextEditingController _nameCtrl= TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _employeeidCtrl = TextEditingController();
  final TextEditingController _dojCtrl = TextEditingController();
  final TextEditingController _positionCtrl = TextEditingController();
  final TextEditingController _departmentCtrl = TextEditingController();
  final TextEditingController _leaveCtrl = TextEditingController();

  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController sexCtrl = TextEditingController();
  final TextEditingController adl1Ctrl = TextEditingController();
  final TextEditingController adl2Ctrl = TextEditingController();
  final TextEditingController adl3Ctrl = TextEditingController();
  final TextEditingController zipCtrl = TextEditingController();
  final TextEditingController bgCtrl = TextEditingController();
  final TextEditingController emNameCtrl = TextEditingController();
  final TextEditingController emNumCtrl = TextEditingController();
  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController accNumCtrl = TextEditingController();
  final TextEditingController panCtrl = TextEditingController();

  bool admin =false;
  // TextEditingController _kmCtrl = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _employeeidCtrl.dispose();
    _dojCtrl.dispose();
    _positionCtrl.dispose();
    _departmentCtrl.dispose();
    _leaveCtrl.dispose();
    dobCtrl.dispose();
    sexCtrl.dispose();
    adl1Ctrl.dispose();
    adl2Ctrl.dispose();
    adl3Ctrl.dispose();
    zipCtrl.dispose();
    bgCtrl.dispose();
    emNameCtrl.dispose();
    emNumCtrl.dispose();
    bankNameCtrl.dispose();
    accNumCtrl.dispose();
    panCtrl.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData("MANAGERLIST");
  }

  fetchData(String filter)async{
      managerList=await apiServices().getUserDetails("",filter);
      manageridList.clear();
      manageridList.add("Select");
      for(var d in managerList){
        // print(d.Name);
        manageridList.add("${d.Name} - ${d.EmployeeID}");
      }
      departments=await apiServices().getDepartments(widget.mobile);
      positions=await apiServices().getPositions(widget.mobile);
      setState(() {

      });
  }



  updateDropDown(String title,String value){
    if(title=="Manager"){
      dropIndex = manageridList.indexOf(value);
      dropdownvalue = value;
    }
    else if(title=="Permission"){
      dropdownUser=value;
    }
    else if(title=="Sex"){
      dropdownSex=value;
    }
    else if(title=="Blood Group"){
      dropdownblood=value;
    }
    else if(title=="Department"){
      dropdownDep=value;
    }
    else if(title=="Position"){
      dropdownPos=value;
    }
  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;


    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                            const Text("Employee On-boarding",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
                // const SizedBox(height: 10,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                      Container(
                        width: w,
                        height: 40,
                        color: AppColors.appBarColor,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 80,),
                            Text("Official Information",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                            SizedBox(
                              width: 80,
                              height: 40,
                              // child: Icon(Icons.edit,color: AppColors.buttonColorDark,size: 20,),
                            )
                          ],
                        ),
                      ),
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: w>h?w/2:w,
                          child: Column(
                            children: [
                              FieldArea(title: "Name",ctrl: _nameCtrl,type: TextInputType.text,len:20),
                              FieldArea(title: "Mobile",ctrl: _mobileCtrl,type: TextInputType.number,len:10),
                              FieldArea(title: "Employee ID",ctrl: _employeeidCtrl,type: TextInputType.text,len:10),
                              FieldArea(title: "Email",ctrl: _emailCtrl,type: TextInputType.text,len:49),
                              // FieldArea(title: "Department",ctrl: _departmentCtrl,type: TextInputType.text,len:20),
                              FieldArea(title: "Leave Count",ctrl: _leaveCtrl,type: TextInputType.number,len:5),
                              FieldAreaWithCalendar(title: "Date of Joining",ctrl: _dojCtrl,type: TextInputType.datetime,days:24000,fdays: 0,),
                              FieldAreaWithDropDown(title: "Department",dropList: departments,dropdownValue: dropdownDep,callback: updateDropDown,),
                              FieldAreaWithDropDown(title: "Position",dropList: positions,dropdownValue: dropdownPos,callback: updateDropDown,),
                              FieldAreaWithDropDown(title: "Manager",dropList: manageridList,dropdownValue: dropdownvalue,callback: updateDropDown,),
                              FieldAreaWithDropDown(title: "Permission",dropList: users,dropdownValue: dropdownUser,callback: updateDropDown,),
                            ],
                          ),
                        ),


                        const SizedBox(height: 20,),
                        Container(
                          width: w,
                          height: 40,
                          color: AppColors.appBarColor,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 80,),
                              Text("Personal Information",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              SizedBox(
                                width: 80,
                                height: 40,
                                // child: Icon(Icons.edit,color: AppColors.buttonColorDark,size: 20,),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: w>h?w/2:w,
                          child: Column(
                            children: [
                              FieldAreaWithDropDown(title: "Sex",dropList: sex,dropdownValue: dropdownSex,callback: updateDropDown,),
                              FieldAreaWithDropDown(title: "Blood Group",dropList: blood,dropdownValue: dropdownblood,callback: updateDropDown,),
                              FieldAreaWithCalendar(title: "Date of Birth",ctrl: dobCtrl,type: TextInputType.datetime,days:24000,fdays: 0,),
                              FieldArea(title: "Address Line 1",ctrl: adl1Ctrl,type: TextInputType.text,len:50),
                              FieldArea(title: "Address Line 2",ctrl: adl2Ctrl,type: TextInputType.text,len:50),
                              FieldArea(title: "Address Line 3",ctrl: adl3Ctrl,type: TextInputType.text,len:50),
                              FieldArea(title: "Zip Code",ctrl: zipCtrl,type: TextInputType.number,len:6),
                              FieldArea(title: "Emergency Contact Name",ctrl: emNameCtrl,type: TextInputType.text,len:20),
                              FieldArea(title: "Emergency Contact Number",ctrl: emNumCtrl,type: TextInputType.number,len:10),
                              FieldArea(title: "Bank Name",ctrl: bankNameCtrl,type: TextInputType.text,len:50),
                              FieldArea(title: "Account Number",ctrl: accNumCtrl,type: TextInputType.number,len:30),
                              FieldArea(title: "PAN",ctrl: panCtrl,type: TextInputType.text,len:15),
                            ],
                          ),
                        ),



                        const SizedBox(height: 10,),
                        SizedBox(
                          width: w,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width:w/3,
                                height: 40,
                                child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blueAccent)),
                                    onPressed: (){
                                      clearFields();
                                      Navigator.pop(context);
                                }, child: const Text("Back",style: TextStyle(color: Colors.white),)),
                              ),
                              SizedBox(
                                width: w/3,
                                height: 40,
                                child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blueAccent)),
                                    onPressed: ()async{

                                      // print(dropdownSex);
                                      if(_mobileCtrl.text.length!=10){
                                        showMessage("Invalid Mobile Number");
                                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Mobile Number")));
                                        return;
                                      }

                                      if(dropIndex==0){
                                        showMessage("Choose valid Manager");
                                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Mobile Number")));
                                        return;
                                      }

                                      setState(() {
                                        _loading=true;
                                      });

                                      Map<String,dynamic> newUser = {"Mobile": _mobileCtrl.text, "Name": _nameCtrl.text, "Email":_emailCtrl.text,"EmployeeID": _employeeidCtrl.text,"Employer":widget.employer, "Department": dropdownDep,
                                          "Position": dropdownPos, "Permission": dropdownUser, "Manager": managerList[dropIndex-1].Name, "ManagerID": managerList[dropIndex-1].EmployeeID,
                                          "LeaveCount": double.parse(_leaveCtrl.text),"DOJ":_dojCtrl.text,"Sex":dropdownSex,"DOB":dobCtrl.text,"AL1":adl1Ctrl.text,"AL2":adl2Ctrl.text,"AL3":adl3Ctrl.text,
                                      "Zip":zipCtrl.text,"BG":dropdownblood,"EmName":emNameCtrl.text,"EmNum":emNumCtrl.text,"BankName":bankNameCtrl.text,"AccNo":accNumCtrl.text,"PAN":panCtrl.text};
                                      // print(newUser.toString());
                                      var status = await apiServices().addUser(newUser);
                                      // print(status);
                                      var data = jsonDecode(status);
                                      showMessage(data['Mess']);
                                      if(data['Status']=="Success"){
                                        clearFields();
                                      }

                                      setState(() {
                                        _loading=false;
                                      });

                                    }, child: const Text("Submit",style: TextStyle(color: Colors.white),)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,)

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          _loading?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }


  void clearFields(){
    dropdownvalue="Select";
    _nameCtrl.clear();
    _mobileCtrl.clear();
    _employeeidCtrl.clear();
    _positionCtrl.clear();
    _departmentCtrl.clear();
    dropdownvalue="Select";
    _leaveCtrl.clear();
    dropdownUser="User";

    _dojCtrl.clear();
    dropdownSex="Others";
    dropdownblood="Select";
    adl1Ctrl.clear();
    adl2Ctrl.clear();
    adl3Ctrl.clear();
    zipCtrl.clear();
    bgCtrl.clear();
    emNameCtrl.clear();
    emNumCtrl.clear();
    bankNameCtrl.clear();
    accNumCtrl.clear();
    panCtrl.clear();
    setState(() {

    });

  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }


}

