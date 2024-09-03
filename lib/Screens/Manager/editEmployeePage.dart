import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:einlogica_hr/Models/advanceModel.dart';
import 'package:einlogica_hr/Models/payRollModel.dart';
import 'package:einlogica_hr/Models/personalInfoModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithCalendar.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithDropDown.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

class editEmployeePage extends StatefulWidget {

  // final String mobile;
  // final String name;
  // final String permission;
  final userModel User;
  final personalInfoModel PersonalInfo;
  final Function callback;
  // final Function callback;

  const editEmployeePage({super.key,required this.User,required this.PersonalInfo,required this.callback});

  @override
  State<editEmployeePage> createState() => _editEmployeePageState();
}

class _editEmployeePageState extends State<editEmployeePage> {

  var w=0.00,h=0.00,t=0.00;

  bool progressIndicator=true;
  bool basicEdit = false;
  bool salaryEdit = false;
  bool advanceEdit = false;
  bool personalEdit= false;
  bool showBasic = false;
  bool showPersonal = false;
  bool showSalary = false;
  // bool showAdvance = false;

  // advanceModel advanceData = advanceModel(mobile: "", name: "", amount: "", date: "", emi: "", startdate: "", balance: "", status: "");
  userModel currentUser = userModel(Mobile: "", Name: "", EmployeeID: "", Employer: "",Department: "", Position: "", Permission: "", Manager: "", ManagerID: "", DOJ: "", LeaveCount: 0, Status: "", ImageFile: "");
  payRollModel paySlip = payRollModel(Mobile: "", Name: "",Month: 0,Year: 0, Days: 0, WorkingDays: 0, LeaveDays: 0, LOP: 0, PresentDays: 0,TotalLOP: 0, Basic: 0, Allowance: 0, HRA: 0, TA: 0, DA: 0, Incentive: 0, GrossIncome: 0, PF: 0, ESIC: 0, ProTax: 0, Advance: 0, GrossDeduction: 0, NetPay: 0);
  personalInfoModel personalInfo = personalInfoModel(ID: 0, Name: "", Mobile: "", Sex: "", DOB: "", AddL1: "", AddL2: "", AddL3: "", Zip: "", BloodGroup: "", EmContactName: "", EmContactNum: "", BankName: "", AccNum: "",UAN: "",PAN: "",ESICNo: "");

  String dropdownSex = 'Select';
  List<String> sex =['Select','Others','Female','Male'];

  String dropdownblood = 'Select';
  List<String> blood =['Select','A+','A-','B+','B-','O+','O-','AB+','AB-'];

  // Define controllers for text input fields
  // TextEditingController _nameCtrl = TextEditingController();
  // TextEditingController _mobileCtrl = TextEditingController();
  // TextEditingController _empIdCtrl = TextEditingController();
  final TextEditingController _managerCtrl = TextEditingController();
  final TextEditingController _positionCtrl = TextEditingController();
  final TextEditingController _departmentCtrl = TextEditingController();
  final TextEditingController _dojCtrl = TextEditingController();
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
  final TextEditingController uanCtrl = TextEditingController();
  final TextEditingController panCtrl = TextEditingController();
  final TextEditingController esicNumCtrl = TextEditingController();

  final TextEditingController _basicCtrl = TextEditingController();
  final TextEditingController _specialCtrl = TextEditingController();
  final TextEditingController _hraCtrl = TextEditingController();
  final TextEditingController _taCtrl = TextEditingController();
  final TextEditingController _daCtrl = TextEditingController();
  final TextEditingController _incentiveCtrl = TextEditingController();
  final TextEditingController _grossCtrl = TextEditingController();
  final TextEditingController _pfCtrl = TextEditingController();
  final TextEditingController _esicCtrl = TextEditingController();
  final TextEditingController _proTaxCtrl = TextEditingController();

  // final TextEditingController _amountCtrl = TextEditingController();
  // final TextEditingController _emiCtrl = TextEditingController();
  // final TextEditingController _startdateCtrl = TextEditingController();


