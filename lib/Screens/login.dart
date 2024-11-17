import 'dart:convert';
import 'package:einlogica_hr/Screens/registration.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Models/userExpenseModel.dart';
import 'package:einlogica_hr/Screens/homePage.dart';
import 'package:einlogica_hr/services/apiServices.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:math' as math;

import 'package:upgrader/upgrader.dart';

import '../style/patternPainter.dart';



TextEditingController _mobileCtrl = TextEditingController();
TextEditingController _passwordCtrl= TextEditingController();
TextEditingController _newpass1Ctrl= TextEditingController();
TextEditingController _newpass2Ctrl= TextEditingController();

var savMob,savPass,mobile,password,_error,mob,name,permission,department;
bool loginPressed=false;
bool defPass=false;

// var appVersion ="V1";
var logo = "assets/myhr.png";
// bool updateAvailable = false;
// Uint8List appfile= Uint8List(0);

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  var w=0.00,h=0.00,t=0.00;
  List<userExpenseModel> userExpenseList=[];

  @override
  void initState() {
    // initFCM();
    // _setupFirebaseMessaging();

    _requestNotificationPermissions();
    // TODO: implement initState
    super.initState();
    _getPrefs();
    _error="";
  }

  // Future<void> requestMediaPermissions() async {
  //   print("Requesting Media Permission");
  //   if (await Permission.mediaLibrary.request().isGranted) {
  //     // Permission is granted
  //   } else {
  //     // Handle the case where the user denies the permission
  //     print('Permission denied');
  //   }
  // }


  void _requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // await requestMediaPermissions();
  }

  void _getPrefs()async{

    final SharedPreferences prefs = await _prefs;
    savMob=prefs.getString("mob").toString();
    // print(savMob);
    // savPass=prefs.getString("pass").toString();
    if(savMob.length>7){
      _mobileCtrl.text=savMob;
      // _passwordCtrl.text=savPass;
    }
  }

  @override
  Widget build(BuildContext context) {

    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;


    _mobileCtrl.addListener(() {
      mobile=_mobileCtrl.text;
    });

    _passwordCtrl.addListener(() {
      password=_passwordCtrl.text;
    });

    return Scaffold(
      body: UpgradeAlert(
        showLater: true,
        showIgnore: false,
        showReleaseNotes: false,
        dialogStyle: UpgradeDialogStyle.cupertino,
        // upgrader: Upgrader(
          // debugDisplayAlways: true,
          // debugLogging: true,
        // ),
        child: CustomPaint(
          painter: PatternPainter(),
          child: Center(
            child: Container(
              width: w>h?w/2:w,
              height: w>h?h/2:h,
              decoration: const BoxDecoration(
                  // gradient: LinearGradient(
                  //   begin: Alignment.bottomCenter,
                  //   end: Alignment.topCenter,
                  //   colors: [Color(0xff020024),Color(0xff0c0c5b)],
                  // ),
                  // color: Colors.white
              ),
              child: Container(
                width: w-50,
                // height: h/3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.grey,
                ),
                child: Stack(
                  children: [
                    !defPass?Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // SizedBox(
                          //   width: w,
                          //   height: 80,
                          //   child: Image(image: AssetImage('$logo'),),
                          //
                          // ),
                          // const Text("Spectra Telecom",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                          // const SizedBox(height: 20,),
                          SizedBox(
                            width: w-(w/3),
                              child: Text("Sign In",style: TextStyle(fontSize: 30,color: Colors.blue),),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            width: w-(w/3),
                            child: Text("Please use your credentials",style: TextStyle(fontSize: 12,color: Colors.grey),),
                          ),
                          const SizedBox(height: 40,),
                          SizedBox(
                            width: w-(w/3),
                            // height: 50,
                            child:TextFormField(
                              enabled: true,
                              controller: _mobileCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone),
                                hintText: "Mobile",
                                enabled: true,
                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue.shade900),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            )
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(
                              width: w-w/3,
                              // height: 50,
                              child:TextFormField(
                                enabled: true,
                                obscureText: true,
                                controller: _passwordCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.password),
                                  hintText: "Pin",
                                  enabled: true,
                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue.shade900),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              )
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(
                            width: w-w/3,
                            child: ElevatedButton(
                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                                onPressed: (){
                              _onLogin();
                                },
                                child: const Text("Login",style: TextStyle(color: Colors.white),)),
                          ),

                          const SizedBox(height: 20,),
                          SizedBox(
                            child: Row(
                              children: [
                                Spacer(),
                                Text("New Registration? "),
                                SizedBox(width: 5,),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return registration();
                                    }));
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.blue
                                    ),
                                    child: Icon(Icons.arrow_forward,color: Colors.white,),
                                  ),
                                ),
                                // SizedBox(width: 20,),
                                Spacer(),
                              ],
                            ),
                          )
                          // Container(
                          //   width: w-100,
                          //   height: 20,
                          //   child: Center(child: Text("$_error",style: TextStyle(color: Colors.red),),),
                          // )
                        ],
                      ),
                    ):SizedBox(),
                    defPass?Center(
                      child: Container(
                        width: w>h?w/2-50:w-50,
                        height: h/3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: w>h?w/2-50:w-50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                                color: Colors.green,
                              ),

                              child: const Center(
                                child: Text("Change Password",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),),
                              ),
                            ),
                            SizedBox(
                              width: w>h?w/2-50:w-50,
                              height: 50,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: w>h?w/8:w/4,
                                    height: 40,
                                    child: const Center(child: Text("New Pin",style: TextStyle(fontWeight: FontWeight.bold),),),
                                  ),
                                  SizedBox(
                                    width: w>h?w/4:w/2,
                                    // height: 40,
                                    child: TextFormField(
                                      enabled: true,
                                      maxLength: 6,

                                      controller: _newpass1Ctrl,
                                      keyboardType: TextInputType.number,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        // icon: Icon(Icons.phone),
                                        hintText: 'max 6 digit',
                                        counterText: '',
                                        enabled: true,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: w>h?w/2-50:w-50,
                              height: 50,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: w>h?w/8:w/4,
                                    height: 40,
                                    child: const Center(child: Text("Confirm Pin",style: TextStyle(fontWeight: FontWeight.bold),),),
                                  ),
                                  SizedBox(
                                    width: w>h?w/4:w/2,
                                    // height: 40,
                                    child: TextFormField(
                                      enabled: true,
                                      maxLength: 6,
                                      controller: _newpass2Ctrl,
                                      keyboardType: TextInputType.number,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        // icon: Icon(Icons.phone),
                                        hintText: 'max 6 digit',
                                        counterText: '',
                                        enabled: true,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: w-100,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: (){
                                        setState(() {
                                          // _mobileCtrl.text="";
                                          _passwordCtrl.text="";
                                          _newpass1Ctrl.text="";
                                          _newpass2Ctrl.text="";
                                          defPass=false;
                                        });

                                      },
                                      child: const Text("Cancel")
                                  ),
                                  ElevatedButton(
                                      onPressed: ()async{

                                        setState(() {
                                          loginPressed=true;
                                        });

                                        if(_newpass1Ctrl.text==_newpass2Ctrl.text && _newpass1Ctrl.text.length>3){
                                          String status = await apiServices().changePassword(_mobileCtrl.text, _passwordCtrl.text,_newpass2Ctrl.text,false);
                                          // print("Status ===== $status");

                                          if(status=="Success"){
                                            _error="Password Changed; Login again";
                                            showMessage(_error);
                                            loginPressed=false;
                                            defPass=false;
                                          }
                                          else{
                                            _error="Something went wrong";
                                          }

                                          // _mobileCtrl.text="";
                                          _passwordCtrl.text="";
                                          _newpass1Ctrl.text="";
                                          _newpass2Ctrl.text="";
                                          loginPressed=false;
                                          setState(() {

                                          });
                                          Future.delayed(const Duration(seconds: 2),(){
                                              setState(() {
                                                _error="";
                                              });
                                            });

                                        }
                                        else{
                                          _error="Invalid Password";
                                          showMessage(_error);
                                          // _mobileCtrl.text="";
                                          _passwordCtrl.text="";
                                          _newpass1Ctrl.text="";
                                          _newpass2Ctrl.text="";
                                          // print(_error);
                                          setState(() {
                                            loginPressed=false;
                                            // defPass=false;
                                          });
                                        }

                                      },
                                      child: const Text("Submit")
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10,)

                          ],
                        ),
                      ),
                    ):const SizedBox(),
                    loginPressed?Center(
                      child: Center(
                        child: Container(
                          width: w-20,
                          height: h/3+100,
                          color: Colors.white.withOpacity(.6),
                          child: const Center(child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ),),
                        ),
                      ),
                    ):const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }


  _onLogin()async{

    if(_mobileCtrl.text.length!=10 || _passwordCtrl.text.length<4){
      showMessage("Invalid Inputs");
      return;
    }

    setState(() {
      loginPressed=true;
      // _error="";
    });


    String status = await apiServices().checkLogin(_mobileCtrl.text, _passwordCtrl.text);
    // print(status);
    if(status=="http Error" || status=="Failed"){
      showMessage("Failed to login");
      setState(() {
        loginPressed=false;
        // _error="";
      });
      return;
    }


    var req = jsonDecode(status);
    // print(req);
    var data = req['Data'];
    //device ID

    if(req['Status']=="Success"){

      // var id = data['Tocken'];

      userModel currentUser = userModel(Mobile: data['Mobile'], Name: data['Name'], Email: data['Email']??"",EmployeeID: data['EmployeeID'], Employer: data['Employer'],Department: data['Department'], Position: data['Position'],
          Permission: data['Permission'], Manager: data['Manager'], ManagerID: data['ManagerID'],DOJ: data['DOJ'], LeaveCount: double.parse(data['LeaveCount']), Status: data['Status'], ImageFile: data['ImageFile']);

      // print("Image file:");
      // print(data['ImageFile']);

      if(data['resetpassword']=='TRUE'){
        //Change Password
        setState(() {
          defPass=true;
          loginPressed=false;
        });
      }
      else{
        //go to home page
        setState(() {
          loginPressed=false;
          _passwordCtrl.clear();
        });
        final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        final SharedPreferences prefs = await _prefs;
        prefs.setString("mob",data['Mobile']);

        routeToHome(currentUser);

      }

    }
    else{
      _error=req['Data'];

      showMessage(_error);
      setState(() {
        loginPressed=false;
      });
    }

  }

  routeToHome(userModel currentUser){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return homePage(currentUser:currentUser);
    }));
  }


  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }


}



