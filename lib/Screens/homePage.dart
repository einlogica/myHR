import 'dart:convert';
import 'package:einlogica_hr/Screens/CollectionTabs/collectMaterial.dart';
import 'package:einlogica_hr/Screens/Accounts/settingsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/eventsModel.dart';
import 'package:einlogica_hr/Models/locationModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Screens/Manager/claimApproval.dart';
import 'package:einlogica_hr/Screens/Manager/generatePayroll.dart';
import 'package:einlogica_hr/Screens/addEmployeePage.dart';
import 'package:einlogica_hr/Screens/attendancePage.dart';
import 'package:einlogica_hr/Screens/billPage.dart';
import 'package:einlogica_hr/Screens/Manager/dashboard.dart';
import 'package:einlogica_hr/Screens/directoryPage.dart';
import 'package:einlogica_hr/Screens/downloadsPage.dart';
import 'package:einlogica_hr/Screens/holidayPage.dart';
import 'package:einlogica_hr/Screens/leavePage.dart';
import 'package:einlogica_hr/Screens/paySlipPage.dart';
import 'package:einlogica_hr/Screens/policyPage.dart';
import 'package:einlogica_hr/Screens/profilePage.dart';
import 'package:einlogica_hr/Screens/timesheetPage.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/services/locationService.dart';
import 'package:einlogica_hr/style/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/summaryModel.dart';



class homePage extends StatefulWidget {
  final userModel currentUser;
  homePage({super.key,required this.currentUser});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {


  var w=0.00,h=0.00,t=0.00;
  String formattedDate="";
  String formattedDay="";
  locationModel currLocation = locationModel(ID:"",locationName: "", posLat: 0.00, posLong: 0.00,range: 0);
  bool _refresh = false;
  bool checkinWidth =true;
  bool checkOutPressed = false;
  bool gridAnim = false;
  bool pending = false;
  Uint8List imageFile= Uint8List(0);
  Uint8List empIcon= Uint8List(0);
  List<eventsModel> eventList = [];
  List<summaryModel> pendingList = [];
  // List<String,int> pendingList = [];
  String collectionTab='';
  String financeTab='';
  String version="";


  //Current attendance status
  String locationStatus="";
  String locationName="";
  String attTime = "";
  String outTime = "";
  // double posLat=0.00,posLong=0.00;

  bool updateAvailable = false;
  // Uint8List appfile= Uint8List(0);


  @override
  void initState() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        // print("In-app message received");
        Fluttertoast.showToast(
          msg: "${notification.body}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }
    });