  List<userModel> managerList =[];
  List<String> manageridList = ["Select"];
  List<String> departmentList = ["Select"];
  List<String> positionList = ["Select"];
  String dropdownvalue = 'Select';
  int dropIndex =0;
  String dropdownUser = 'User';
  String dropdownPosition='Select';
  String dropdownDepartment='Select';
  List<String> users =['User','Manager','Admin'];

  @override
  void dispose() {
    _managerCtrl.dispose();
    _positionCtrl.dispose();
    _departmentCtrl.dispose();
    _dojCtrl.dispose();
    _leaveCtrl.dispose();
    _basicCtrl.dispose();
    _specialCtrl.dispose();
    _hraCtrl.dispose();
    _taCtrl.dispose();
    _daCtrl.dispose();
    _incentiveCtrl.dispose();
    _grossCtrl.dispose();
    _pfCtrl.dispose();
    _esicCtrl.dispose();
    _proTaxCtrl.dispose();
    // _amountCtrl.dispose();
    // _emiCtrl.dispose();
    // _startdateCtrl.dispose();

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
    uanCtrl.dispose();
    panCtrl.dispose();
    esicNumCtrl.dispose();
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("ManagerID:");
    // print(widget.currentUser.ManagerID);
    currentUser=widget.User;
    personalInfo=widget.PersonalInfo;
    // fetchData("MANAGER");
    fetchAll();
  }

  fetchAll()async{
    await fetchData("MANAGER");
    departmentList=await apiServices().getDepartments(widget.User.Mobile);
    positionList=await apiServices().getPositions(widget.User.Mobile);
    if(departmentList.contains(currentUser.Department)){
      dropdownDepartment=currentUser.Department;
    }
    if(positionList.contains(currentUser.Position)){
      dropdownPosition=currentUser.Position;
    }
    progressIndicator=false;
    setState(() {

    });
  }

  // fetchRest()async{
  //   await fetchSalary();
  //   await fetchAdvance();
  //   await fetchPersonal();
  //   await setDefault();
  // }


  fetchPersonal()async{

    personalInfo = await apiServices().checkPersonalInfo(widget.User.Mobile);

    setState(() {

    });
  }

  fetchUser(String mobile)async{
    List<userModel> userList = await apiServices().getUserDetails(mobile,"ONE");
    // print("length = ${userList.length}");
    currentUser =userList[0];

  }

  fetchData(String filter)async{
    managerList=await apiServices().getUserDetails(widget.User.Mobile,"MANAGERLIST");
    manageridList.clear();
    manageridList.add("Select");
    for(var d in managerList){
      // print(d.Name);
      manageridList.add("${d.Name} - ${d.EmployeeID}");
    }

  }

  fetchSalary()async{
    if(paySlip.Name==""){
      paySlip = await apiServices().getSalaryStructure(widget.User.Mobile);
    }
    setState(() {

    });

  }


  // fetchAdvance()async{
  //   // if(advanceData.name==""){
  //   //   advanceData = await apiServices().getAdvanceDetails(widget.User.Mobile);
  //   // }
  //   advanceData = await apiServices().getAdvanceDetails(widget.User.Mobile);
  //   setState(() {
  //
  //   });
  // }