// class PatternPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     // Define starting and ending points
//     Offset startPointTop = Offset(0, 0);
//     Offset endPointTop = Offset(size.width, 0);
//     Offset controlPointTop = Offset(size.width / 2, 80);
//
//     Offset startPointBottom = Offset(size.width, size.height);
//     Offset endPointBottom = Offset(0, size.height);
//     // Offset controlPointBottom = Offset(size.width / 2, size.height - 80);
//
//     Paint gradientPaintBottom = Paint()
//       ..shader = LinearGradient(
//         begin: Alignment.bottomRight,
//         end: Alignment.topLeft,
//         colors: [Colors.green, Colors.blue],
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//
//     Paint gradientPaintBottom1 = Paint()
//       ..shader = LinearGradient(
//         begin: Alignment.bottomRight,
//         end: Alignment.topLeft,
//         colors: [Colors.blue, Colors.green],
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//
//     // Define gradients
//
//     Paint gradientPaintTop = Paint()
//       ..shader = LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [Colors.blue, Colors.green],
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//
//
//     // Draw pattern at the top
//     Path topPatternPath = Path()
//       ..moveTo(startPointTop.dx, startPointTop.dy)
//       ..lineTo(endPointTop.dx, endPointTop.dy)
//       ..quadraticBezierTo(controlPointTop.dx, controlPointTop.dy, startPointTop.dx, startPointTop.dy + 80)
//       ..close();
//
//     canvas.drawPath(topPatternPath, gradientPaintTop);
//
//
//
//     //Draw pattern at the bottom
//     Path bottomPatternPath = Path()
//       ..moveTo(startPointBottom.dx, startPointBottom.dy)
//       ..lineTo(endPointBottom.dx, endPointBottom.dy);
//     for (double x = 0; x <= size.width; x += 10) {
//       double y = 40 * math.sin(x / size.width * 2 * math.pi);
//       bottomPatternPath.lineTo(x, size.height - y - size.height / 8);
//     }
//     bottomPatternPath.lineTo(size.width, size.height / 2);
//     bottomPatternPath.close();
//
//     canvas.drawPath(bottomPatternPath, gradientPaintBottom);
//
//
//     // Draw pattern at the bottom
//     Path bottomPatternPath1 = Path()
//       ..moveTo(startPointBottom.dx, startPointBottom.dy)
//       ..lineTo(endPointBottom.dx, endPointBottom.dy);
//     for (double x = 0; x <= size.width; x += 10) {
//       double y = 20 * math.sin(x / size.width * 2 * math.pi);
//       bottomPatternPath1.lineTo(x, size.height - y - size.height / 18);
//     }
//     bottomPatternPath1.lineTo(size.width, size.height / 2);
//     bottomPatternPath1.close();
//
//     canvas.drawPath(bottomPatternPath1, gradientPaintBottom1);
//
//
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }