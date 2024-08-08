// import 'dart:convert';
// import 'dart:io';
// // import 'dart:js_util';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:ithiel_hr/Models/activityModel.dart';
// import 'package:ithiel_hr/Models/attendanceModel.dart';
// import 'package:ithiel_hr/Models/billerModel.dart';
// import 'package:ithiel_hr/Models/directoryModel.dart';
// import 'package:ithiel_hr/Models/leaveModel.dart';
// import 'package:ithiel_hr/Models/locationModel.dart';
// import 'package:ithiel_hr/Models/summaryModel.dart';
// import 'package:ithiel_hr/Models/userExpenseModel.dart';
// import 'package:ithiel_hr/Models/userModel.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:unique_identifier/unique_identifier.dart';
//
//
//
// // var url = "https://expense.onyxteleinfra.org";
// var url = "https://attendance.jilaritechnologies.com";
// var token;
//
// // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
// // final SharedPreferences prefs = await _prefs;
// // var savMob=prefs.getString("mob").toString();
// // var savPass="Password";
//
// class apiServices{
//
// //================================================================================================================================================= USERS
//   //Login function
//   Future<String> checkLogin(String mobile,String password,String appVersion)async{
//
//     String status = "";
//
//     if(mobile.length!=10 || password==""){
//       status="Invalid Entry";
//     }
//     else{
//       var data;
//
//       final response = await apiRequest("login.php", {"usermobile": mobile,"userpass": password,"app": appVersion});
//       if (response.statusCode == 200) {
//         status = response.body.trim();
//         data = jsonDecode(response.body);
//         token= data['Token'];
//
//       }
//       else{
//         status="http Error";
//       }
//
//
//       // try{
//       //
//       //
//       //
//       //   final response = await http.post(
//       //       Uri.parse("$url/login.php"), body: {
//       //     "usermobile": mobile,"userpass": password,"app": appVersion
//       //   });
//       //   // print("My Commants : ${response.statusCode}");
//       //   if (response.statusCode == 200) {
//       //     status = response.body.trim();
//       //     data = jsonDecode(response.body);
//       //     token= data['Token'];
//       //
//       //   }
//       //   else{
//       //     status="http Error";
//       //   }
//       // }
//       // catch(e){
//       //   print(e);
//       // }
//
//       // print(data.toString());
//     }
//
//     return status;
//   }
//
//   // Upload Profile Image
//   Future<String> uploadImage(String file,String mobile)async{
//
//     print("executing image upload method");
//     String status="";
//
//     final response = await apiRequest("upload_image.php", {"usermobile":mobile,"file": file,});
//     status = response.body.trim();
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/upload_image.php"),
//     //     body: {
//     //       "usermobile":mobile,"file": file,
//     //     },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //
//     //   if(response.statusCode==200){
//     //     status=response.body.trim();
//     //     print(status);
//     //   }
//     //
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//
//     return status;
//   }
//
//
//   //Api to fetch user details
//   //To get managers list in addEmployeePage
//   //To get employee list under a manager for dashboardPage
//   Future<List<userModel>> getUserDetails(String filter)async{
//     print("Executing get User Details method");
//     // print(filter);
//     List<userModel> userList=[];
//
//     final response = await apiRequest("get_userdetails.php", {"filter":filter});
//     var data = jsonDecode(response.body);
//     userList=[];
//     if(filter!="ALL" || filter!="MANAGER"){
//       for (var d in data){
//
//         userList.add(userModel(Mobile: d['Mobile'], Name: d['Name'], EmployeeID: d['EmployeeID'], Department: d['Department'], Position: d['Position'],Permission: "",Manager: d['Manager'],ManagerID: d['Location']==null?"":d['Location'], LeaveCount: 0.00, LeaveBalance: 0.00, ImageFile: ""));
//       }
//     }
//     else{
//       for (var d in data){
//
//         userList.add(userModel(Mobile: d['Mobile'], Name: d['Name'], EmployeeID: d['EmployeeID'], Department: d['Department'], Position: d['Position'],Permission: "",Manager: d['Manager'],ManagerID: d['ManagerID'], LeaveCount: 0.0, LeaveBalance: 0.0, ImageFile: d['ImageFile']));
//       }
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/get_userdetails.php"), body: {
//     //     // Uri.parse("$url"), body: {
//     //     "filter":filter
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //
//     //   if (response.statusCode == 200) {
//     //     // print(response.body);
//     //     var data = jsonDecode(response.body);
//     //     userList=[];
//     //     if(filter!="ALL" || filter!="MANAGER"){
//     //       for (var d in data){
//     //
//     //         userList.add(userModel(Mobile: d['Mobile'], Name: d['Name'], EmployeeID: d['EmployeeID'], Department: d['Department'], Position: d['Position'],Permission: "",Manager: d['Manager'],ManagerID: d['Location']==null?"":d['Location'], LeaveCount: 0.00, LeaveBalance: 0.00, ImageFile: ""));
//     //       }
//     //     }
//     //     else{
//     //       for (var d in data){
//     //
//     //         userList.add(userModel(Mobile: d['Mobile'], Name: d['Name'], EmployeeID: d['EmployeeID'], Department: d['Department'], Position: d['Position'],Permission: "",Manager: d['Manager'],ManagerID: d['ManagerID'], LeaveCount: 0.0, LeaveBalance: 0.0, ImageFile: d['ImageFile']));
//     //       }
//     //     }
//     //
//     //   }
//     //   else{
//     //
//     //     print("http error");
//     //
//     //   }
//     // }
//     // catch(e){
//     //   print(e);
//     // }
//
//     return userList;
//   }
//
//
//
//   //Change Password
//   Future<String> changePassword(String mob, String pass)async{
//
//     String status="";
//     String _identifier = (await UniqueIdentifier.serial)!;
//
//     final response = await apiRequest("change_password.php", {"usermobile": mob,"userpass":pass,"id":_identifier});
//     if(response.statusCode==200 && response.body.trim()=="Completed"){
//       status="Success";
//     }
//     else{
//       status="Failed";
//     }
//
//     // try{
//     //
//     //   String _identifier = (await UniqueIdentifier.serial)!;
//     //
//     //   // return;
//     //
//     //   final response = await http.post(
//     //     Uri.parse("$url/change_password.php"), body: {
//     //     "usermobile": mob,"userpass":pass,"id":_identifier
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //
//     //   print(response.body);
//     //   if(response.statusCode==200 && response.body.trim()=="Completed"){
//     //     status="Success";
//     //   }
//     //   else{
//     //     status="Failed";
//     //   }
//     //
//     // }
//     // catch(e){
//     //   print(e);
//     // }
//     return status;
//   }
//
//   //Add user
//   Future<String> addUser(userModel newUser)async{
//     print("Executing add user method");
//     String status="";
//     // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//     // final SharedPreferences prefs = await _prefs;
//     // var apass = "password";
//     // var auser = prefs.getString("mob").toString();
//     // print(newUser.toString());
//
//     // return "";
//
//     Map<String, dynamic> user = newUser.toMap();
//     print(user);
//     // print(jsonEncode(user));
//
//     // final response = apiRequest("add_user.php", jsonEncode(user));
//
//     try{
//       final response = await http.post(
//         Uri.parse("$url/add_user.php"), body: jsonEncode(user),
//
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//       print("waiting response");
//       print(response.body);
//       if(response.body.trim()=="TokenFailed"){
//         SystemNavigator. pop();
//       }
//       // var data = jsonDecode(response.body);
//       if(response.statusCode==200){
//         status = response.body;
//       }
//       else{
//         status ="Failed";
//       }
//     }
//     catch(e){
//       print(e);
//     }
//
//     return status;
//   }
//
//
//   //Search directory
//   Future<List<directoryModel>> searchDirectory(String filter)async{
//     List<directoryModel> list = [];
//
//     final response = await apiRequest("searchDirectory.php", {"filter": filter});
//     if (response.statusCode == 200) {
//       list.clear();
//       var data=jsonDecode(response.body.trim());
//       for (var d in data){
//         list.add(directoryModel(Name: d['Name'], Mobile: d['Mobile'], EmployeeID: d['EmployeeID'], Manager: d['Manager'], Position: d['Position'], Department: d['Department'], Image: d['ImageFile']));
//       }
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/searchDirectory.php"), body: {
//     //     "filter": filter
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if (response.body.trim() == "TokenFailed") {
//     //     SystemNavigator.pop();
//     //   }
//     //   print(response.body);
//     //   if (response.statusCode == 200) {
//     //     list.clear();
//     //     var data=jsonDecode(response.body.trim());
//     //     for (var d in data){
//     //       list.add(directoryModel(Name: d['Name'], Mobile: d['Mobile'], EmployeeID: d['EmployeeID'], Manager: d['Manager'], Position: d['Position'], Department: d['Department'], Image: d['ImageFile']));
//     //     }
//     //   }
//     //
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//     return list;
//   }
//
//
//
//   //==================================================================================================================================== Attendance
//   //Fetch Todays attendance status
//   Future<String> attendanceStatus(String mobile)async{
//     String status = "";
//
//     final response = await apiRequest("get_attendanceStatus.php", {"usermobile": mobile});
//     status = response.body.trim();
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/get_attendanceStatus.php"),
//     //     body: {
//     //       "usermobile": mobile
//     //     },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print("My Commants : ${response.statusCode}");
//     //   if (response.statusCode == 200) {
//     //     status= response.body;
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//     return status;
//   }
//
//
//
//   //Update attendance to database
//   Future<String> postAttendance(String name,String mobile,double posLat,double posLong,String location)async{
//     // print(mobile);
//     // return "";
//     String status="";
//
//     final response = await apiRequest("postAttendance.php", {"usermobile": mobile,"username":name,"posLat":posLat.toString(),"posLong":posLong.toString(),"location":location});
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/postAttendance.php"), body: {
//     //     "usermobile": mobile,"username":name,"posLat":posLat.toString(),"posLong":posLong.toString(),"location":location
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   if(response.statusCode==200){
//     //     var data = jsonDecode(response.body);
//     //
//     //     status=data['Status'];
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     //   return "Failed";
//     // }
//     return status;
//   }
//
//   //Fetch attendance data
//   Future<List<attendanceModel>> getAttendanceData(String mobile,int month,int year)async{
//     print("Calling attendance data");
//     List<attendanceModel> attendanceList = [];
//
//     final response = await apiRequest("getAttendanceData.php", {"usermobile": mobile,"month":month.toString(),"year":year.toString(),});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       // print(response.body);
//       String date,time;
//       final sqlDateFormat = DateFormat('yyyy-MM-dd');
//       final sqlTimeFormat = DateFormat('HH:mm');
//       attendanceList.clear();
//       for (var d in data){
//
//         date = DateFormat('dd-MM-yyyy').format(sqlDateFormat.parse(d['Date']));
//         time = DateFormat('Hms').format(sqlTimeFormat.parse(d['Time']));
//
//         attendanceList.add(attendanceModel(Name: d['Name'], Mobile: d['Mobile'], posLat: double.parse(d['PosLat']), posLong: double.parse(d['PosLong']),
//             attDate: date, attTime: time, location: d['Location']));
//       }
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/getAttendanceData.php"), body: {
//     //     "usermobile": mobile,"month":month.toString(),"year":year.toString(),
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print(response.statusCode);
//     //   if(response.statusCode==200){
//     //     var data = jsonDecode(response.body);
//     //     // print(response.body);
//     //     String date,time;
//     //     final sqlDateFormat = DateFormat('yyyy-MM-dd');
//     //     final sqlTimeFormat = DateFormat('HH:mm');
//     //     attendanceList.clear();
//     //     for (var d in data){
//     //
//     //       date = DateFormat('dd-MM-yyyy').format(sqlDateFormat.parse(d['Date']));
//     //       time = DateFormat('Hms').format(sqlTimeFormat.parse(d['Time']));
//     //
//     //       attendanceList.add(attendanceModel(Name: d['Name'], Mobile: d['Mobile'], posLat: double.parse(d['PosLat']), posLong: double.parse(d['PosLong']),
//     //           attDate: date, attTime: time, location: d['Location']));
//     //     }
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//     return attendanceList;
//   }
//
//
//   //Fetch attendance summary data
//   Future<List<summaryModel>> getAttSummary(String mobile,int month,int year)async{
//     print("Calling attendance summary");
//     List<summaryModel> summList = [];
//
//     final response = await apiRequest("getAttSummary.php", {"usermobile": mobile,"month":month.toString(),"year":year.toString()});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//
//       summList.clear();
//       for (var d in data){
//
//         summList.add(summaryModel(location: d['Location'], count: double.parse(d['Count'])));
//       }
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/getAttSummary.php"), body: {
//     //     "usermobile": mobile,"month":month.toString(),"year":year.toString(),
//     //   },headers: {
//     //     'Authorization': 'Bearer $token',
//     //   },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print(response.statusCode);
//     //   if(response.statusCode==200){
//     //     var data = jsonDecode(response.body);
//     //
//     //     summList.clear();
//     //     for (var d in data){
//     //
//     //       summList.add(summaryModel(location: d['Location'], count: double.parse(d['Count'])));
//     //     }
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//     return summList;
//   }
//
//
//   //Update attendance for regularization
//   Future<String> updateAttendance(String mobile,String Date)async{
//     String status = "";
//
//     final response = await apiRequest("updateAttendance.php", {"usermobile": mobile,"date":Date,});
//     status = response.body.trim();
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/updateAttendance.php"), body: {
//     //     "usermobile": mobile,"date":Date,
//     //   },headers: {
//     //     'Authorization': 'Bearer $token',
//     //   },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print(response.statusCode);
//     //   if(response.statusCode==200){
//     //     status = response.body.trim();
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//     return status;
//   }
//
//
//   Future<List<attendanceModel>> getRegularization(String mobile)async{
//     print("executing get regularization method");
//     List<attendanceModel> list =[];
//
//     final response = await apiRequest("getRegularization.php", {"usermobile": mobile,});
//     // print(response.statusCode);
//     // print(response.body);
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body.trim());
//       list.clear();
//       for (var d in data){
//         list.add(attendanceModel(Name: d['Name'], Mobile: d['Mobile'], posLat: 0.00, posLong: 0.00, attDate: d['Date'], attTime: '', location: d['Comments']));
//       }
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/getRegularization.php"), body: {
//     //     "usermobile": mobile,
//     //   },headers: {
//     //     'Authorization': 'Bearer $token',
//     //   },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print(response.statusCode);
//     //   if(response.statusCode==200){
//     //     var data = jsonDecode(response.body.trim());
//     //     list.clear();
//     //     for (var d in data){
//     //       list.add(attendanceModel(Name: d['Name'], Mobile: d['Mobile'], posLat: 0.00, posLong: 0.00, attDate: d['Date'], attTime: '', location: d['Comments']));
//     //     }
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//     return list;
//   }
//
//   //Post regularization request
//   Future<String> postRegularization(String mobile, String name, String date, String comments)async{
//
//     String status ="";
//     final response = await apiRequest("postRegularization.php",{"usermobile":mobile,"username":name,"date":date,"comments":comments});
//
//     return status;
//   }
//
//
//
//
//
//   //========================================================================================================================================= LEAVE
//
//
//   //Apply Leave
//   Future<String> applyLeave(String mobile,String name,String date,String comments,String halfDay)async{
//     String status="";
//
//     // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//     // final SharedPreferences prefs = await _prefs;
//     // var mobile=prefs.getString("mob").toString();
//     // var name = prefs.get("name").toString();
//
//     final response = await apiRequest("postLeave.php", {"usermobile": mobile,"username": name,"leavedate":date,"comments":comments,"halfDay":halfDay});
//     if(response.statusCode == 200) {
//       // print(response.body);
//       var data = jsonDecode(response.body.trim());
//       if(data['Status']=="Success"){
//         status=data['Mess'];
//       }
//     }
//     else{
//       status="Failed";
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/postLeave.php"), body: {
//     //     "usermobile": mobile,"username": name,"leavedate":date,"comments":comments,"halfDay":halfDay
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   print(response.statusCode);
//     //   if(response.statusCode == 200) {
//     //     // print(response.body);
//     //     var data = jsonDecode(response.body.trim());
//     //     if(data['Status']=="Success"){
//     //       status=data['Mess'];
//     //     }
//     //   }
//     //   else{
//     //     status="Failed";
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//     return status;
//   }
//
//
//   //Fetch applied leave list
//   Future<List<leaveModel>>getLeaves(String mobile, String year)async{
//     print("executing getLeave method");
//     // print(year);
//     // print(mobile);
//     List<leaveModel> leaveList = [];
//
//     final response = await apiRequest("etLeave.php", {"usermobile": mobile,"year":year});
//     if(response.statusCode == 200) {
//       // print(response.body);
//       if(response.body.trim()!="Failed"){
//         var data = jsonDecode(response.body.trim());
//         leaveList.clear();
//         for (var d in data){
//           leaveList.add(leaveModel(Id: d['ID'], Mobile: d['Mobile'], Name: d['Name'], LeaveDate: d['LeaveDate'],HalfDay: bool.parse(d['HalfDay']), LOP:double.parse(d['LOP']),AppliedTime: d['AppliedTime'], AppliedDate: d['AppliedDate'], Status: d['Status'],Comments: d['Comments'], L1Status: d['L1Status'],L1Comments: d['L1Comments'],L2Status: d['L2Status'],L2Comments: d['L2Comments']));
//         }
//       }
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/getLeave.php"), body: {
//     //     "usermobile": mobile,"year":year
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //   // print(response.body);
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print(response.statusCode);
//     //   if(response.statusCode == 200) {
//     //     // print(response.body);
//     //     if(response.body.trim()!="Failed"){
//     //       var data = jsonDecode(response.body.trim());
//     //       leaveList.clear();
//     //       for (var d in data){
//     //         leaveList.add(leaveModel(Id: d['ID'], Mobile: d['Mobile'], Name: d['Name'], LeaveDate: d['LeaveDate'],HalfDay: bool.parse(d['HalfDay']), LOP:double.parse(d['LOP']),AppliedTime: d['AppliedTime'], AppliedDate: d['AppliedDate'], Status: d['Status'],Comments: d['Comments'], L1Status: d['L1Status'],L1Comments: d['L1Comments'],L2Status: d['L2Status'],L2Comments: d['L2Comments']));
//     //       }
//     //     }
//     //   }
//     //   else{
//     //
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//
//     return leaveList;
//   }
//
//   //Delete applied leave
//   //Input : Leave ID
//   //Output:
//   Future<String>deleteLeave(String ID,String type)async{
//
//     print("executing delete Leave method");
//     String status ="";
//
//     final response = await apiRequest("eleteLeave.php", {"id": ID,"type":type});
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
//     // try {
//     //   final response = await http.post(
//     //     Uri.parse("$url/deleteLeave.php"), body: {
//     //     "id": ID,"type":type
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if (response.body.trim() == "TokenFailed") {
//     //     SystemNavigator.pop();
//     //   }
//     //   // print(response.statusCode);
//     //   if (response.statusCode == 200) {
//     //     var data = jsonDecode(response.body.trim());
//     //     if(data['Status']=="Success"){
//     //       status=data['Mess'];
//     //     }
//     //   }
//     //   else{
//     //     status="Failed";
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//
//     return status;
//
//   }
//
//
//   Future<String> updateLeave(String id,String per,String approval, String comments)async{
//     String status = "";
//
//     final response = await apiRequest("updateLeave.php", {"id": id, "status":approval,"comments":comments,"per":per});
//     if (response.statusCode == 200) {
//       status=response.body.trim();
//     }
//     else{
//       status="Failed";
//     }
//
//     // try {
//     //   final response = await http.post(
//     //     Uri.parse("$url/updateLeave.php"), body: {
//     //     "id": id, "status":approval,"comments":comments,"per":per
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if (response.body.trim() == "TokenFailed") {
//     //     SystemNavigator.pop();
//     //   }
//     //   // print(response.statusCode);
//     //   if (response.statusCode == 200) {
//     //     status=response.body.trim();
//     //   }
//     //   else{
//     //     status="Failed";
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//     return status;
//   }
//
//
//
//   //========================================================================================================================================= EXPENSE
//   // Api to fetch user expenses
//   Future<List<userExpenseModel>> getUserExpenses(String mob,String mon, String year,String type)async{
//     print("executing getUserExpenses method");
//     // print(mob);
//     // print(mon);
//     // print(year);
//     // print(type);
//     List<userExpenseModel> userExpenseList=[];
//
//     final response = await apiRequest("get_userexpense.php", {"usermobile": mob,"mon":mon,"year":year,"type":type});
//     if (response.statusCode == 200) {
//       // print(response.body);
//       var data = jsonDecode(response.body);
//       userExpenseList.clear();
//       for (var d in data){
//         userExpenseList.add(userExpenseModel(ID:d['ID'],Mobile: d['Mobile'], Name: d['Name'],Site: d['Site'],FromLoc: d['FromLoc'],ToLoc: d['ToLoc'],KM: d['KM'], Date : d['Date'], Type: d['Type'], ShopName: d['ShopName']==null?"":d['ShopName'],ShopDist: d['District']==null?"":d['District'],ShopPhone: d['Phone']==null?"":d['Phone'],ShopGst: d['GST']==null?"":d['GST'],BillNo: d['BillNo'], Amount: d['Amount'], Filename: d['Filename'],Status: d['Status'],L1Status: d['L1Status'],L1Comments: d['L1Comments'],L2Status: d['L2Status'],L2Comments: d['L2Comments']));
//       }
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/get_userexpense.php"),
//     //     body: {
//     //       "usermobile": mob,"mon":mon,"year":year,"type":type
//     //     },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print("My Commants : ${response.statusCode}");
//     //   if (response.statusCode == 200) {
//     //     // print(response.body);
//     //     var data = jsonDecode(response.body);
//     //
//     //     // print(data);
//     //     userExpenseList.clear();
//     //     for (var d in data){
//     //       // print(d['Name']);
//     //       // print(d['Site']);
//     //       // print(d['FromLoc']);
//     //       // print(d['ToLoc']);
//     //       // print(d['KM']);
//     //       // print(d['Date']);
//     //
//     //       userExpenseList.add(userExpenseModel(ID:d['ID'],Mobile: d['Mobile'], Name: d['Name'],Site: d['Site'],FromLoc: d['FromLoc'],ToLoc: d['ToLoc'],KM: d['KM'], Date : d['Date'], Type: d['Type'], ShopName: d['ShopName']==null?"":d['ShopName'],ShopDist: d['District']==null?"":d['District'],ShopPhone: d['Phone']==null?"":d['Phone'],ShopGst: d['GST']==null?"":d['GST'],BillNo: d['BillNo'], Amount: d['Amount'], Filename: d['Filename'],Status: d['Status'],L1Status: d['L1Status'],L1Comments: d['L1Comments'],L2Status: d['L2Status'],L2Comments: d['L2Comments']));
//     //     }
//     //
//     //   }
//     //   else{
//     //     print("http error");
//     //   }
//     // }
//     // catch(e){
//     //   print(e);
//     // }
//     return userExpenseList;
//   }
//
//
//   //Clear Bill
//   Future<String> clearBill(String billId,String buttonValue,String comment)async{
//     String status="";
//     // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//     // final SharedPreferences prefs = await _prefs;
//     // var savMob=prefs.getString("mob").toString();
//     // var savPass="Password";
//
//     final response = await apiRequest("clear_bill.php", {"billid": billId, "status":buttonValue, "comments":comment});
//     if(response.statusCode==200 && response.body.trim()=="Completed"){
//       // await apiServices().getUserExpenses(widget.mobile);
//       status = "Success";
//
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/clear_bill.php"), body: {
//     //     "usermobile": savMob,"password":savPass,"billid": billId, "status":buttonValue, "comments":comment
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   if(response.statusCode==200 && response.body.trim()=="Completed"){
//     //     // await apiServices().getUserExpenses(widget.mobile);
//     //     status = "Success";
//     //
//     //   }
//     //   else{
//     //     print("Failed");
//     //     status="Failed";
//     //     // setState(() {
//     //     //   refresh=false;
//     //     // });
//     //   }
//     // }
//     // catch(e){
//     //   print(e);
//     // }
//
//     return status;
//   }
//
//
//   //Get Bill image
//   //Get profile image
//   Future<Uint8List> getBill(String item,String type)async{
//     print("Calling getBill function2");
//     Uint8List profileImage=Uint8List(0);
//     final response = await apiRequest("get_billImage.php", {"filename":item,"type":type});
//     if(response.statusCode==200){
//       var data = response.body.trim();
//       profileImage=base64Decode(data);
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/get_billImage.php"), body: {
//     //     "filename":item,"type":type
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //
//     //   // print(response.statusCode);
//     //   if(response.statusCode==200){
//     //     var data = response.body.trim();
//     //     profileImage=base64Decode(data);
//     //   }
//     //
//     // }
//     // catch(e){
//     //   print(e);
//     // }
//     return profileImage;
//   }
//
//   //Delete Bill
//   Future<String> deleteBill(String mobile,String selectedID)async{
//     String status="";
//
//     final response = await apiRequest("delete_bill.php", {"usermobile": mobile,"billid": selectedID});
//     if(response.statusCode==200 && response.body.trim()=="Completed"){
//       status="Success";
//     }
//     else{
//       print("Failed");
//       status="Failed";
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/delete_bill.php"), body: {
//     //     "usermobile": mobile,"billid": selectedID
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   if(response.statusCode==200 && response.body.trim()=="Completed"){
//     //     status="Success";
//     //   }
//     //   else{
//     //     print("Failed");
//     //     status="Failed";
//     //   }
//     // }
//     // catch(e){
//     //   print(e);
//     // }
//     return status;
//   }
//
//   //Update Expense
//   Future<String> updateBill(String id,String per,String approval, String comments)async{
//     String status = "";
//
//     final response = await apiRequest("updateExpense.php", {"id": id, "status":approval,"comments":comments,"per":per});
//     if (response.statusCode == 200) {
//       status="Succeess";
//     }
//     else{
//       status="Failed";
//     }
//
//     // try {
//     //   final response = await http.post(
//     //     Uri.parse("$url/updateExpense.php"), body: {
//     //     "id": id, "status":approval,"comments":comments,"per":per
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if (response.body.trim() == "TokenFailed") {
//     //     SystemNavigator.pop();
//     //   }
//     //   // print(response.statusCode);
//     //   if (response.statusCode == 200) {
//     //     status="Succeess";
//     //   }
//     //   else{
//     //     status="Failed";
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//     return status;
//   }
//
//   //Upload Bill
//   Future<String> uploadBill(String mobile,String name,String type,String site,String fromLoc,String toLoc,String km,String billno,String amt,String date,String file,String avail)async{
//     String status ="";
//
//     final response = await apiRequest("upload_bill.php", {"usermobile": mobile,"username":name,"type": type,"site": site,"fromLoc": fromLoc,"toLoc": toLoc,"km": km,"billno":billno,
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
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/upload_bill.php"), body: {
//     //     "usermobile": mobile,"username":name,"type": type,"site": site,"fromLoc": fromLoc,"toLoc": toLoc,"km": km,"billno":billno,
//     //     "billamount":amt,"billdate":date,"file":file,"fileavailable":avail,
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   print(response.body);
//     //   if(response.statusCode == 200) {
//     //     var data = jsonDecode(response.body);
//     //     if (data['Status'] == "Success") {
//     //       status="Success";
//     //     }
//     //     else{
//     //       status="Failed";
//     //     }
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     //   status="Failed";
//     // }
//
//     return status;
//   }
//
//   //Upload Purchase Bill
//   Future<String> uploadPurchaseBill(String mobile,String name,String type,String billno,String amt,String date,String file,String avail, billerModel biller)async{
//     String status ="";
//
//     final response = await apiRequest("upload_purchasebill.php", {"usermobile": mobile,"username":name,"type": type,"billno":billno,"billamount":amt,"billdate":date,"file":file,"fileavailable":avail,"id":biller.id,
//       "shop":biller.name,"l1":biller.addressl1,"l2":biller.addressl2,"l3":biller.addressl3,"dist":biller.district,"phone":biller.mobile,"gst":biller.gst});
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
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/upload_purchasebill.php"), body: {
//     //     "usermobile": mobile,"username":name,"type": type,"billno":billno,"billamount":amt,"billdate":date,"file":file,"fileavailable":avail,"id":biller.id,
//     //     "shop":biller.name,"l1":biller.addressl1,"l2":biller.addressl2,"l3":biller.addressl3,"dist":biller.district,"phone":biller.mobile,"gst":biller.gst
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   print(response.body);
//     //   if(response.statusCode == 200) {
//     //     var data = jsonDecode(response.body);
//     //     if (data['Status'] == "Success") {
//     //       status="Success";
//     //     }
//     //     else{
//     //       status="Failed";
//     //     }
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     //   status="Failed";
//     // }
//
//     return status;
//   }
//
//
//
//   //Get Biller data
//   Future<List<billerModel>> getBiller(String filter, String type)async{
//     List<billerModel> list =[];
//
//     final response = await apiRequest("getBiller.php", {"filter":filter,"type":type});
//     if (response.statusCode == 200) {
//       list.clear();
//       var data=jsonDecode(response.body.trim());
//       for (var d in data){
//         list.add(billerModel(id: d['ID'], name: d['ShopName'], addressl1: d['AddressL1'], addressl2: d['AddressL2'], addressl3: d['AddressL3'], district: d['District'], mobile: d['Phone'], gst: d['GST']));
//       }
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/getBiller.php"),body:{"filter":filter,"type":type},
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //   print("AAA");
//     //   print(response.body);
//     //   if (response.body.toString().trim()=="TokenFailed") {
//     //     print("system.pop");
//     //     SystemNavigator.pop();
//     //   }
//     //   // print("AAA");
//     //   // print(response.body);
//     //   if (response.statusCode == 200) {
//     //     list.clear();
//     //     var data=jsonDecode(response.body.trim());
//     //     for (var d in data){
//     //       list.add(billerModel(id: d['ID'], name: d['ShopName'], addressl1: d['AddressL1'], addressl2: d['AddressL2'], addressl3: d['AddressL3'], district: d['District'], mobile: d['Phone'], gst: d['GST']));
//     //     }
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//
//     return list;
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
//     print("Calling update drive activity");
//     String status="";
//
//     if(int.parse(sKM)>int.parse(eKM)){
//       return "Failed";
//     }
//
//     final response = await apiRequest("updateDriveActivity.php", {"id": ID.toString(),"sKM":sKM.toString(),"eKM":eKM.toString()});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       status=data['Status'];
//       // print("status===== $status");
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/updateDriveActivity.php"), body: {
//     //     "id": ID.toString(),"sKM":sKM.toString(),"eKM":eKM.toString(),
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print(response.body);
//     //   if(response.statusCode==200){
//     //     var data = jsonDecode(response.body);
//     //     status=data['Status'];
//     //     // print("status===== $status");
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//     return status;
//   }
//
//
//   //Fetch activity data
//   Future<List<activityModel>> getActivity(String mobile,String date,String type)async{
//     print("Calling activity data");
//     // print(date);
//     List<activityModel> actList = [];
//
//     final response = await apiRequest("getActivity.php", {"usermobile": mobile,"date":date,"type":type});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       // print(response.body);
//       String date,time;
//       final sqlDateFormat = DateFormat('yyyy-MM-dd');
//       final sqlTimeFormat = DateFormat('HH:mm');
//       actList.clear();
//       for (var d in data){
//
//         date = DateFormat('dd-MM-yyyy').format(sqlDateFormat.parse(d['Date']));
//         time = DateFormat('Hms').format(sqlTimeFormat.parse(d['Time']));
//         // print(d['Drive']);
//
//         actList.add(activityModel(id:d['ID'],mobile: d['Mobile'], name: d['Name'], site: d['Site'],drive:bool.parse(d['Drive']),sKM: int.parse(d['StartKM']),eKM: int.parse(d['EndKM']), lat: d['PosLat'], long: d['PosLong'], activity: d['Activity'], date: date, time: time));
//       }
//     }
//
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/getActivity.php"), body: {
//     //     "usermobile": mobile,"date":date,"type":type
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print(response.body);
//     //   if(response.statusCode==200){
//     //     var data = jsonDecode(response.body);
//     //     // print(response.body);
//     //     String date,time;
//     //     final sqlDateFormat = DateFormat('yyyy-MM-dd');
//     //     final sqlTimeFormat = DateFormat('HH:mm');
//     //     actList.clear();
//     //     for (var d in data){
//     //
//     //       date = DateFormat('dd-MM-yyyy').format(sqlDateFormat.parse(d['Date']));
//     //       time = DateFormat('Hms').format(sqlTimeFormat.parse(d['Time']));
//     //       // print(d['Drive']);
//     //
//     //       actList.add(activityModel(id:d['ID'],mobile: d['Mobile'], name: d['Name'], site: d['Site'],drive:bool.parse(d['Drive']),sKM: int.parse(d['StartKM']),eKM: int.parse(d['EndKM']), lat: d['PosLat'], long: d['PosLong'], activity: d['Activity'], date: date, time: time));
//     //     }
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//     return actList;
//   }
//
//
//
//   //Delete Activity
//   Future<String> deleteActivity(String mobile,String id)async{
//     String status="";
//
//     final response = await apiRequest("deleteActivity.php", {"usermobile": mobile,"id":id});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       status=data['Status'];
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/deleteActivity.php"), body: {
//     //     "usermobile": mobile,"id":id,
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   if(response.statusCode==200){
//     //     var data = jsonDecode(response.body);
//     //     status=data['Status'];
//     //   }
//     //
//     // }
//     // catch(e){
//     //   print(e.toString());
//     //   status ="Failed";
//     // }
//
//     return status;
//   }
//
//
//   //Post Activity
//   Future<String> postActivity(String name, String mobile,String site,String date,bool drive,String startKM, String endKM, String lat, String long,String activity)async{
//     // print(mobile);
//     // return "";
//     print("Calling postActivity method");
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
//     final response = await apiRequest("postActivity.php", {"usermobile": mobile,"username":name,"site":site,"date":date,"drive":drive.toString(),"sKM":sKM.toString(),"eKM":eKM.toString(),"lat":lat,"long":long,"activity":activity,});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       status=data['Status'];
//       // print(status);
//     }
//
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/postActivity.php"), body: {
//     //     "usermobile": mobile,"username":name,"site":site,"date":date,"drive":drive.toString(),"sKM":sKM.toString(),"eKM":eKM.toString(),"lat":lat,"long":long,"activity":activity,
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   print(response.body);
//     //   if(response.statusCode==200){
//     //     var data = jsonDecode(response.body);
//     //     status=data['Status'];
//     //     // print(status);
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//     return status;
//   }
//
//
//
//
//
//
//   //========================================================================================================================== OTHER
//
//   //Fetch incomplete drive activity data
//   Future<List<activityModel>> getDriveActivity(String mobile)async{
//     print("Calling activity data");
//     List<activityModel> actList = [];
//
//     final response = await apiRequest("getDriveActivity.php", {"usermobile": mobile});
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       // print(response.body);
//       String date,time;
//       final sqlDateFormat = DateFormat('yyyy-MM-dd');
//       final sqlTimeFormat = DateFormat('HH:mm');
//       actList.clear();
//       for (var d in data){
//
//         date = DateFormat('dd-MM-yyyy').format(sqlDateFormat.parse(d['Date']));
//         time = DateFormat('Hms').format(sqlTimeFormat.parse(d['Time']));
//         // print(d['Drive']);
//
//         actList.add(activityModel(id:d['ID'],mobile: d['Mobile'], name: d['Name'], site: d['Site'],drive:bool.parse(d['Drive']),sKM: int.parse(d['StartKM']),eKM: int.parse(d['EndKM']), lat: d['PosLat'], long: d['PosLong'], activity: d['Activity'], date: date, time: time));
//       }
//     }
//
//     // try{
//     //   final response = await http.post(
//     //     Uri.parse("$url/getDriveActivity.php"), body: {
//     //     "usermobile": mobile,
//     //   },
//     //     headers: {
//     //       'Authorization': 'Bearer $token',
//     //     },
//     //   );
//     //
//     //   if(response.body.trim()=="TokenFailed"){
//     //     SystemNavigator. pop();
//     //   }
//     //   // print(response.statusCode);
//     //   if(response.statusCode==200){
//     //     var data = jsonDecode(response.body);
//     //     // print(response.body);
//     //     String date,time;
//     //     final sqlDateFormat = DateFormat('yyyy-MM-dd');
//     //     final sqlTimeFormat = DateFormat('HH:mm');
//     //     actList.clear();
//     //     for (var d in data){
//     //
//     //       date = DateFormat('dd-MM-yyyy').format(sqlDateFormat.parse(d['Date']));
//     //       time = DateFormat('Hms').format(sqlTimeFormat.parse(d['Time']));
//     //       // print(d['Drive']);
//     //
//     //       actList.add(activityModel(id:d['ID'],mobile: d['Mobile'], name: d['Name'], site: d['Site'],drive:bool.parse(d['Drive']),sKM: int.parse(d['StartKM']),eKM: int.parse(d['EndKM']), lat: d['PosLat'], long: d['PosLong'], activity: d['Activity'], date: date, time: time));
//     //     }
//     //   }
//     // }
//     // catch(e){
//     //   print(e.toString());
//     // }
//     return actList;
//   }
//
//
//   //Get default locations
//   Future<List<locationModel>> getDefaultLocations()async{
//     print("Calling getDefaultLocations in apiServices");
//     // locationModel defaultLocation = locationModel(locationName: "", posLat: 0.00, posLong: 0.00);
//     List<locationModel> defaultLocation =[];
//     // final response = await apiRequest("getDefLocation.php",{"null":""});
//     // print(response.statusCode);
//     // if(response.statusCode==200){
//     //   var data = jsonDecode(response.body);
//     //   defaultLocation.clear();
//     //   print(data);
//     //   for (var d in data){
//     //
//     //     defaultLocation.add(locationModel(locationName: d['Location'], posLat: double.parse(d['PosLat']), posLong: double.parse(d['PosLong'])));
//     //   }
//     // }
//
//     var data;
//
//     try{
//       final response = await http.post(Uri.parse("$url/getDefLocation.php"),
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
//         data = jsonDecode(response.body);
//         defaultLocation.clear();
//         // print(data);
//         for (var d in data){
//
//           defaultLocation.add(locationModel(locationName: d['Location'], posLat: double.parse(d['PosLat']), posLong: double.parse(d['PosLong'])));
//         }
//       }
//       else{
//         print("HTTP Error");
//       }
//     }
//     catch(e){
//       print(e.toString());
//     }
//     return defaultLocation;
//   }
//
//
//   Future<http.Response> apiRequest(String endpoint,Map<String,String> body)async{
//     // String res="";
//     // print(endpoint);
//     // print(body);
//     http.Response res = http.Response("", 999);
//     try{
//       // print("pushing http request");
//       final response = await http.post(
//         Uri.parse("$url/$endpoint"), body: body,headers: {
//         'Authorization': 'Bearer $token',
//       },
//       );
//
//       if(response.body.trim()=="TokenFailed"){
//         SystemNavigator. pop();
//       }
//       // print(response.statusCode);
//       // print(response.body);
//       if(response.statusCode==200){
//         res = response;
//       }
//
//     }
//     catch(e){
//       print(e.toString());
//     }
//
//     return res;
//
//   }
//
//
//
//
// }