  setDefault(){
    // print("Setting all defaults");
    basicEdit=false;
    salaryEdit=false;
    advanceEdit=false;
    personalEdit=false;

    _managerCtrl.text=currentUser.Manager;
    _positionCtrl.text=currentUser.Position;
    _departmentCtrl.text=currentUser.Department;
    _leaveCtrl.text=currentUser.LeaveCount.toString();
    _dojCtrl.text=currentUser.DOJ;
    // dropIndex=manageridList.indexOf("${currentUser.Manager} - ${currentUser.ManagerID}");
    // print("${currentUser.Manager} - ${currentUser.ManagerID}");
    dropdownvalue = "${currentUser.Manager} - ${currentUser.ManagerID}";
    dropIndex=manageridList.indexOf(dropdownvalue);
    dropdownUser = currentUser.Permission;
    dropdownblood = personalInfo.BloodGroup==""?'Select':personalInfo.BloodGroup;
    dropdownSex = personalInfo.Sex==""?'Select':personalInfo.Sex;

    sexCtrl.text = personalInfo.Sex;
    dobCtrl.text = personalInfo.DOB;
    adl1Ctrl.text = personalInfo.AddL1;
    adl2Ctrl.text = personalInfo.AddL2;
    adl3Ctrl.text = personalInfo.AddL3;
    zipCtrl.text = personalInfo.Zip;
    bgCtrl.text = personalInfo.BloodGroup;
    emNameCtrl.text = personalInfo.EmContactName;
    emNumCtrl.text = personalInfo.EmContactNum;
    bankNameCtrl.text = personalInfo.BankName;
    accNumCtrl.text = personalInfo.AccNum;
    uanCtrl.text = personalInfo.UAN;
    panCtrl.text = personalInfo.PAN;
    esicNumCtrl.text = personalInfo.ESICNo;


    _basicCtrl.text=paySlip.Basic.toString();
    _specialCtrl.text=paySlip.Allowance.toString();
    _hraCtrl.text=paySlip.HRA.toString();
    _taCtrl.text=paySlip.TA.toString();
    _daCtrl.text=paySlip.DA.toString();
    _incentiveCtrl.text=paySlip.Incentive.toString();
    _grossCtrl.text=(paySlip.Basic+paySlip.Allowance+paySlip.HRA+paySlip.TA+paySlip.DA+paySlip.Incentive).toString();
    _pfCtrl.text=paySlip.PF.toString();
    _esicCtrl.text=paySlip.ESIC.toString();
    _proTaxCtrl.text=paySlip.ProTax.toString();

    // _amountCtrl.clear();
    // _emiCtrl.clear();
    // _startdateCtrl.clear();
  }

  updateDropDown(String title,String value){
    if(title=="Manager"){
      dropIndex = manageridList.indexOf(value);
      dropdownvalue=value;
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
      dropdownDepartment=value;
    }
    else if(title=="Position"){
      dropdownPosition=value;
    }
  }



  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;



