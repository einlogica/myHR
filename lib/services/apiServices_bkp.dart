//
// import 'dart:convert';
// import 'dart:io';
// // import 'dart:typed_data';
// import 'package:einlogica_hr/Models/collectionModel.dart';
// import 'package:einlogica_hr/Models/employerModel.dart';
// import 'package:einlogica_hr/Models/paymentModel.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:einlogica_hr/Models/eventsModel.dart';
// import 'package:einlogica_hr/Models/paySlipModel.dart';
// import 'package:einlogica_hr/Models/policyModel.dart';
// import 'package:einlogica_hr/Models/reporteeModel.dart';
// import 'package:path/path.dart' as path;
// import 'package:einlogica_hr/Models/activityModel.dart';
// import 'package:einlogica_hr/Models/advanceModel.dart';
// import 'package:einlogica_hr/Models/attendanceModel.dart';
// import 'package:einlogica_hr/Models/billerModel.dart';
// import 'package:einlogica_hr/Models/directoryModel.dart';
// import 'package:einlogica_hr/Models/leaveModel.dart';
// import 'package:einlogica_hr/Models/locationModel.dart';
// import 'package:einlogica_hr/Models/payRollModel.dart';
// import 'package:einlogica_hr/Models/personalInfoModel.dart';
// import 'package:einlogica_hr/Models/summaryModel.dart';
// import 'package:einlogica_hr/Models/userExpenseModel.dart';
// import 'package:einlogica_hr/Models/userModel.dart';
// import 'package:unique_identifier/unique_identifier.dart';
//
//
// var token;
// late String _identifier;
// late String _mobileidentifier;
// late String emp;
//
//
// class apiServices{
//
//
//
//   //--------------PRODUCTION
//   var url = "https://phpcontainerapp.greenpond-6d64ab18.centralindia.azurecontainerapps.io:443";
//
//   //--------------TEST
//   // var url = "https://testingcontainerapp.greenpond-6d64ab18.centralindia.azurecontainerapps.io:443";
//   // var url ="http://localhost:8083"; //web
//   // var url = 'http://10.0.2.2:8083'; //Emulator
//
//   var appVersion ="V1.1.9+33";
//   // var emp = "";
//
// //================================================================================================================================================= USERS
//
//   //Get Version
//   String getVersion(){
//     return appVersion;
//   }
//
//   //New Registration
//   Future<String> registration(String name,String mobile, String email, String id, String employer, String l1, String l2)async{
//     String status="Failed";
//
//     final response = await apiRequest("register.php", {"usermobile": mobile,"username":name,"useremail":email,"id":id,"employer":employer,"l1":l1,"l2":l2});
//     // print(response.body);
//     if (response.statusCode == 200) {
//       status = response.body.trim();
//     }
//     else{
//       status="http Error";
//     }
//
//     return status;
//   }
//
//   void setEmp(String emp1){
//     emp=emp1;
//   }
//
//
//
//   //Login function
//   Future<String> checkLogin(String mobile,String password)async{
//     String status = "";
//
//     var data;
//
//     final response = await apiRequest("login.php", {"usermobile": mobile,"userpass": password,"app": appVersion});
//     // print("==========");
//     print(response.body);
//     // print(response.statusCode);
//     if (response.statusCode == 200) {
//       status = response.body.trim();
//       data = jsonDecode(response.body);
//       if(data['Status']!="Failed"){
//         token= data['Token'];
//         _identifier=data['Data']['Tocken'];
//         _mobileidentifier=mobile;
//         emp=data['Data']['Employer'];
//       }
//     }
//     else{
//       status="http Error";
//     }
//
//     return status;
//   }
//
//   //Check for Updated version
//   Future<bool> checkUpdate()async{
//     String status="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"checkUpdate","app":appVersion});
//     status = response.body.trim();
//     if(status=="TRUE"){
//       return true;
//     }
//     else{
//       return false;
//     }
//   }
//
//   //Download new app
//   Future<Uint8List> getNewApp()async{
//     Uint8List status =Uint8List(0);
//
//     final response = await apiRequest("jilariapi.php", {"action":"getNewApp"});
//     if(response.body.trim()!='Failed'){
//       status = base64Decode(response.body.trim());
//     }
//     return status;
//   }
//
//
//   //Check device
//   Future<bool> checkDevice()async{
//
//     String id="";
//
//     try {
//       id = (await UniqueIdentifier.serial)!;
//     } on PlatformException {
//       id = 'Failed to get Unique Identifier';
//     }
//     // print(id);
//     if(id==_identifier){
//       return true;
//     }
//     else{
//       return false;
//     }
//
//   }
//
//   //Update FCMTocken
//   void updateFCM(String mobile)async{
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
//     await Future.delayed(Duration(seconds: 1));
//     String? apns = await messaging.getAPNSToken();
//     String? FCMtocken = await messaging.getToken();
//
//     await apiRequest("jilariapi.php", {"action":"updatefcm","usermobile":mobile,"fcm": FCMtocken.toString(),"device":_identifier});
//   }
//
//   // Upload Profile Image
//   Future<String> uploadImage(String file,String mobile)async{
//
//     String status="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"upload_image","usermobile":mobile,"file": file,"emp":emp});
//     status = response.body.trim();
//     return status;
//   }
//
//   // Upload Logo Image
//   Future<String> uploadLogo(String file,String mobile)async{
//
//     String status="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"upload_logo","usermobile":mobile,"file": file,"emp":emp});
//     status = response.body.trim();
//     return status;
//   }
//
//
//   //Api to fetch user details
//   //To get managers list in addEmployeePage
//   Future<List<userModel>> getUserDetails(String mobile,String filter)async{
//     List<userModel> userList=[];
//
//     final response = await apiRequest("jilariapi.php", {"action":"get_userdetails","mobile":mobile,"filter":filter,"emp":emp});
//     // print(response.body.trim());
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body);
//       userList=[];
//       for (var d in data){
//         userList.add(userModel(Mobile: d['Mobile'], Name: d['Name'],Email: d['Email']??"", EmployeeID: d['EmployeeID'],Employer: d['Employer'], Department: d['Department'], Position: d['Position'],Permission: d['Permission'],Manager: d['Manager'],ManagerID: d['ManagerID'], DOJ: d['DOJ'],LeaveCount: double.parse(d['LeaveCount']), Status: d['Status'], ImageFile: d['ImageFile']));
//       }
//     }
//
//     return userList;
//   }
//
//   //To get admin list for superuser
//   // Future<List<userModel>> getAdmins(String mobile,String filter)async{
//   //   print("Executing get User Details method");
//   //   List<userModel> userList=[];
//   //
//   //   final response = await apiRequest("jilariapi.php", {"action":"get_admins","mobile":mobile,"filter":filter,"emp":emp});
//   //   if(response.body.trim()!="Failed"){
//   //     var data = jsonDecode(response.body);
//   //     userList=[];
//   //     for (var d in data){
//   //       userList.add(userModel(Mobile: d['Mobile'], Name: d['Name'],Email: d['Email']??"", EmployeeID: d['EmployeeID'],Employer: d['Employer'], Department: d['Department'], Position: d['Position'],Permission: d['Permission'],Manager: d['Manager'],ManagerID: d['ManagerID'], DOJ: d['DOJ'],LeaveCount: double.parse(d['LeaveCount']), Status: d['Status'], ImageFile: d['ImageFile']));
//   //     }
//   //   }
//   //
//   //   return userList;
//   // }
//
//   Future<userModel> getProfile(String mobile)async{
//
//     userModel currentUser = userModel(Mobile: "", Name: "",Email: "", EmployeeID: "", Employer: "", Department: "", Position: "", Permission: "", Manager: "", ManagerID: "", DOJ: "", LeaveCount: 0, Status: "", ImageFile: "");
//
//     final response = await apiRequest("jilariapi.php", {"action":"getProfile","mobile":mobile,"device":_identifier,"emp":emp});
//     if(response.body.trim()!="Failed"){
//       var d = jsonDecode(response.body);
//       currentUser = userModel(Mobile: d[0]['Mobile'], Name: d[0]['Name'],Email: d[0]['Email']??"", EmployeeID: d[0]['EmployeeID'],Employer: d[0]['Employer'], Department: d[0]['Department'], Position: d[0]['Position'],Permission: d[0]['Permission'],Manager: d[0]['Manager'],ManagerID: d[0]['ManagerID'], DOJ: d[0]['DOJ'],LeaveCount: double.parse(d[0]['LeaveCount']), Status: d[0]['Status'], ImageFile: d[0]['ImageFile']);
//     }
//
//     return currentUser;
//   }
//
//   //To get employee list under a manager for dashboardPage
//   Future<List<reporteeModel>> getReportees(String mobile,String filter,String date)async{
//     List<reporteeModel> userList=[];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getReportees","mobile":mobile,"filter":filter,"date":date,"emp":emp});
//     // print(response.body);
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body);
//       userList=[];
//       for (var d in data){
//         userList.add(reporteeModel(Mobile: d['Mobile'], Name: d['Name'], Position: d['Position'], Status: d['Status']??"", AttStatus: d['AttStatus']??"",Location: d['Location']??""));
//       }
//     }
//
//     return userList;
//   }
//
//
//
//
//   //Change Password
//   Future<String> changePassword(String mob, String oldPass, String newPass, bool reset)async{
//
//     String status="";
//     _identifier = (await UniqueIdentifier.serial)!;
//
//     final response = await apiRequest("jilariapi.php", {"action":"change_password","usermobile": mob,"oldpass":oldPass,"newpass":newPass,"id":_identifier,"reset":reset.toString(),"emp":emp});
//
//     if(response.statusCode==200 && response.body.trim()=="Completed"){
//       status="Success";
//     }
//     else{
//       status="Failed";
//     }
//     return status;
//   }
//
//
//   //Reset Password
//   Future<String> resetPassword(String mob,String email,String name)async{
//     String status="Failed";
//
//     final response = await apiRequest("jilariapi.php", {"action":"resetPassword","usermobile": mob,"useremail":email,"username":name,"adminmobile":_mobileidentifier,"emp":emp});
//
//     if(response.statusCode==200){
//       status=response.body.trim();
//     }
//
//     return status;
//   }
//
//
//
//   //Add user
//   Future<String> addUser(Map<String,dynamic> user)async{
//     String status="";
//     user.addAll({"device":_identifier});
//     final response = await apiRequest("jilariapi.php",{"action":"add_user","user":jsonEncode(user)});
//     if (response.statusCode == 200) {
//       status = response.body.trim();
//     }
//     return status;
//   }
//
//
//   //Search directory
//   Future<List<directoryModel>> searchDirectory(String filter)async{
//     List<directoryModel> list = [];
//
//     final response = await apiRequest("jilariapi.php", {"action":"searchDirectory","filter": filter,"emp":emp});
//     if (response.statusCode == 200) {
//       list.clear();
//       var data=jsonDecode(response.body.trim());
//       for (var d in data){
//         list.add(directoryModel(Name: d['Name'], Mobile: d['Mobile'], EmployeeID: d['EmployeeID'], Manager: d['Manager'], Position: d['Position'], Department: d['Department'], Image: d['ImageFile']));
//       }
//     }
//     return list;
//   }
//
//   //Update Basic Information
//   Future<String>updateBasicDetails(String Email,String Manager, String ManagerID, String Position, String Department, String Permission,String Mobile,String DOJ,String Leave)async{
//     String status="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"updateBasicDetails","email":Email,"manager":Manager,"managerid":ManagerID,"position":Position,"department":Department,"permission":Permission,"mobile":Mobile,"doj":DOJ,"leave":Leave});
//     if (response.statusCode == 200) {
//       status = response.body.trim();
//     }
//     return status;
//   }
//
//   Future<personalInfoModel> checkPersonalInfo(String mob)async{
//     personalInfoModel personalInfo = personalInfoModel(ID: 0, Name: "", Mobile: "", Sex: "", DOB: "", AddL1: "", AddL2: "", AddL3: "", Zip: "", BloodGroup: "", EmContactName: "", EmContactNum: "", BankName: "", AccNum: "",UAN: "",PAN: "",ESICNo: "");
//
//     // String _identifier = (await UniqueIdentifier.serial)!;
//     final response = await apiRequest("jilariapi.php",{"action":"checkPersonalInfo","mobile":mob,"emp":emp});
//     if (response.statusCode == 200 && response.body.trim()!="Failed") {
//
//       var data = jsonDecode(response.body.trim());
//       personalInfo = personalInfoModel(ID: int.parse(data['ID']), Name: data['Name'], Mobile: data['Mobile'], Sex: data['Sex'], DOB: data['DOB'], AddL1: data['AddL1'], AddL2: data['AddL2'], AddL3: data['AddL3'], Zip: data['Zip'], BloodGroup: data['BloodGroup'], EmContactName: data['EmContactName'], EmContactNum: data['EmContactNum'], BankName: data['BankName'], AccNum: data['AccNum'],UAN: data['UAN'],PAN: data['PAN'],ESICNo: data['ESICNo']);
//     }
//     return personalInfo;
//   }
//
//   Future<String> updatePersonalInfo(Map<String,dynamic> user)async{
//     String status="";
//     final response = await apiRequest("jilariapi.php",{"action":"updatePersonalInfo","user":jsonEncode(user),"emp":emp});
//     if (response.statusCode == 200) {
//       status = response.body.trim();
//     }
//     return status;
//   }
//
//   Future<String> deactivateEmployee(String mobile)async{
//     String status="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"deactivateEmployee","mobile":mobile,"emp":emp,"device":_identifier});
//     if (response.statusCode == 200) {
//       status = response.body.trim();
//     }
//     return status;
//   }
//
//   Future<List<String>> getDepartments(String mobile)async{
//     List<String> status=["Select"];
//     final response = await apiRequest("jilariapi.php", {"action":"getDepartments","mobile":mobile,"emp":emp});
//
//     if (response.statusCode == 200) {
//       var data=jsonDecode(response.body.trim());
//       for (var d in data){
//         status.add(d['Type']);
//       }
//     }
//     return status;
//   }
//
//   Future<List<String>> getPositions(String mobile)async{
//     List<String> status=["Select"];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getPositions","mobile":mobile,"emp":emp});
//     if (response.statusCode == 200) {
//       var data=jsonDecode(response.body.trim());
//       for (var d in data){
//         status.add(d['Type']);
//       }
//     }
//     return status;
//   }
//
//
//
//   //==================================================================================================================================== Attendance
//
//
//   //Fetch Montly Attendance data for chart preparation
//   Future<List<Map<String,dynamic>>>getMonthlyAttendance(String mobile,String month,String year)async{
//     List<Map<String,dynamic>> att = [];
//     final response = await apiRequest("jilariapi.php", {"action":"getMonthlyAttendance","usermobile": mobile,"emp":emp,"month":month,"year":year});
//     // print("response= ${response.body.trim()}");
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body.trim());
//       for(var d in data){
//         att.add({'Day':int.parse(d['Day']),'AbsentCount':double.parse(d['AbsentCount']),'PresentCount':double.parse(d['PresentCount']),'LeaveCount':double.parse(d['LeaveCount']),'Total':double.parse(d['Total'])});
//       }
//     }
//
//     return att;
//   }
//
//
//
//   //Fetch Todays attendance status
//   Future<String> attendanceStatus(String mobile)async{
//     String status = "";
//
//     final response = await apiRequest("jilariapi.php", {"action":"get_attendanceStatus","usermobile": mobile});
//
//     status = response.body.trim();
//     return status;
//   }
//
//   //Mark Absent
//   Future<String> markAbsent(String mobile,String date)async{
//     String status = "";
//     final sqlDateFormat = DateFormat('dd-MM-yyyy');
//     var formatteddate = DateFormat('yyyy-MM-dd').format(sqlDateFormat.parse(date));
//
//     final response = await apiRequest("jilariapi.php", {"action":"markAbsent","usermobile": mobile,"date":formatteddate,"emp":emp});
//
//     status = response.body.trim();
//
//     return status;
//   }
//
//
//
//   //Post checkin attendance to database
//   Future<String> postAttendance(String name,String mobile,double posLat,double posLong,String location,String type)async{
//     String status="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"post_Attendance","usermobile": mobile,"username":name,"posLat":posLat.toStringAsFixed(5),"posLong":posLong.toStringAsFixed(5),"location":location,"type":type});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//
//       status=data['Mess'];
//     }
//     return status;
//   }
//
//
//
//   //Fetch attendance data
//   Future<List<attendanceModel>> getAttendanceData(String mobile,int month,int year)async{
//     List<attendanceModel> attendanceList = [];
//
//     final response = await apiRequest("jilariapi.php", {"action":"get_AttendanceData","usermobile": mobile,"month":month.toString(),"year":year.toString(),});
//     if(response.statusCode==200){
//
//       var data = jsonDecode(response.body);
//       String date,intime,outtime;
//       final sqlDateFormat = DateFormat('yyyy-MM-dd');
//       final sqlTimeFormat = DateFormat('HH:mm');
//       attendanceList.clear();
//       for (var d in data){
//
//         date = DateFormat('dd-MM-yyyy').format(sqlDateFormat.parse(d['Date']));
//         intime = DateFormat('Hms').format(sqlTimeFormat.parse(d['InTime']));
//         outtime = DateFormat('Hms').format(sqlTimeFormat.parse(d['OutTime']));
//
//         attendanceList.add(attendanceModel(Name: d['Name'], Mobile: d['Mobile'], posLat: double.parse(d['PosLat']), posLong: double.parse(d['PosLong']),
//             attDate: date, attTime: intime,posLat2: double.parse(d['PosLat2']),posLong2: double.parse(d['PosLong2']),outDate: d['OutDate'],outTime: outtime,status: d['Status'], location: d['Location'],duration: d['Duration'],flag: d['Flag'],comments: d['Comments']));
//       }
//     }
//
//     return attendanceList;
//   }
//
//
//
//   Future<List<attendanceModel>> getRegularization(String mobile)async{
//     List<attendanceModel> list =[];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getRegularization","usermobile": mobile,"emp":emp});
//
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body.trim());
//       list.clear();
//       for (var d in data){
//         list.add(attendanceModel(Name: d['Name'], Mobile: d['Mobile'], posLat: 0.00, posLong: 0.00, attDate: d['Date'], attTime: d['InTime'], posLat2: 0.00, posLong2: 0.00,outDate: d['Date'],outTime: d['OutTime'], status: '', location: '',duration: '00:00',flag: '',comments: d['Comments']));
//       }
//     }
//     return list;
//   }
//
//   //Post regularization request
//   Future<String> postRegularization(String mobile, String name, String date, String regIn, String regOut, String comments)async{
//     String status ="";
//     final response = await apiRequest("jilariapi.php",{"action":"postRegularization","usermobile":mobile,"username":name,"date":date,"regIn":regIn,"regOut":regOut,"comments":comments,"emp":emp});
//     status = response.body.trim();
//     return status;
//   }
//
//   //Approve regularization request
//   Future<String> approveRegularization(String mobile,String date,String type)async{
//     String status = "";
//
//     final response = await apiRequest("jilariapi.php", {"action":"approveRegularization","usermobile":mobile,"date":date,"status":type});
//
//     if(response.statusCode==200){
//
//       var data = jsonDecode(response.body.trim());
//       status = data['Mess'];
//     }
//     return status;
//
//   }
//
//
//
//
//   //========================================================================================================================================= LEAVE
//
//
//   //Apply Leave
//   Future<String> applyLeave(String mobile,String name,List<String> dateList2,String comments,double days)async{
//     String status="";
//     String date=jsonEncode(dateList2);
//
//     final response = await apiRequest("jilariapi.php", {"action":"postLeave","usermobile": mobile,"username": name,"leavedate":date,"comments":comments,"days":days.toString(),"emp":emp});
//     if(response.statusCode == 200) {
//       var data = jsonDecode(response.body.trim());
//       if(data['Status']=="Success"){
//         status=data['Mess'];
//       }
//     }
//     else{
//       status="Failed";
//     }
//
//     return status;
//   }
//
//
//
//   //Fetch applied leave list
//   Future<List<leaveModel>>getLeaves(String mobile, String type,String year,String month)async{
//     List<leaveModel> leaveList = [];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getLeave","usermobile": mobile,"type":type,"year":year,"month":month,"emp":emp});
//
//     if(response.statusCode == 200) {
//       if(response.body.trim()!="Failed"){
//         var data = jsonDecode(response.body.trim());
//         leaveList.clear();
//         for (var d in data){
//           leaveList.add(leaveModel(Id: d['ID'], Mobile: d['Mobile'], Name: d['Name'], LeaveDate: d['LeaveDate'],Days: double.parse(d['Days']), LOP:double.parse(d['LOP']),AppliedTime: d['AppliedTime'], AppliedDate: d['AppliedDate'], Status: d['Status'],Comments: d['Comments'], L1Status: d['L1Status'],L1Comments: d['L1Comments'],L2Status: d['L2Status'],L2Comments: d['L2Comments']));
//         }
//       }
//     }
//
//     return leaveList;
//   }
//
//   //Delete applied leave
//   //Input : Leave ID
//   //Output:
//   Future<String>deleteLeave(String ID,String type)async{
//
//     String status ="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"deleteLeave","id": ID,"type":type});
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.trim());
//       if(data['Status']=="Success"){
//         status=data['Mess'];
//       }
//     }
//     else{
//       status="Failed";
//     }
//
//     return status;
//   }
//
//
//   Future<String> updateLeave(List<String> idList,String per,String approval, String comments)async{
//     String status = "";
//     String id=jsonEncode(idList);
//     final response = await apiRequest("jilariapi.php", {"action":"updateLeave","id": id, "status":approval,"comments":comments,"per":per,"emp":emp});
//
//     if (response.statusCode == 200 && response.body.trim()=='Success') {
//       status="Success";
//     }
//     else{
//       status="Failed";
//     }
//
//     return status;
//   }
//
//
//
//   //========================================================================================================================================= EXPENSE
//
//   //Fetch Expense Types
//   Future<List<String>>getExpenseType()async{
//     List<String> type =[];
//     final response = await apiRequest("jilariapi.php", {"action":"getExpenseType","emp":emp});
//     // print("response= ${response.body.trim()}");
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body.trim());
//       for(var d in data){
//         type.add(d['Type']);
//       }
//     }
//     return type;
//   }
//
//   //Fetch Montly Attendance data for chart preparation
//   Future<List<Map<String,dynamic>>>getMonthlyExpense(String mobile,String month,String year)async{
//     List<Map<String,dynamic>> exp = [];
//     final response = await apiRequest("jilariapi.php", {"action":"getMonthlyExpense","usermobile": mobile,"emp":emp,"month":month,"year":year});
//     // print("response= ${response.body.trim()}");
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body.trim());
//       for(var d in data){
//         exp.add({'Type':d['Type'],'Amount':double.parse(d['Amount'])});
//       }
//     }
//
//     return exp;
//   }
//
//
//
//   // Api to fetch user expenses
//   Future<List<userExpenseModel>> getUserExpenses(String mob,String mon, String year,String type)async{
//
//     List<userExpenseModel> userExpenseList=[];
//     final response = await apiRequest("jilariapi.php", {"action":"get_userexpense","usermobile": mob,"mon":mon,"year":year,"type":type,"emp":emp});
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       userExpenseList.clear();
//       for (var d in data){
//         userExpenseList.add(userExpenseModel(ID:d['ID'],Mobile: d['Mobile'], Name: d['Name'],Site: d['Site'],LabourName: d['LabourName'],LabourCount: d['LabourCount'],Duration: d['Duration'],FromLoc: d['FromLoc'],ToLoc: d['ToLoc'],KM: d['KM'], Date : d['Date'], Type: d['Type'],Item: d['Item'], ShopName: d['ShopDesc']??'',ShopDist: d['District']??'',ShopPhone: d['Phone']??'',ShopGst: d['GST']??'',BillNo: d['BillNo'], Amount: d['Amount'], Filename: d['Filename'],Status: d['Status'],L1Status: d['L1Status'],L1Comments: d['L1Comments'],L2Status: d['L2Status'],L2Comments: d['L2Comments'],FinRemarks: d['FinRemarks']));
//       }
//     }
//
//     return userExpenseList;
//   }
//
//   // Api to fetch user expenses
//   Future<double> getPreExpenses(String mob,String mon, String year,String type)async{
//
//     double userExpense=0.00;
//     final response = await apiRequest("jilariapi.php", {"action":"get_preexpense","usermobile": mob,"mon":mon,"year":year,"type":type,"emp":emp});
//
//     if (response.statusCode == 200) {
//       userExpense = double.parse(response.body.trim());
//     }
//
//     return userExpense;
//   }
//
//   //Fetch Vehicle list
//   Future<String>fetchVehicle(String usermobile)async{
//     String data="";
//     final response = await apiRequest("jilariapi.php", {"action":"getVehicle","usermobile":usermobile,"emp":emp});
//     if (response.statusCode == 200) {
//       data = response.body.trim();
//     }
//     return data;
//   }
//
//
//   //Clear Bill
//   // Future<String> clearBill(String billId,String buttonValue,String comment)async{
//   //   String status="";
//   //
//   //   final response = await apiRequest("jilariapi.php", {"action":"clear_bill","billid": billId, "status":buttonValue, "comments":comment});
//   //   if(response.statusCode==200 && response.body.trim()=="Completed"){
//   //     // await apiServices().getUserExpenses(widget.mobile);
//   //     status = "Success";
//   //
//   //   }
//   //
//   //   return status;
//   // }
//
//
//   //Get Bill image
//   //Get profile image
//   Future<Uint8List> getBill(String item,String type)async{
//     // print(type);
//     if(type=="App"){
//       item=appVersion;
//     }
//     Uint8List profileImage=Uint8List(0);
//     final response = await apiRequest("jilariapi.php", {"action":"get_billImage","filename":item,"type":type,"emp":emp});
//     if(response.statusCode==200){
//       var data = response.body.trim();
//       // print(data);
//       if(data!="Failed"){
//         profileImage=base64Decode(data);
//       }
//
//     }
//     return profileImage;
//   }
//
//   //Delete Bill
//   Future<String> deleteBill(String mobile,String selectedID)async{
//     String status="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"delete_bill","usermobile": mobile,"billid": selectedID,"emp":emp});
//     if(response.statusCode==200 && response.body.trim()=="Completed"){
//       status="Success";
//     }
//     else{
//       status="Failed";
//     }
//
//     return status;
//   }
//
//   //Update Expense
//   Future<String> updateBill(String id,String per,String approval, String comments)async{
//     String status = "";
//     final response = await apiRequest("jilariapi.php", {"action":"updateExpense","id": id, "status":approval,"comments":comments,"per":per});
//     if (response.statusCode == 200) {
//       status=response.body.trim();
//     }
//     else{
//       status="Failed";
//     }
//
//     return status;
//   }
//
//   //Clear Expense from finance
//   Future<String> clearBill(List<String> id,String per,String approval, String comments)async{
//     String status = "";
//
//     String idList=jsonEncode(id);
//     final response = await apiRequest("jilariapi.php", {"action":"clearExpense","id": idList, "status":approval,"comments":comments,"per":per});
//     if (response.statusCode == 200) {
//       status=response.body.trim();
//     }
//     else{
//       status="Failed";
//     }
//
//     return status;
//   }
//
//   //add employee advance to expense
//   Future<String> addEmployeeAdvance(String mobile,String name, String account,String location,String date, String amount)async{
//     String status = "";
//
//     final response = await apiRequest("jilariapi.php", {"action":"addEmployeeAdvance","emp":emp,"id":_identifier,"usermobile": mobile,"username":name, "account":account,"location":location,"date":date,"amount":amount});
//     if (response.statusCode == 200) {
//       status=response.body.trim();
//     }
//     else{
//       status="Failed";
//     }
//
//     return status;
//   }
//
//   //add daily wage expense
//   Future<String> addDailyWages(String mobile,String name, String site,String labourName,String labourCount, String duration,String amount,String date)async{
//     String status = "";
//
//     final response = await apiRequest("jilariapi.php", {"action":"addDailyWages","usermobile": mobile,"username":name,"site": site,"labour": labourName,"labourcount": labourCount,"duration": duration,"amount":amount,"date":date});
//     if (response.statusCode == 200) {
//       status=response.body.trim();
//     }
//     else{
//       status="Failed";
//     }
//
//     return status;
//   }
//
//   //Upload Bill
//   Future<String> uploadBill(String mobile,String name,String type,String item,String site,String fromLoc,String toLoc,String km,String billno,String amt,String date,String file,String avail)async{
//     String status ="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"upload_bill","emp":emp,"usermobile": mobile,"username":name,"type": type,"item":item,"site": site,"fromLoc": fromLoc,"toLoc": toLoc,"km": km,"billno":billno,
//       "billamount":amt,"billdate":date,"file":file,"fileavailable":avail,});
//     if(response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       if (data['Status'] == "Success") {
//         status="Success";
//       }
//       else{
//         status="Failed";
//       }
//     }
//
//     return status;
//   }
//
//   //Upload Purchase Bill
//   Future<String> uploadPurchaseBill(String mobile,String name,String type,String item,String site,String billno,String amt,String date,String file,String avail, billerModel biller)async{
//     String status ="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"upload_purchasebill","emp":emp,"usermobile": mobile,"username":name,"type": type,"item":item,"site":site,"billno":billno,"billamount":amt,"billdate":date,"file":file,"fileavailable":avail,"id":biller.id,
//       "shop":biller.name,"l1":biller.addressl1,"l2":biller.addressl2,"l3":biller.addressl3,"dist":biller.district,"phone":biller.mobile,"gst":biller.gst});
//     // print(response.body);
//     if(response.statusCode == 200) {
//       var data = jsonDecode(response.body.trim());
//       if (data['Status'] == "Success") {
//         status="Success";
//       }
//       else{
//         status=data['Mess'];
//       }
//     }
//     return status;
//   }
//
//
//
//   //Get Biller data
//   Future<List<billerModel>> getBiller(String filter, String type)async{
//     List<billerModel> list =[];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getBiller","filter":filter,"type":type,"emp":emp});
//
//     if (response.statusCode == 200) {
//       list.clear();
//       var data=jsonDecode(response.body.trim());
//       for (var d in data){
//         list.add(billerModel(id: d['ShopID'], name: d['ShopName'], addressl1: d['AddressL1'], addressl2: d['AddressL2'], addressl3: d['AddressL3'], district: d['District'], mobile: d['Phone'], gst: d['GST'],division: d['Division'],type: d['Type'],createDate: d['CreateDate'],createTime: d['CreateTime'],createUser: d['CreateUser'],createMobile: d['CreateMobile']));
//       }
//     }
//
//     return list;
//   }
//
//   //Add Shop Address
//   Future<String> addBiller(billerModel biller,String user, String mobile)async{
//     final response = await apiRequest("jilariapi.php", {"action":"addBiller","username":user,"usermobile":mobile,"emp":emp,"shop":biller.name,"l1":biller.addressl1,"l2":biller.addressl2,"l3":biller.addressl3,"dist":biller.district,"phone":biller.mobile,"gst":biller.gst,"div":biller.division,"type":biller.type});
//     if (response.statusCode == 200 && response.body.trim()=="Success") {
//       return "Success";
//     }
//     else{
//       return "Failed";
//     }
//
//   }
//
//
//   //Get District List
//   Future<List<String>> getDistrict(String state)async{
//     List<String>distList =[];
//     final response = await apiRequest("jilariapi.php", {"action":"getDistrict","state":state});
//     if (response.statusCode == 200) {
//       distList.clear();
//       distList.add("Select");
//       var data=jsonDecode(response.body.trim());
//       for (var d in data){
//         distList.add(d['DistrictName']);
//       }
//     }
//     return distList;
//   }
//
//   //===============================================================================================================================================  Collection
//
//   //Fetch material summary
//   Future<List<Map<String,dynamic>>>getMaterialSummary(String mobile, DateTime Date)async{
//     String date = DateFormat('yyyy-MM-dd').format(Date);
//     List<Map<String,dynamic>> att = [];
//     final response = await apiRequest("jilariapi.php", {"action":"getMaterialSummary","usermobile": mobile,"emp":emp,"date":date});
//     // print("response= ${response.body.trim()}");
//     if(response.body.trim().isNotEmpty){
//       var data = jsonDecode(response.body.trim());
//       for(var d in data){
//         att.add({'division':d['division'],'type':d['type'],'Shops':d['Shops'],'dryweight':d['dryweight'],'clothweight':d['clothweight'],'rejAmount':d['rejAmount']});
//       }
//     }
//
//     return att;
//   }
//
//   //Fetch material summary
//   Future<List<Map<String,dynamic>>>getBillerSummary(String mobile,DateTime Date)async{
//     String date = DateFormat('yyyy-MM-dd').format(Date);
//     List<Map<String,dynamic>> att = [];
//     final response = await apiRequest("jilariapi.php", {"action":"getBillerSummary","usermobile": mobile,"emp":emp,"date":date});
//     // print("response= ${response.body.trim()}");
//     if(response.body.trim().isNotEmpty){
//       var data = jsonDecode(response.body.trim());
//       for(var d in data){
//         att.add({'Division':d['Type'],'Visited':d['Visited'],'New':d['NewAddition']});
//       }
//     }
//
//     return att;
//   }
//
//   //Fetch cash summary
//   Future<List<Map<String,dynamic>>>getCashSummary(String mobile,DateTime Date)async{
//     String date = DateFormat('yyyy-MM-dd').format(Date);
//     List<Map<String,dynamic>> att = [];
//     final response = await apiRequest("jilariapi.php", {"action":"getCashSummary","usermobile": mobile,"emp":emp,"date":date});
//     // print("response= ${response.body.trim()}");
//     if(response.body.trim().isNotEmpty){
//       var data = jsonDecode(response.body.trim());
//       for(var d in data){
//         att.add({'Type':d['Item'],'Amount':d['Amount']});
//       }
//     }
//
//     return att;
//   }
//
//
//   Future<String> uploadCollection(String usermobile,String username, String shopid,String shopname,String veh, String date, String dry,String cloth, String amt, String image, double lat, double long,String item)async{
//     String status="";
//     final response = await apiRequest("jilariapi.php", {"action":"uploadCollection","usermobile":usermobile,"username":username,"shopid":shopid,"shopname":shopname,"vehicle":veh,"date":date,"dry":dry==''?'0':dry,"cloth":cloth==''?'0':cloth,"amt":amt==''?'0':amt,"image":image,"emp":emp,"lat":lat.toString(),"long":long.toString(),"item":item});
//     if (response.statusCode == 200) {
//       status = response.body.trim();
//     }
//     else{
//       status="Failed";
//     }
//
//     return status;
//
//   }
//
//   Future<List<collectionModel>> getCollection(String mobile, String per,String date)async{
//     List<collectionModel> collectionList =[];
//     final response = await apiRequest("jilariapi.php", {"action":"getCollection","usermobile":mobile,"per":per,"emp": emp,"date":date,});
//     // print(response.body.trim());
//     if(response.statusCode==200 && response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body);
//
//       for (var d in data){
//         collectionList.add(collectionModel(id: d['ID'], mobile: d['Mobile'], name: d['Name'], shopid: d['ShopID']??"", shopname: d['ShopName']??"",vehicle: d['Vehicle']??"",l1: d['AddressL1']??"",l2:d['AddressL2']??"",l3:d['AddressL3']??"",dist: d['District']??"",phone: d['Phone']??"",gst: d['GST']??"",div: d['Division']??"",type: d['Type']??"", date: d['Date'], time: d['Time'], item: d['Item'],dry: d['DryWeight']??"", dryPrice: d['DryPrice']??"", cloth: d['ClothWeight']??"", clothPrice: d['ClothPrice']??"",amt: d['Amount']??"",file: d['Filename']??"",lat: d['Lat'], long: d['Long'], tot: d['Total']??"",billno: d['BillNo']??''));
//       }
//     }
//
//     return collectionList;
//
//   }
//
//
//   Future<String> deleteCollection(String id,String mobile)async{
//
//     String status="";
//     final response = await apiRequest("jilariapi.php", {"action":"deleteCollection","id":id,"usermobile":mobile,"emp":emp});
//
//     if (response.statusCode == 200) {
//       status = response.body.trim();
//     }
//     else{
//       status="Failed";
//     }
//     return status;
//   }
//
//
//
//   //===============================================================================================================================================  ACTIVITY
//
//
//
//
//   //Update Drive Activity
//   Future<String> updateDriveActivity(String ID, String sKM, String eKM)async{
//
//     String status="";
//
//     if(int.parse(sKM)>int.parse(eKM)){
//       return "Failed";
//     }
//
//     final response = await apiRequest("jilariapi.php", {"action":"update_DriveActivity","id": ID.toString(),"sKM":sKM.toString(),"eKM":eKM.toString()});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       status=data['Status'];
//     }
//
//     return status;
//   }
//
//
//   //Fetch activity data
//   Future<List<activityModel>> getActivity(String mobile,String date,String type)async{
//
//     List<activityModel> actList = [];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getActivity","usermobile": mobile,"date":date,"type":type,"emp":emp});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       String date,time;
//       final sqlDateFormat = DateFormat('yyyy-MM-dd');
//       final sqlTimeFormat = DateFormat('HH:mm');
//       actList.clear();
//       for (var d in data){
//
//         date = DateFormat('dd-MM-yyyy').format(sqlDateFormat.parse(d['Date']));
//         time = DateFormat('Hms').format(sqlTimeFormat.parse(d['Time']));
//
//         actList.add(activityModel(id:d['ID'],mobile: d['Mobile'], name: d['Name'],type: d['Type'], site: d['Site'],drive:bool.parse(d['Drive']),sKM: int.parse(d['StartKM']),eKM: int.parse(d['EndKM']), lat: d['PosLat'], long: d['PosLong'], date: date, time: time,cust: d['Customer'],remarks: d['Remarks']));
//       }
//     }
//
//     return actList;
//   }
//
//
//
//   //Delete Activity
//   Future<String> deleteActivity(String mobile,String id)async{
//     String status="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"delete_Activity","usermobile": mobile,"id":id});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       status=data['Status'];
//     }
//
//     return status;
//   }
//
//
//   //Post Activity
//   Future<String> postActivity(String name, String mobile,String type,String site,String date,bool drive,String startKM, String endKM, String lat, String long,String activity,String cust,String remarks)async{
//
//     String status="";
//
//     var sKM=0,eKM=0;
//     if(drive==true){
//       sKM=startKM==""?0:int.parse(startKM);
//       eKM=endKM==""?0:int.parse(endKM);
//
//       if(eKM!=0 && sKM>eKM){
//         return "Failed";
//       }
//     }
//
//     final response = await apiRequest("jilariapi.php", {"action":"post_Activity","usermobile": mobile,"username":name,"type":type,"site":site,"date":date,"drive":drive.toString(),"sKM":sKM.toString(),"eKM":eKM.toString(),"lat":lat,"long":long,"activity":activity,"cust":cust,"custno":remarks});
//
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       status=data['Status'];
//     }
//
//     return status;
//   }
//
//   Future<List<String>> getActivityType()async{
//     List<String> list = ['Select'];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getActivityType","emp": emp,});
//     if(response.statusCode==200 && response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body);
//       for (var d in data){
//         list.add(d['Type']);
//       }
//     }
//     list.add('Others');
//
//     return list;
//   }
//
//   Future<List<String>> getCustomerType()async{
//     List<String> list = ['Select'];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getCustomerType","emp": emp,});
//     if(response.statusCode==200 && response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body);
//       for (var d in data){
//         list.add(d['Type']);
//       }
//     }
//     list.add('Others');
//
//     return list;
//   }
//
//   //============================================================================================================================== PAY SLIP
//
//   Future<payRollModel> getSalaryStructure(String mobile)async{
//     payRollModel paySlip = payRollModel(Mobile: "", Name: "",Month: 0,Year: 0, Days: 0, WorkingDays: 0, LeaveDays: 0, LOP: 0, PresentDays: 0, TotalLOP: 0, Basic: 0, Allowance: 0, HRA: 0, TA: 0, DA: 0, Incentive: 0, GrossIncome: 0, PF: 0, ESIC: 0, ProTax: 0, Advance: 0, GrossDeduction: 0, NetPay: 0);
//     // String _identifier = (await UniqueIdentifier.serial)!;
//
//     final response = await apiRequest("jilariapi.php", {"action":"getSalaryStructure","usermobile":mobile,"device":_identifier});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body.trim());
//       if(data["Name"]!="NoName"){
//
//         paySlip=payRollModel(Mobile: data['Mobile'], Name: data['Name'],Month: 0,Year: 0, Days: 0, WorkingDays: 0, LeaveDays: 0.0, LOP: 0.0, PresentDays: 0.0, TotalLOP: 0.0,Basic: double.parse(data['Basic']), Allowance: double.parse(data['Allowance']), HRA: double.parse(data['HRA']), TA: double.parse(data['TA']), DA: double.parse(data['DA']), Incentive: double.parse(data['Incentive']), GrossIncome: 0.0, PF: double.parse(data['PF']), ESIC: double.parse(data['ESIC']), ProTax: double.parse(data['ProTax']), Advance: 0.0, GrossDeduction: 0.0, NetPay: 0.0);
//       }
//
//     }
//     return paySlip;
//   }
//
//   Future<String> updateSalary(String mobile,String basic,String special,String hra, String ta, String da,String incentive,String pf,String esic,String proTax)async{
//     String status = "";
//     final response = await apiRequest("jilariapi.php", {"action":"updateSalary","usermobile":mobile,"device":_identifier,"basic":basic,"special":special,"hra":hra,"ta":ta,"da":da,"incentive":incentive,"pf":pf,"esic":esic,"protax":proTax});
//     if(response.statusCode==200){
//       status=response.body.trim();
//     }
//     return status;
//   }
//
//
//   //Fetch advance details of users
//   Future<advanceModel> getAdvanceDetails(String mobile)async{
//     advanceModel advanceData = advanceModel(mobile: "", name: "", amount: "", date: "", emi: "", startdate: "", balance: "", status: "");
//     final response = await apiRequest("jilariapi.php",{"action":"getAdvanceDetails","usermobile":mobile});
//     if(response.statusCode==200){
//       var res = jsonDecode(response.body.trim());
//       if(res['Status']=="Success"){
//         var data = res['Mess'];
//         advanceData = advanceModel(mobile: data['Mobile'], name: data['Name'], amount: data['Amount'], date: data['Date'], emi: data['EMI'], startdate: data['StartDate'], balance: data['Balance'], status: data['Status']);
//       }
//     }
//     return advanceData;
//   }
//
//   //Add advances to employye account
//   Future<String> addAdvance(String account,String mobile,String amount,String emi,String startdate,String entrydate)async{
//     String status ="";
//     final response = await apiRequest("jilariapi.php",{"action":"addAdvance","account":account,"usermobile":mobile,"amount":amount,"emi":emi,"startdate":startdate,"entrydate":entrydate,"emp":emp});
//     if(response.statusCode==200){
//       status = response.body.trim();
//     }
//     return status;
//   }
//
//   //Fetch generated payroll
//   Future<List<payRollModel>>getPayrollTemplate()async{
//     List<payRollModel> payrollList =[];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getPayrollTemplate","device": _identifier,"emp":emp});
//     print(response.body);
//     if(response.statusCode==200 && response.body.trim().isNotEmpty){
//       var data = jsonDecode(response.body.trim());
//
//       for (var d in data){
//         payrollList.add(payRollModel(Mobile: d['Mobile'], Name: d['Name'],Month: int.parse(d['Month']),Year: int.parse(d['Year']), Days: int.parse(d['Days']),WorkingDays: int.parse(d['WorkingDays']), LeaveDays: double.parse(d['LeaveDays']), LOP: double.parse(d['LOP']), PresentDays: double.parse(d['PresentDays']), TotalLOP: double.parse(d['TotalLOP']), Basic: double.parse(d['Basic']), Allowance: double.parse(d['Allowance']), HRA: double.parse(d['HRA']), TA: double.parse(d['TA']), DA: double.parse(d['DA']), Incentive: double.parse(d['Incentive']), GrossIncome: double.parse(d['GrossIncome']), PF: double.parse(d['PF']), ESIC: double.parse(d['ESIC']), ProTax: double.parse(d['ProTax']), Advance: double.parse(d['Advance']), GrossDeduction: double.parse(d['GrossDeduction']), NetPay: double.parse(d['NetPay'])));
//       }
//     }
//     return payrollList;
//   }
//
//   //Fetch actual monthly payroll rolledout
//   Future<List<payRollModel>>fetchPayRoll(int month,int year)async{
//     List<payRollModel> payrollList =[];
//
//     final response = await apiRequest("jilariapi.php", {"action":"fetchPayRoll","device": _identifier,"month":month.toString(),"year":year.toString(),"emp":emp});
//
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body.trim());
//       for (var d in data){
//         payrollList.add(payRollModel(Mobile: d['Mobile'], Name: d['Name'],Month: int.parse(d['Month']),Year: int.parse(d['Year']), Days: int.parse(d['Days']), WorkingDays: int.parse(d['WorkingDays']), LeaveDays: double.parse(d['LeaveDays']), LOP: double.parse(d['LOP']), PresentDays: double.parse(d['PresentDays']), TotalLOP: double.parse(d['TotalLOP']), Basic: double.parse(d['Basic']), Allowance: double.parse(d['Allowance']), HRA: double.parse(d['HRA']), TA: double.parse(d['TA']), DA: double.parse(d['DA']), Incentive: double.parse(d['Incentive']), GrossIncome: double.parse(d['GrossIncome']), PF: double.parse(d['PF']), ESIC: double.parse(d['ESIC']), ProTax: double.parse(d['ProTax']), Advance: double.parse(d['Advance']), GrossDeduction: double.parse(d['GrossDeduction']), NetPay: double.parse(d['NetPay'])));
//       }
//     }
//     return payrollList;
//   }
//
//   //Generate Payroll
//   Future<String>generatePayroll(String month,String year,String LOP,List<String>users)async{
//
//     String status = "";
//     final response = await apiRequest("jilariapi.php", {"action":"generatePayroll","month":month,"year":year,"lop":LOP,"device": _identifier,"emp":emp,"users":users.toString()});
//     print(response.body);
//     if(response.statusCode==200){
//       status = response.body.trim();
//     }
//     return status;
//   }
//
//   //Delete Payroll template
//   Future<String>deleteTemplate()async{
//     String status = "";
//     final response = await apiRequest("jilariapi.php", {"action":"deleteTemplate","device": _identifier,"emp":emp});
//     if(response.statusCode==200){
//       status = response.body.trim();
//     }
//     return status;
//   }
//
//   //import csv to payslip template
//   Future<String> importPayRoll(String csvData)async{
//     String status="";
//
//     Map<String, dynamic> combinedData = {
//       'csvData': csvData,
//       'emp': emp,
//     };
//
//     try{
//       final response = await http.post(
//         Uri.parse("$url/importPayRoll.php"), body: combinedData,
//
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if(response.body.trim()=="TokenFailed"){
//         SystemNavigator. pop();
//       }
//
//       if(response.statusCode==200){
//         status = response.body;
//       }
//       else{
//         status ="Failed";
//       }
//     }
//     catch(e){
//       status ="Failed";
//     }
//
//     return status;
//   }
//
//   //Rollout PaySlip
//   Future<String> rolloutPaySlip()async{
//     String status ="";
//     final response = await apiRequest("jilariapi.php", {"action":"rolloutPaySlip","device": _identifier,"emp":emp});
//     print(response.body);
//     if(response.statusCode==200){
//       status = response.body.trim();
//     }
//
//     return status;
//   }
//
//   Future<List<paySlipModel>>getPaySlip(String year,String usermobile)async{
//     List<paySlipModel> paySlipList = [];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getPaySlip","usermobile":usermobile,"year":year,"device":_identifier,"emp":emp});
//
//     if(response.statusCode==200 && response.body.trim()!="Failed"){
//
//       var data =jsonDecode(response.body.trim());
//       for (var d in data){
//         paySlipList.add(paySlipModel(Mobile: d['Mobile'], Name: d['Name'], Month: int.parse(d['Month']), Year: int.parse(d['Year']), Days: int.parse(d['Days']), LeaveDays: double.parse(d['LeaveDays']), LOP: double.parse(d['TotalLOP']),
//             PresentDays: double.parse(d['PresentDays']), Basic: double.parse(d['Basic']), Allowance: double.parse(d['Allowance']), HRA: double.parse(d['HRA']), TA: double.parse(d['TA']), DA: double.parse(d['DA']), Incentive: double.parse(d['Incentive']), GrossIncome: double.parse(d['GrossIncome']),
//             PF: double.parse(d['PF']), ESIC: double.parse(d['ESIC']), ProTax: double.parse(d['ProTax']), Advance: double.parse(d['Advance']), GrossDeduction: double.parse(d['GrossDeduction']), NetPay: double.parse(d['NetPay']), DOJ: d['DOJ'], Department: d['Department'],Position: d['Position'],
//             BankName: d['BankName'], AccNo: d['AccNum'],UAN: d['UAN'],PAN: d['PAN'],ESICNo: d['ESICNo']));
//       }
//
//     }
//     return paySlipList;
//   }
//
//
//   //Fetch Employer Details
//   Future<List<employerModel>> getEmployer(String shortname)async{
//     List<employerModel> employerList = [];
//     final response = await apiRequest("jilariapi.php",{"action":"getEmployerDetails","emp":emp});
//     if(response.statusCode==200){
//       var data =jsonDecode(response.body.trim());
//       employerList.add(employerModel(name: data['Mess']['EmpName'], shortname: data['Mess']['EmpShortname'], addl1: data['Mess']['AddressL1'], addl2: data['Mess']['AddressL2']));
//
//     }
//     return employerList;
//   }
//
//
//   // Future<String>getPaySlip(String month,String year,String type)async{
//   //   print("Executing get payslip method");
//   //   String res="";
//   //   // String _identifier = (await UniqueIdentifier.serial)!;
//   //   final response = await apiRequest("getPaySlip.php", {"month":month,"year":year,"type": type,"device":_identifier,"emp":emp});
//   //   if(response.statusCode==200){
//   //     // print(response.body.trim());
//   //     var data =jsonDecode(response.body.trim());
//   //     if(data.length==0){
//   //       res = "";
//   //     }
//   //     else{
//   //       res = response.body.trim();
//   //     }
//   //
//   //   }
//   //   return res;
//   // }
//
//   //========================================================================================================================= Policy
//
//
//   //Fetch policy List
//   Future<List<policyModel>> getPolicy()async{
//     List<policyModel> policyList = [];
//     final response = await apiRequest("jilariapi.php", {"action":"getPolicy","emp":emp});
//     if(response.statusCode==200 && response.body.trim()!="Failed"){
//
//       var data =jsonDecode(response.body.trim());
//       for (var d in data){
//         policyList.add(policyModel(id: d['ID'], title: d['Title'],employer: d['Employer'], fileName: d['FileName']));
//       }
//     }
//     return policyList;
//   }
//
//   //upload Policy
//   Future<String> uploadPolicy(File? _selectedFile, String title)async{
//     String status="";
//
//     try {
//       var request = http.MultipartRequest('POST', Uri.parse("$url/jilariapi.php"));
//       request.files.add(await http.MultipartFile.fromPath(
//         'file',
//         _selectedFile!.path,
//         filename: path.basename(_selectedFile.path),
//       ));
//       request.fields['action']="uploadPolicy";
//       request.fields['title']=title;
//       request.fields['device']=_identifier;
//       request.fields['emp']=emp;
//
//       request.headers['Authorization'] = 'Bearer $token';
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         status =await response.stream.bytesToString();
//
//       }
//
//     } catch (e) {
//       // Handle error
//     }
//
//     return status;
//   }
//
//
//   Future<String> deletePolicy(String id)async{
//     String status ="";
//
//     final response = await apiRequest("jilariapi.php", {"action":"deletePolicy","id":id,"emp":emp,"device":_identifier});
//     if(response.statusCode==200){
//       status=response.body.trim();
//     }
//
//     return status;
//   }
//
//   //========================================================================================================================== Holiday
//
//
//   Future<List<eventsModel>>getHoliday()async{
//     List<eventsModel> evenList =[];
//     final response = await apiRequest("jilariapi.php", {"action":"getHoliday","emp":emp});
//     if(response.statusCode==200 && response.body.trim()!="Failed"){
//       var data =jsonDecode(response.body.trim());
//       for (var d in data){
//         evenList.add(eventsModel(id: d['ID'], title: d['Name'], date: d['Date']));
//       }
//     }
//     return evenList;
//   }
//
//   Future<String>postHoliday(String name,String date,)async{
//     String status="";
//     final response = await apiRequest("jilariapi.php", {"action":"postHoliday","emp":emp,"date":date,"name":name,"device":_identifier});
//     if(response.statusCode==200){
//       status=response.body.trim();
//     }
//     return status;
//   }
//
//   Future<String>deleteHoliday(String id)async{
//     String status="";
//     final response = await apiRequest("jilariapi.php", {"action":"deleteHoliday","emp":emp,"id":id,"device":_identifier});
//     if(response.statusCode==200){
//       status=response.body.trim();
//     }
//     return status;
//   }
//
//   Future<List<eventsModel>>getEvents()async{
//     List<eventsModel> evenList =[];
//     final response = await apiRequest("jilariapi.php", {"action":"getEvents","emp":emp});
//     if(response.statusCode==200 && response.body.trim()!="Failed"){
//       var data =jsonDecode(response.body.trim());
//       for (var d in data){
//         evenList.add(eventsModel(id: d['ID'], title: d['Name'], date: d['Event']));
//       }
//     }
//     return evenList;
//   }
//
//   //========================================================================================================================== Settings
//
//   Future<List<String>>fetchSettingsList(String selection,String usermobile)async{
//     List<String> settingsList =[];
//     final response = await apiRequest("jilariapi.php", {"action":"fetchSettingsList","selection":selection,"usermobile":usermobile,"emp":emp});
//     if(response.statusCode==200 && response.body.trim()!="Failed"){
//       var data =jsonDecode(response.body.trim());
//       for (var d in data){
//         settingsList.add(d['Type']);
//       }
//     }
//     return settingsList;
//   }
//
//   Future<String> updateSettingsList(List<String> selectedList,String selection,String usermobile)async{
//     String status="Invalid";
//     final response = await apiRequest("jilariapi.php", {"action":"updateSettingsList","selection":selection,"list":jsonEncode(selectedList),"usermobile":usermobile,"emp":emp});
//     if(response.statusCode==200){
//       status = response.body.trim();
//     }
//
//     return status;
//   }
//
//   Future<String> getQuote(String usermobile,String empCount)async{
//     String status="Invalid";
//     final response = await apiRequest("jilariapi.php", {"action":"getQuote","usermobile":usermobile,"emp":emp,"empCount":empCount});
//
//     if(response.statusCode==200){
//       status = response.body.trim();
//     }
//
//     return status;
//   }
//
//
//   //========================================================================================================================== PAYMENT
//
//   Future<List<Map<String,dynamic>>> getSubscription(String mobile)async{
//     List<Map<String,dynamic>> subList =[];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getSubscription","usermobile": mobile,"emp":emp});
//     // print("response= ${response.body.trim()}");
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body.trim());
//       for(var d in data){
//         subList.add({'Employer':d['Employer'],'Amount':int.parse(d['Amount']),'Expiry':d['Expiry'],'EmpCount':d['EmpCount']});
//       }
//     }
//     return subList;
//
//   }
//
//   Future<String> updatePayment(String mobile,String id,String order,String status)async{
//     // String status ="";
//     final response = await apiRequest("jilariapi.php", {"action":"updatePayment","usermobile": mobile,"emp":emp,"id":id,"order":order,"status":status});
//     // print("response= ${response.body.trim()}");
//     if(response.body.trim()!="Failed"){
//       return "Success";
//     }
//     else{
//       return "Failed";
//     }
//   }
//
//   // Future<String> insertTransaction(String mobile,int amount,int qty,String order)async{
//   //   // String status ="";
//   //   final response = await apiRequest("jilariapi.php", {"action":"insertTransaction","usermobile": mobile,"emp":emp,"amount":amount.toString(),"qty":qty.toString(),"order":order});
//   //   // print("response= ${response.body.trim()}");
//   //   if(response.body.trim()!="Failed"){
//   //     return "Success";
//   //   }
//   //   else{
//   //     return "Failed";
//   //   }
//   // }
//
//   Future<String> getOrderid(String mobile,String amount, String qty)async{
//
//     final response = await apiRequest("jilariapi.php", {"action":"getOrderid","usermobile": mobile,"emp":emp,"amount":amount,"qty":qty});
//
//     if(response.body.trim()!="Failed"){
//       return response.body.trim();
//     }
//     else{
//       return "Failed";
//     }
//   }
//
//   Future<bool> validateSignature(String razorpay_signature,String razorpay_payment_id,String razorpay_order_id)async{
//
//     final response = await apiRequest("jilariapi.php", {"action":"validateSignature","razorpay_signature": razorpay_signature,"razorpay_payment_id":razorpay_payment_id,"razorpay_order_id":razorpay_order_id});
//     if(response.body.trim()=="Signature is valid"){
//       return true;
//     }
//     else{
//       return false;
//     }
//   }
//
//   Future<List<paymentModel>> getPaymentList(String usermobile)async{
//
//     List<paymentModel> paymentList = [];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getPaymentList","usermobile": usermobile,"emp":emp});
//     // print(response.body);
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body.trim());
//       for( var d in data){
//         paymentList.add(paymentModel(ID: d['ID'], Employer: d['Employer'], Amount: d['Amount'], Unit: d['Unit'], Total: d['Total'], FromDate: d['FromDate'], ToDate: d['ToDate'], TransactionID: d['TransactionID'], OrderID: d['OrderID'], Date: d['Date'], Time: d['Time']));
//       }
//     }
//
//     return paymentList;
//
//   }
//
//
//   //========================================================================================================================== OTHER
//
//   //Fetch complied zip file
//   Future<Uint8List>getZip(List<String> usermobile,String fromDate,String toDate,String type)async{
//     Uint8List status =Uint8List(0);
//
//     final response = await apiRequest("jilariapi.php", {"action":"getZip","usermobile": usermobile.toString(),"fromDate":fromDate,"toDate":toDate,"emp":emp,"type":type});
//
//     if(response.body.trim()!='Failed'){
//       status = base64Decode(response.body.trim());
//     }
//
//     return status;
//   }
//
//   //Fetch pending action summary
//   Future<List<summaryModel>> getPendingActions(String usermobile,String per)async{
//     List<summaryModel> pendingList = [];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getPendingActions","usermobile": usermobile,"per":per,"emp":emp});
//
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body.trim());
//       for( var d in data){
//         pendingList.add(summaryModel(type: d['Type'], count: d['Count']));
//       }
//     }
//
//     return pendingList;
//   }
//
//   //Fetch Settings
//   Future<String> getSettings(String parameter)async{
//     String data="";
//     final response = await apiRequest("jilariapi.php", {"action":"getSettings","param": parameter,"emp":emp});
//
//     if(response.body.trim()!="Failed"){
//       data = response.body.trim();
//     }
//     return data;
//   }
//
//
//   //Fetch Accounts details
//   Future<List<String>> getAccounts()async{
//     List<String> Acc= ['Select'];
//     final response = await apiRequest("jilariapi.php", {"action":"getAccounts","device": _identifier,"emp":emp});
//
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body.trim());
//       for( var d in data){
//         Acc.add(d['Type']);
//       }
//     }
//     return Acc;
//   }
//
//
//   //Fetch incomplete drive activity data
//   Future<List<activityModel>> getDriveActivity(String mobile)async{
//     List<activityModel> actList = [];
//
//     final response = await apiRequest("jilariapi.php", {"action":"getDriveActivity","usermobile": mobile});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       String date,time;
//       final sqlDateFormat = DateFormat('yyyy-MM-dd');
//       final sqlTimeFormat = DateFormat('HH:mm');
//       actList.clear();
//       for (var d in data){
//
//         date = DateFormat('dd-MM-yyyy').format(sqlDateFormat.parse(d['Date']));
//         time = DateFormat('Hms').format(sqlTimeFormat.parse(d['Time']));
//
//         actList.add(activityModel(id:d['ID'],mobile: d['Mobile'], name: d['Name'], type: d['Type'], site: d['Site'],drive:bool.parse(d['Drive']),sKM: int.parse(d['StartKM']),eKM: int.parse(d['EndKM']), lat: d['PosLat'], long: d['PosLong'], date: date, time: time,cust: d['Customer'],remarks: d['CustNo']));
//       }
//     }
//
//     return actList;
//   }
//
//
//   //Get default locations
//   Future<List<locationModel>> getDefaultLocations()async{
//     List<locationModel> defaultLocation =[];
//     final response = await apiRequest("jilariapi.php", {"action":"getDefLocation","emp":emp});
//     if(response.body.trim()!="Failed"){
//       var data = jsonDecode(response.body.trim());
//       defaultLocation.clear();
//       for (var d in data){
//         defaultLocation.add(locationModel(ID:d['ID'],locationName: d['Location'], posLat: double.parse(d['PosLat']), posLong: double.parse(d['PosLong']),range: int.parse(d['Range'])));
//       }
//     }
//     return defaultLocation;
//   }
//
//   Future<String> saveLocations(String mobile,String location,String lat,String long,String range)async{
//     String status ="Failed";
//
//     final response = await apiRequest("jilariapi.php", {"action":"saveLocations","usermobile":mobile,"location":location,"lat":lat,"long":long,"range":range,"emp":emp});
//     if(response.statusCode==200){
//       status=response.body.trim();
//     }
//
//     return status;
//   }
//
//   Future<String> deleteLocations(String mobile,String ID)async{
//     String status ="Failed";
//
//     final response = await apiRequest("jilariapi.php", {"action":"deleteLocations","usermobile":mobile,"id":ID,"emp":emp});
//     if(response.statusCode==200){
//       status=response.body.trim();
//     }
//
//     return status;
//   }
//
//   //get dashboard summary
//   Future<String>getDashboardSummary(String mobile,String permission)async{
//     String status="";
//     final response = await apiRequest("jilariapi.php", {"action":"getDashboardSummary","usermobile":mobile,"permission":permission,"emp":emp});
//     // print(response.body);
//     if(response.statusCode==200){
//       status = response.body.trim();
//     }
//     return status;
//   }
//
//   //fetch trackers for downloading
//   Future<String>getTracker(List<String>users,String item,String fromDate, String toDate)async{
//     String status="";
//     final response = await apiRequest("jilariapi.php", {"action":"get_tracker","device":_identifier,"users":users.toString(),"item":item,"fromDate":fromDate,"toDate":toDate,"emp":emp});
//     // print(response.body.trim());
//     if(response.statusCode==200){
//       status = response.body.trim();
//     }
//     return status;
//   }
//
//
//
//   //HTTP request
//   Future<http.Response> apiRequest(String endpoint,Map<String,String> body)async{
//
//     http.Response res = http.Response("", 999);
//     try{
//       print("$url/$endpoint");
//       final response = await http.post(
//         Uri.parse("$url/$endpoint"), body: body,headers: {
//         'Authorization': 'Bearer $token',
//       },
//       );
//       // print(response.body.trim());
//       if(response.body.trim()=="TokenFailed"){
//         SystemNavigator. pop();
//       }
//
//       if(response.statusCode==200){
//         res = response;
//       }
//
//     }
//     catch(e){
//       return res;
//     }
//
//     return res;
//
//   }
//
//
//
//
//
//
//
//
// }