    // TODO: implement initState
    DateTime now = DateTime.now();
    formattedDate = DateFormat('d MMM y').format(now);
    formattedDay = DateFormat('EEEE').format(now);
    eventList.clear();
    fetchData();
    fetchData2();
    super.initState();
  }


  fetchData()async{
    print("Fetch Data started============");
    version= apiServices().getVersion();
    pendingList = await apiServices().getPendingActions(widget.currentUser.Mobile, widget.currentUser.Permission);
    if(pendingList.isNotEmpty){
      pending=true;
    }
    await fetchAttStatus();
    setState(() {
      gridAnim=true;
    });
    print("Fetch Data ended============");
  }

  fetchData2()async{
    collectionTab = await apiServices().getSettings('CollectionTab');
    financeTab = await apiServices().getSettings('FinanceTab');
    apiServices().updateFCM(widget.currentUser.Mobile);
    await fetchEvents();
    await setEmployerImage();

    // print("CollectionTab = $collectionTab");
    if(widget.currentUser.ImageFile.length>10){
      await setProfileImage();
    }
    // print(eventList);

    setState(() {

    });
  }



  setEmployerImage()async{
    // print("Setting employer icon =================");
    empIcon=await apiServices().getBill(widget.currentUser.Employer, "Employer");
  }

  fetchEvents()async{
    eventList = await apiServices().getEvents();
  }

  setProfileImage()async{
    // print("Setting profile image =================");
    imageFile=await apiServices().getBill(widget.currentUser.ImageFile, "Profile");

  }

  fetchAttStatus()async{
    // setState(() {
    //   gridAnim=true;
    // });
    // print("Running fetchAttStatus");
    String response = await apiServices().attendanceStatus(widget.currentUser.Mobile);
    if(response.trim()!="Pending"){
      var data = jsonDecode(response.trim());
      locationName=data['Location'];
      locationStatus=data['Status'];
      // print(locationName);
      attTime=data['InTime'].toString().substring(0,5);

      outTime=data['OutTime'].toString().substring(0,5);
      // posLat=double.parse(data['PosLat']);
      // posLong=double.parse(data['PosLong']);
      checkinWidth=true;
    }
    else{
      checkinWidth=false;
    }
    checkOutPressed=false;
    // gridAnim=true;
  }


  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;


    // final itemWidth = 150.0;
    // final columnCount = (w / itemWidth).floor();


    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              //Safe Area
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: w,
                      // height: w>h?150:88+t,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppColors.themeStart,AppColors.themeStop]
                          ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: t,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(width: 10,),
                                InkWell(
                                  child: Container(
                                    width: w>h?80:w/5,
                                    height: w>h?80:w/5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(w/5),
                                      border: Border.all(color: Colors.white,width: 3),
                                      color: Colors.white,
                                    ),
                                    child: imageFile.isNotEmpty?ClipOval(
                                        child: Image.memory(imageFile,fit: BoxFit.cover,),

                                    ):Image.asset('assets/profile.png'),
                                  ),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return profilePage(permission: "EMP",mobile:widget.currentUser.Mobile,callback: setProfileImage,HLP: widget.currentUser.Permission,Image: widget.currentUser.ImageFile);
                                    }));
                                  },
                                ),
                                // Spacer(),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: SizedBox(
                                          width: 100,
                                          height: 50,
                                            // color: Colors.grey,
                                            child: empIcon.isEmpty?Container():Image.memory(empIcon,fit: BoxFit.contain,) //Image(image: AssetImage('$logo'),),

                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(widget.currentUser.Name,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                                              Text(widget.currentUser.Position,style: const TextStyle(color: Colors.white),),
                                              Text(widget.currentUser.Mobile,style: const TextStyle(color: Colors.white),)
                                            ],
                                          ),
                                          InkWell(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: const SizedBox(
                                              width:80,
                                              height:50,
                                              child: Icon(Icons.exit_to_app,color: Colors.white,)
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                // SizedBox(width: 10,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // widget.currentUser.Mobile=='1234567890'?Container(
              //   width: w,
              //   height: 50,
              //   color: Colors.yellow.shade200,
              //   child: Center(
              //     child: Text("Powered by: Einlogica Solutions Private Limited",style: TextStyle(fontWeight: FontWeight.bold),),
              //   ),
              // ):SizedBox(),
              // updateAvailable?SizedBox(
              //   width: w,
              //   height: 50,
              //   child: Center(
              //     child: Container(
              //       height: 30,
              //       color: Colors.yellow.shade200,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           const Text("New update available "),
              //           const SizedBox(width: 5,),
              //           SizedBox(
              //             height: 20,
              //               child: ElevatedButton(
              //                   style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),foregroundColor: MaterialStateProperty.all(Colors.white)),
              //                   onPressed: ()async{
              //                     final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.einlogica.einlogica_hr');
              //                     if (await canLaunchUrl(url)) {
              //                       await launchUrl(url);
              //                     } else {
              //                       throw 'Could not launch $url';
              //                     }
              //                   }, child: const Text("Download"))),
              //         ],
              //       ),
              //     ),
              //   ),
              // ):SizedBox(height: 20,),
              SizedBox(height: 20,),
              Expanded(
                  child: SizedBox(
                    // color: _color2,
                    width: w,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // const SizedBox(height: 10,),

                          Container(
                            width: w,
                            // height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // color: Colors.black.withOpacity(.4)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Text(formattedDay,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.buttonColorDark),),
                                        )
                                    ),
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Text(formattedDate,style: const TextStyle(fontSize: 18),),
                                        )
                                    ),



                                  ],
                                ),
                                kIsWeb?SizedBox():Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                        padding: const EdgeInsets.only(right: 20.0),
                                        child: InkWell(
                                          onTap: ()async{
                                            if(locationName!=""){
                                              return;
                                            }
                                            // print("checkin pressed");
                                            bool location = await locationServices().checkLocationServices();
                                            if(!location){
                                              showMessage("Please enable location services");
                                              return;
                                            }

                                            bool device = await apiServices().checkDevice();
                                            if(!device){
                                              showMessage("Unknown Device");
                                              return;
                                            }


                                            if(locationName==""){
                                              setState(() {
                                                // _refresh=true;
                                                checkinWidth=true;
                                                // print(checkinWidth);
                                              });
                                              // showMessage("Checking Location Services");
                                              bool status=await locationServices().checkLocationServices();
                                              // showMessage("$status");
                                              if(status==true){
                                                // showMessage("preparing model");
                                                currLocation=await locationServices().prepareModel();
                                                await showDialogBox("CheckIn").then((value) => null);
                                              }
                                              fetchAttStatus();
                                            }

                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(seconds: 1),
                                            curve: Curves.fastOutSlowIn,
                                            width: checkinWidth?w-w/2:w/3,
                                            height: 50,
                                            // height: checkinWidth?w/2:50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),
                                              gradient: const LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                  colors: [AppColors.themeStart,AppColors.themeStop]
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: Offset(2, 2),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                                child: locationName==""?Row(
                                                  mainAxisAlignment: checkinWidth?MainAxisAlignment.spaceEvenly:MainAxisAlignment.center,
                                                  children: [
                                                    const Text("Check in",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),),
                                                    checkinWidth?const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(color: Colors.white,)):const SizedBox(),

                                                  ],
                                                ):
                                                Padding(
                                                  padding: const EdgeInsets.only(left:12.0,right:2.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SizedBox(width: 5,),
                                                      // const Icon(Icons.work,color: Colors.white,),
                                                      Text(locationStatus,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                                                      locationStatus=='Present' && outTime=='00:00'?InkWell(
                                                          onTap: ()async{
                                                            // await locationServices().openMap(posLat, posLong);
                                                            setState(() {
                                                              checkOutPressed=true;
                                                            });
                                                            bool status=await locationServices().checkLocationServices();
                                                            if(status==true){
                                                              currLocation=await locationServices().prepareModel();
                                                              await showDialogBox("CheckOut").then((value) => null);
                                                            }
                                                            fetchAttStatus();

                                                          },
                                                          child: Container(
                                                              width: 80,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  color: Colors.white
                                                              ),
                                                              child: Center(child: checkOutPressed?const SizedBox(width: 20,height: 20,child: CircularProgressIndicator()):const Text("CheckOut")))):const SizedBox(),
                                                      // SizedBox(width: 10,),
                                                    ],
                                                  ),
                                                )
                                            ),
                                          ),
                                        )
                                    )
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          locationStatus=='Present'? Container(
                            width: w-20,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50
                            ),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5,),
                                Text("Work location : $locationName",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 18),),
                                const SizedBox(height: 5,),
                                locationStatus=='Present'?SizedBox(
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(width: 10,),
                                      const Icon(Icons.input,color: Colors.green,size: 16,),
                                      const SizedBox(width: 10,),
                                      Text(attTime,style: const TextStyle(color: Colors.black),),
                                      const Spacer(),
                                      outTime=='00:00'?const SizedBox():Text(outTime,style: const TextStyle(color: Colors.black)),
                                      outTime=='00:00'?const SizedBox():const SizedBox(width: 10,),
                                      outTime=='00:00'?const SizedBox():const Icon(Icons.output,color: Colors.deepOrange,size: 16,),
                                      const SizedBox(width: 10,),
                                    ],
                                  ),
                                ):const SizedBox(),
                                const SizedBox(height: 10,)
                              ],
                            ),
                          ):const SizedBox(),

                          const SizedBox(height: 20,),
                          const Align(
                              alignment: Alignment.centerLeft,

                              child: Padding(
                                padding: EdgeInsets.only(left:10.0),
                                child: Text("What would you like to do?",style: TextStyle(fontSize: 18,color: Colors.grey,fontStyle: FontStyle.italic),),
                              )),
                          const SizedBox(height: 20,),
                          SizedBox(
                            width: w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                gridContainer2('assets/attendance.png', "Attendance", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return attendancePage(mobile: widget.currentUser.Mobile,permission: "EMP",);
                                  }));
                                }),
                                gridContainer2('assets/leave.png', "Leave", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return leavePage(mobile: widget.currentUser.Mobile,name: widget.currentUser.Name,leaveCount: widget.currentUser.LeaveCount);
                                  }));
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30,),
                          SizedBox(
                            width: w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                gridContainer2('assets/claim.png', "Expense", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return billPage(mobile: widget.currentUser.Mobile, name: widget.currentUser.Name,permission: "EMP",HLP:widget.currentUser.Permission);
                                  }));
                                }),
                                gridContainer2('assets/activities.png', "Activity", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return timesheetPage(mobile: widget.currentUser.Mobile, name: widget.currentUser.Name,permission: "EMP",);
                                  }));
                                }),

                              ],
                            ),
                          ),
                          collectionTab=='1'?const SizedBox(height: 30,):SizedBox(),
                          collectionTab=='1'?gridContainer3('assets/getMaterial.png', "Collection", (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return collectMaterial(mobile: widget.currentUser.Mobile, name: widget.currentUser.Name,permission: widget.currentUser.Permission,);
                              }));
                          }):SizedBox(),

                          const SizedBox(height: 30,),
                          SizedBox(
                            width: w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                gridContainer2('assets/directory.png', "Directory", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return const directoryPage();
                                  }));
                                }),
                                gridContainer2('assets/user.png', "Profile", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return profilePage(permission: "EMP",mobile:widget.currentUser.Mobile,callback: setProfileImage,HLP: widget.currentUser.Permission,Image: widget.currentUser.ImageFile,);
                                  }));
                                })

                              ],
                            ),
                          ),
                          const SizedBox(height: 30,),
                          SizedBox(
                            width: w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                gridContainer('assets/holidays.png', "Holiday", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return holidayPage(permission: widget.currentUser.Permission);
                                  }));
                                }),
                                gridContainer('assets/policies.png', "Policy", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return policyPage(permission: widget.currentUser.Permission,);
                                  }));
                                }),
                                gridContainer('assets/invoice.png', "Pay Slip", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return paySlipPage(currentUser: widget.currentUser);
                                  }));
                                }),

                              ],
                            ),
                          ),
                          // SizedBox(height: 30,),
                          (widget.currentUser.Department=="Finance" || widget.currentUser.Permission=='Admin') && financeTab=='1'?const SizedBox(height: 30,):const SizedBox(),
                          (widget.currentUser.Department=="Finance" || widget.currentUser.Permission=='Admin') && financeTab=='1'?gridContainer3('assets/finance.png', "Employee Claims", (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return claimApprovalPage(currentUser: widget.currentUser, callback: (){});
                            }));
                          }):SizedBox(),



                          widget.currentUser.Permission=="Admin" || widget.currentUser.Permission=="Manager"?const SizedBox(height: 30,):const SizedBox(),
                          widget.currentUser.Permission=="Admin" || widget.currentUser.Permission=="Manager"?gridContainer3('assets/dashboard.png', "Manager's Dashboard", (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                                return dashboard(currentUser: widget.currentUser,);
                              }));
                          }):SizedBox(),


                          widget.currentUser.Permission=="Admin"?const SizedBox(height: 30,):const SizedBox(),

                          widget.currentUser.Permission=="Admin"?SizedBox(
                            width: w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                gridContainer('assets/onboard.png', "On-board", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return addEmployeePage(mobile: widget.currentUser.Mobile, name: widget.currentUser.Name,employer: widget.currentUser.Employer,);
                                  }));
                                }),
                                gridContainer('assets/payroll.png', "Payroll", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return generatePayrollPage(currentUser: widget.currentUser,);
                                  }));
                                }),
                                gridContainer('assets/report.png', "Reports", (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return downloadsPage(mobile: widget.currentUser.Mobile,name: widget.currentUser.Name,permission: widget.currentUser.Permission,);
                                  }));
                                }),
                              ],
                            ),
                          ):const SizedBox(),
                          widget.currentUser.Permission!="User"?const SizedBox(height: 30,):const SizedBox(),
                          widget.currentUser.Permission!="User"?gridContainer3('assets/setting.png', "Account Settings", (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return settingsPage(currentUser: widget.currentUser,);
                            }));
                          }):SizedBox(),
                          eventList.isNotEmpty?SizedBox(
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left:10.0),
                                      child: Text("Today's Special",style: TextStyle(fontSize: 18,color: Colors.grey,fontStyle: FontStyle.italic),),
                                    )
                                ),
                                const SizedBox(height: 10,),
                                SizedBox(
                                  width: w-50,
                                  height: eventList.length*50,
                                  child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: eventList.length,
                                      itemBuilder: (context,index){
                                        return SizedBox(
                                          height: 50,
                                          child: ListTile(
                                            title: SizedBox(
                                              width: w/1.5,
                                              child: Row(
                                                children: [
                                                  Text("Happy ${eventList[index].date}",style: const TextStyle(fontStyle: FontStyle.italic),),
                                                  const SizedBox(width: 20,),
                                                  Text(eventList[index].title,style: const TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                                                ],
                                              ),
                                            ),
                                            leading: Container(
                                              width: 30,
                                              height: 30,
                                              child: eventList[index].date=="Birthday"?Image.asset('assets/dob.png'):Image.asset('assets/doj.png'),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ):const SizedBox(),

                          const SizedBox(height: 10,),
                          SizedBox(
                            width: w,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Powered by Einlogica",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.grey),),
                                  Text(version,style: TextStyle(fontSize: 9,color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                  ),
              ),

            ],
          ),
          _refresh?Container(
            width: w,
            height: h,
            color: Colors.black.withOpacity(.4),
            child: Center(
              child: Container(
                width: w/2,
                height: 50,
                color: Colors.white,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Processing..."),
                    SizedBox(width: 5,),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          ):Container(),
          pending?Container(
            width: w,
            height: h,
            color: Colors.black.withOpacity(.3),
            child: Center(
              child: Container(
                width: w>h?w/3:w-50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blue.shade50,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.only(left:10.0),
                      child: Text("Pending actions",style: TextStyle(fontSize: 18,color: Colors.blue,fontStyle: FontStyle.italic),),
                    ),
                    SizedBox(height: 10,),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: pendingList.length,
                      itemBuilder: (context,index){
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Spacer(),
                            SizedBox(
                              width: w>h?w/8:w/2,
                              child: Text(pendingList[index].type),
                            ),
                            SizedBox(
                              width: w>h?w/8:40,
                              child: Align(
                                alignment: Alignment.centerRight,
                                  child: Text(pendingList[index].count.toStringAsFixed(0))),
                            ),
                            Spacer(),
                          ],
                        );
                      }
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )
                          )),
                          onPressed: (){
                          setState(() {
                            pending=false;
                          });
                      }, child: Text("  OK  ",style: TextStyle(color: Colors.white),)),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ):SizedBox(),
        ],
      ),
    );
  }

  Future showDialogBox(String type){
    return showDialog(
      context: context,
      builder: (ctx) => Container(
        width: w,
        height: h,
        color: Colors.transparent,
        child: AlertDialog(
          contentPadding: EdgeInsets.all(8),
          insetPadding: EdgeInsets.all(20),
          // backgroundColor: AppColors.boxColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text("Confirm Location"),
          content: SizedBox(
            width: w-10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Detected Location: ${currLocation.locationName}")),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async{
                          Navigator.of(ctx).pop();
                          String status = await apiServices().postAttendance(widget.currentUser.Name, widget.currentUser.Mobile, currLocation.posLat, currLocation.posLong, currLocation.locationName, type);
                          await fetchAttStatus();
                          setState(() {

                          });
                          showMessage(status);

                        },
                        child: Container(
                          // color: AppColors.buttonColor,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.buttonColorDark,
                          ),
                          padding: const EdgeInsets.all(14),
                          child: const Text("Confirm",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      TextButton(
                        onPressed: () {

                          setState(() {
                            type=="CheckIn"?checkinWidth = false:checkOutPressed=false;
                          });
                          Navigator.of(ctx).pop();
                        },
                        child: Container(
                          // color: AppColors.buttonColor,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.buttonColorDark,
                          ),
                          padding: const EdgeInsets.all(14),
                          child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),

                ],
              )
          ),
          // actions: <Widget>[
          //
          // ],
        ),
      ),
    );
  }


  Widget gridContainer(String asset,String title,Function onTap){
    return InkWell(
      onTap: (){
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        width: !gridAnim?w/5:w/3-30,
        height: !gridAnim?w/5:w>h?w/10:w/3-30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
          padding: const EdgeInsets.all(1.0),
          child: w>h?Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: w/12,
                  height:w/12,
                  child: Image.asset(asset)),
              Text(title,style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ):
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: w/8,
                  height:w/8,
                  child: Image.asset(asset)),
              Text(title,style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }

  Widget gridContainer2(String asset,String title,Function onTap){
    return InkWell(
      onTap: (){
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        width: !gridAnim?w/4:w/2-50,
        height: !gridAnim?w/4:w>h?w/10:w/2-50,
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
          padding: const EdgeInsets.all(1.0),
          child: w>h?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  width: gridAnim?w>h?w/12:w/5:w/7,
                  height:gridAnim?w/5:w/7,
                  child: Image.asset(asset)),
              Text(title,style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ):Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  width: gridAnim?w/5:w/7,
                  height:gridAnim?w/5:w/7,
                  child: Image.asset(asset)),
              Text(title,style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }


  Widget gridContainer3(String asset,String title,Function onTap){
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
          width: w-40,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 70,
                height: 40,
                child: Image.asset(asset),
              ),
              Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(
                width: 60,
                height: 40,
                child: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          )
      ),
    );
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

}