    // Define a variable to store the image path
    // String imagePath = 'assets/profile.png'; // Replace this with your default image path


    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SizedBox(
            width: w,
            // height: h,
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
                            const Text("Employee Details",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
                    child: Column(
                      children: [
                        // const SizedBox(height: 20,),
                        Container(
                          width: w,
                          height: 40,
                          color: AppColors.appBarColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 80,),
                              const Text("Basic Information",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              showBasic?InkWell(
                                onTap: (){
                                  setState(() {
                                    basicEdit=true;
                                    personalEdit=false;
                                    salaryEdit=false;
                                    advanceEdit=false;
                                  });
                                },
                                child: const SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Center(child: Icon(Icons.edit,color: AppColors.buttonColorDark,size: 20,)),
                                ),
                              ):InkWell(
                                onTap: ()async{

                                  setState((){
                                    progressIndicator=true;
                                  });

                                  // await fetchPersonal();
                                  await setDefault();

                                  setState((){
                                    progressIndicator=false;
                                    showBasic=true;
                                    showPersonal=false;
                                    showSalary=false;
                                    // showAdvance=false;
                                  });


                                },
                                child: const SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Icon(Icons.arrow_drop_down_circle_outlined,color: AppColors.buttonColorDark,size: 20,),
                                ),
                              )
                            ],
                          ),
                        ),
                        showBasic?SizedBox(
                          child: Column(
                            children: [
                              buildText("Name",currentUser.Name),
                              buildText("Mobile",currentUser.Mobile),
                              buildText("Employee ID",currentUser.EmployeeID),
                              //basic edit
                              basicEdit?FieldAreaWithDropDown(title: "Manager", dropList: manageridList, dropdownValue: dropdownvalue,callback: updateDropDown,):buildText("Manager", currentUser.Manager),
                              // basicEdit?FieldArea(title: "Position",ctrl: _positionCtrl,type: TextInputType.text,len:20):buildText("Position", currentUser.Position,),
                              basicEdit?FieldAreaWithDropDown(title: "Department", dropList: departmentList, dropdownValue: dropdownDepartment, callback: updateDropDown):buildText("Department", currentUser.Department,),
                              // basicEdit?FieldArea(title: "Department",ctrl: _departmentCtrl,type: TextInputType.text,len:20):buildText("Department", currentUser.Department),
                              basicEdit?FieldAreaWithDropDown(title: "Position", dropList: positionList, dropdownValue: dropdownPosition, callback: updateDropDown):buildText("Position", currentUser.Position,),
                              basicEdit?FieldAreaWithDropDown(title: "Permission", dropList: users, dropdownValue: dropdownUser,callback: updateDropDown):buildText("Permission", currentUser.Permission),
                              basicEdit?FieldAreaWithCalendar(title: "DOJ",ctrl: _dojCtrl,type: TextInputType.datetime,days:24000):buildText("DOJ", currentUser.DOJ),
                              basicEdit?FieldArea(title: "Leave Count",ctrl: _leaveCtrl,type: TextInputType.number,len:5):buildText("Leave Count", currentUser.LeaveCount.toString()),

                              const SizedBox(height: 10,),
                              basicEdit?SizedBox(
                                width: w,
                                // height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width:w/2-5,
                                      height: 60,
                                      color: Colors.blue.shade100,
                                      child: TextButton(onPressed: ()async{
                                        // print(dropdownDepartment);
                                        setState(() {
                                          progressIndicator=true;
                                        });
                                        String status = await apiServices().updateBasicDetails(managerList[dropIndex-1].Name, managerList[dropIndex-1].EmployeeID, dropdownPosition, dropdownDepartment, dropdownUser,widget.User.Mobile,_dojCtrl.text,_leaveCtrl.text);
                                        await fetchUser(widget.User.Mobile);
                                        showMessage(status);
                                        await setDefault();
                                        await widget.callback();
                                        setState(() {
                                          progressIndicator=false;
                                        });
                                      }, child: const Text("Save")),
                                    ),

                                    Container(
                                      width: w/2-5,
                                      height: 60,
                                      color: Colors.blue.shade100,
                                      child: TextButton(onPressed: (){
                                        setDefault();
                                        setState(() {
                                          basicEdit=false;
                                        });
                                      }, child: const Text("Cancel")),
                                    ),
                                  ],
                                ),
                              ):const SizedBox(),
                            ],
                          ),
                        ):SizedBox(),

                        const SizedBox(height: 20,),
                        Container(
                          width: w,
                          height: 40,
                          color: AppColors.appBarColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(width: 80,),
                              const Text("Personal Information",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              showPersonal?InkWell(
                                onTap: (){
                                  setState(() {
                                    personalEdit=true;
                                    basicEdit=false;
                                    salaryEdit=false;
                                    advanceEdit=false;
                                  });
                                },
                                child: const SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Icon(Icons.edit,color: AppColors.buttonColorDark,size: 20,),
                                ),
                              ):InkWell(
                                onTap: ()async{

                                  setState((){
                                    progressIndicator=true;
                                  });

                                  // await fetchPersonal();
                                  await setDefault();

                                  setState((){
                                    progressIndicator=false;
                                    showBasic=false;
                                    showPersonal=true;
                                    showSalary=false;
                                    // showAdvance=false;
                                  });


                                },
                                child: const SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Icon(Icons.arrow_drop_down_circle_outlined,color: AppColors.buttonColorDark,size: 20,),
                                ),
                              )
                            ],
                          ),
                        ),
                        // const SizedBox(height: 10,),
                        showPersonal?SizedBox(
                          child: Column(
                            children: [
                              personalEdit?FieldAreaWithCalendar(title:"DOB",ctrl:dobCtrl,type:TextInputType.datetime,days:24000):buildText("DOB", personalInfo.DOB.toString()),
                              personalEdit?FieldAreaWithDropDown(title: "Sex",dropList: sex,dropdownValue: dropdownSex,callback: updateDropDown):buildText("Sex", personalInfo.Sex.toString()),
                              personalEdit?FieldAreaWithDropDown(title: "Blood Group",dropList: blood,dropdownValue: dropdownblood,callback: updateDropDown):buildText("Blood Group", personalInfo.BloodGroup.toString()),
                              personalEdit?FieldArea(title: "Address Line 1", ctrl: adl1Ctrl, type: TextInputType.text,len:50):buildText("Address", personalInfo.AddL1.toString()),
                              personalEdit?FieldArea(title: "Address Line 2", ctrl: adl2Ctrl, type: TextInputType.text,len:50):buildText("", personalInfo.AddL2.toString()),
                              personalEdit?FieldArea(title: "Address Line 3", ctrl: adl3Ctrl, type: TextInputType.text,len:50):buildText("", personalInfo.AddL3.toString()),
                              personalEdit?FieldArea(title: "Zip Code", ctrl: zipCtrl, type: TextInputType.number,len:6):buildText("Zip Code", personalInfo.Zip.toString()),
                              personalEdit?FieldArea(title: "Emg Contact Name", ctrl: emNameCtrl, type: TextInputType.text,len:20):buildText("Emg Name", personalInfo.EmContactName.toString()),
                              personalEdit?FieldArea(title: "Emg Contact Num", ctrl: emNumCtrl, type: TextInputType.number,len:10):buildText("Emg Num", personalInfo.EmContactNum.toString()),
                              personalEdit?FieldArea(title: "Bank Name", ctrl: bankNameCtrl, type: TextInputType.text,len:50):buildText("Bank Name", personalInfo.BankName.toString()),
                              personalEdit?FieldArea(title: "Account Num", ctrl: accNumCtrl, type: TextInputType.number,len:30):buildText("Account Num", personalInfo.AccNum.toString()),
                              personalEdit?FieldArea(title: "PAN", ctrl: panCtrl, type: TextInputType.text,len:15):buildText("PAN", personalInfo.PAN.toString()),
                              personalEdit?FieldArea(title: "UAN", ctrl: uanCtrl, type: TextInputType.number,len:30):buildText("UAN", personalInfo.UAN.toString()),
                              personalEdit?FieldArea(title: "ESI No", ctrl: esicNumCtrl, type: TextInputType.text,len:15):buildText("ESI No", personalInfo.ESICNo.toString()),

                              const SizedBox(height: 10,),
                              personalEdit?SizedBox(
                                width: w,
                                // height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    Container(
                                      width:w/2-5,
                                      height: 60,
                                      color: Colors.blue.shade100,
                                      child: TextButton(onPressed: ()async{
                                        setState(() {
                                          progressIndicator=true;
                                        });
                                        Map<String,dynamic> newUser = {"Mobile":widget.User.Mobile,"Sex":dropdownSex,"DOB":dobCtrl.text,"AL1":adl1Ctrl.text,"AL2":adl2Ctrl.text,"AL3":adl3Ctrl.text,
                                          "Zip":zipCtrl.text,"BG":dropdownblood,"EmName":emNameCtrl.text,"EmNum":emNumCtrl.text,"BankName":bankNameCtrl.text,"AccNo":accNumCtrl.text,"PAN":panCtrl.text,"UAN":uanCtrl.text,"ESI":esicNumCtrl.text};
                                        String status = await apiServices().updatePersonalInfo(newUser);
                                        showMessage(status);
                                        await fetchPersonal();
                                        await widget.callback();
                                        await setDefault();
                                        setState(() {
                                          progressIndicator=false;
                                        });
                                      }, child: const Text("Save")),
                                    ),

                                    Container(
                                      width: w/2-5,
                                      height: 60,
                                      color: Colors.blue.shade100,
                                      child: TextButton(onPressed: (){
                                        setDefault();
                                        setState(() {
                                          personalEdit=false;
                                        });
                                      }, child: const Text("Cancel")),
                                    ),

                                  ],
                                ),
                              ):const SizedBox(),
                            ],
                          ),
                        ):const SizedBox(),


                        const SizedBox(height: 20,),
                        Container(
                          width: w,
                          height: 40,
                          color: AppColors.appBarColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(width: 80,),
                              const Text("Salary Information",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              showSalary?InkWell(
                                onTap: (){
                                  setState(() {
                                    basicEdit=false;
                                    salaryEdit=true;
                                    advanceEdit=false;
                                    personalEdit=false;
                                  });
                                },
                                child: const SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Icon(Icons.edit,color: AppColors.buttonColorDark,size: 20,),
                                ),
                              ):InkWell(
                                onTap: ()async{

                                  setState((){
                                    progressIndicator=true;
                                  });

                                  await fetchSalary();
                                  await setDefault();

                                  setState((){
                                    progressIndicator=false;
                                    showBasic=false;
                                    showPersonal=false;
                                    showSalary=true;
                                    // showAdvance=false;
                                  });


                                },
                                child: const SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Icon(Icons.arrow_drop_down_circle_outlined,color: AppColors.buttonColorDark,size: 20,),
                                ),
                              )
                            ],
                          ),
                        ),
                        showSalary?SizedBox(
                          child: Column(
                            children: [
                              salaryEdit?FieldArea(title: "Basic",ctrl: _basicCtrl,type: TextInputType.number,len:6):buildText("Basic", paySlip.Basic.toString()),
                              salaryEdit?FieldArea(title: "Special",ctrl: _specialCtrl,type: TextInputType.number,len:6):buildText("Special", paySlip.Allowance.toString()),
                              salaryEdit?FieldArea(title: "HRA",ctrl: _hraCtrl,type: TextInputType.number,len:6):buildText("HRA", paySlip.HRA.toString()),
                              salaryEdit?FieldArea(title: "TA",ctrl: _taCtrl,type: TextInputType.number,len:6):buildText("TA", paySlip.TA.toString()),
                              salaryEdit?FieldArea(title: "DA",ctrl: _daCtrl,type: TextInputType.number,len:6):buildText("DA", paySlip.DA.toString()),
                              salaryEdit?FieldArea(title: "Incentive",ctrl: _incentiveCtrl,type: TextInputType.number,len:6):buildText("Incentive", paySlip.Incentive.toString()),
                              salaryEdit?const SizedBox():buildText("Gross Income", _grossCtrl.text.toString()),
                              salaryEdit?FieldArea(title: "PF(%)",ctrl: _pfCtrl,type: TextInputType.number,len:5):buildText("PF(%)", paySlip.PF.toString()),
                              salaryEdit?FieldArea(title: "ESIC(%)",ctrl: _esicCtrl,type: TextInputType.number,len:5):buildText("ESIC(%)", paySlip.ESIC.toString()),
                              salaryEdit?FieldArea(title: "ProTax",ctrl: _proTaxCtrl,type: TextInputType.number,len:5):buildText("ProTax", paySlip.ProTax.toString()),
                              const SizedBox(height: 10,),
                              salaryEdit?SizedBox(
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
                                        setState(() {
                                          progressIndicator=true;
                                        });
                                        String status = await apiServices().updateSalary(widget.User.Mobile,_basicCtrl.text,_specialCtrl.text,_hraCtrl.text,_taCtrl.text,
                                            _daCtrl.text,_incentiveCtrl.text,_pfCtrl.text,_esicCtrl.text,_proTaxCtrl.text);
                                        showMessage(status);
                                        await fetchSalary();
                                        await setDefault();
                                        setState(() {
                                          progressIndicator=false;
                                        });
                                      }, child: const Text("Save")),
                                    ),

                                    Container(
                                      width: w/2-5,
                                      height: 60,
                                      color: Colors.blue.shade100,
                                      child: TextButton(onPressed: (){
                                        setDefault();
                                        setState(() {
                                          salaryEdit=false;
                                        });
                                      }, child: const Text("Cancel")),
                                    ),

                                  ],
                                ),
                              ):Container(),
                            ],
                          ),
                        ):const SizedBox(),

                        // const SizedBox(height: 20,),
                        // Container(
                        //   width: w,
                        //   height: 40,
                        //   color: AppColors.appBarColor,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Container(width: 80,),
                        //       const Text("Salary Advance",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        //       showAdvance?InkWell(
                        //         onTap: (){
                        //           setState(() {
                        //             basicEdit=false;
                        //             salaryEdit=false;
                        //             advanceEdit=true;
                        //             personalEdit=false;
                        //           });
                        //         },
                        //         child: const SizedBox(
                        //           width: 80,
                        //           height: 40,
                        //           child: Icon(Icons.add,color: AppColors.buttonColorDark,size: 20,),
                        //         ),
                        //       ):InkWell(
                        //         onTap: ()async{
                        //
                        //           setState((){
                        //             progressIndicator=true;
                        //           });
                        //
                        //           await fetchAdvance();
                        //           await setDefault();
                        //
                        //           setState((){
                        //             progressIndicator=false;
                        //             showBasic=false;
                        //             showPersonal=false;
                        //             showSalary=false;
                        //             showAdvance=true;
                        //           });
                        //
                        //
                        //         },
                        //         child: const SizedBox(
                        //           width: 80,
                        //           height: 40,
                        //           child: Icon(Icons.arrow_drop_down_circle_outlined,color: AppColors.buttonColorDark,size: 20,),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // showAdvance?SizedBox(
                        //   child: Column(
                        //     children: [
                        //       buildText("Advance", advanceData.amount.toString()),
                        //       buildText("EMI", advanceData.emi.toString()),
                        //       buildText("Start Date", advanceData.startdate.toString()),
                        //       advanceEdit?FieldArea(title: "Advance",ctrl: _amountCtrl,type: TextInputType.number,len:6):const SizedBox(),
                        //       advanceEdit?FieldArea(title: "EMI",ctrl: _emiCtrl,type: TextInputType.number,len:6):const SizedBox(),
                        //       advanceEdit?FieldAreaWithCalendar(title: "Start Date", ctrl: _startdateCtrl, type: TextInputType.datetime,days: 60,):const SizedBox(),
                        //
                        //       const SizedBox(height: 20,),
                        //       advanceEdit?SizedBox(
                        //         width: w,
                        //         // height: 40,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             Container(
                        //               width:w/2-5,
                        //               height: 60,
                        //               color: Colors.blue.shade100,
                        //               child: TextButton(onPressed: ()async{
                        //                 setState(() {
                        //                   progressIndicator=true;
                        //                 });
                        //                 String status = await apiServices().addAdvance(widget.User.Name, widget.User.Mobile, _amountCtrl.text, _emiCtrl.text, _startdateCtrl.text);
                        //                 // print(status);
                        //                 showMessage(status);
                        //
                        //                 await fetchAdvance();
                        //                 await setDefault();
                        //                 setState(() {
                        //                   progressIndicator=false;
                        //                 });
                        //               }, child: const Text("Save")),
                        //             ),
                        //
                        //             Container(
                        //               width: w/2-5,
                        //               height: 60,
                        //               color: Colors.blue.shade100,
                        //               child: TextButton(onPressed: (){
                        //                 setDefault();
                        //                 setState(() {
                        //                   advanceEdit=false;
                        //                 });
                        //               }, child: const Text("Cancel")),
                        //             ),
                        //
                        //           ],
                        //         ),
                        //       ):Container(),
                        //     ],
                        //   ),
                        // ):const SizedBox(),

                        const SizedBox(height: 40,),
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
          progressIndicator?loadingWidget():const SizedBox()
        ],
      ),
    );
  }


  Widget buildText(String labelText, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: w-50,
        // height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: (w-50)*.4,
              child: Text(labelText,style: const TextStyle(fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              width: (w-50)*.5,
              child: Text(value),
            )
          ],
        ),
      ),
    );
  }

  // Function to create a text input field
  // Widget buildTextForm(String labelText, TextEditingController ctrl,TextInputType type) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: SizedBox(
  //       width: w-50,
  //       // height: 50,
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           SizedBox(
  //             width: w*.2,
  //             // color: Colors.green,
  //             child: Text("$labelText : ",style: const TextStyle(fontWeight: FontWeight.bold),),
  //           ),
  //           SizedBox(
  //               width: w*.6,
  //               child: TextFormField(
  //                 keyboardType: type,
  //                 controller: ctrl,
  //                 decoration: InputDecoration(
  //                   // icon: Icon(Icons.password),
  //                   // hintText: "Pin",
  //                   enabled: true,
  //                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  //                 ),
  //               )
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }



}

