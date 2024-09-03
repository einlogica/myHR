import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:einlogica_hr/Models/personalInfoModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Screens/Manager/editEmployeePage.dart';
import 'package:einlogica_hr/Screens/attendancePage.dart';
import 'package:einlogica_hr/Screens/billPage.dart';
import 'package:einlogica_hr/Screens/timesheetPage.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

import '../Models/advanceModel.dart';
import '../Widgets/FieldArea.dart';
import '../Widgets/FieldAreaWithCalendar.dart';
import '../Widgets/FieldAreaWithDropDown.dart';
import '../Widgets/PinFieldArea.dart';

class profilePage extends StatefulWidget {

  final String mobile;
  final String Image;
  final String permission;
  final String HLP;
  // final userModel currentUser;
  final Function callback;

  const profilePage({super.key,required this.permission,required this.mobile,required this.callback, required this.HLP, required this.Image});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {

  var w=0.00,h=0.00,t=0.00;
  // TextEditingController _nameCtrl= TextEditingController();
  var pickedImage;
  bool imgFromCamera=false;
  bool progressIndicator=true;
  bool imageLoaded = false;
  late File? imageFile;
  Uint8List profileImage= Uint8List(0);
  bool editInfo=false;
  bool pInfo = false;
  personalInfoModel personalInfo = personalInfoModel(ID: 0, Name: "", Mobile: "", Sex: "", DOB: "", AddL1: "", AddL2: "", AddL3: "", Zip: "", BloodGroup: "", EmContactName: "", EmContactNum: "", BankName: "", AccNum: "",UAN: "",PAN: "",ESICNo: "");
  List<String> Acc = [];
  String dropdownAcc = 'Select';
  userModel currentUser = userModel(Mobile: "", Name: "", EmployeeID: "", Employer: "", Department: "", Position: "", Permission: "", Manager: "", ManagerID: "", DOJ: "", LeaveCount: 0, Status: "", ImageFile: "");
  advanceModel advanceData = advanceModel(mobile: "", name: "", amount: "", date: "", emi: "", startdate: "", balance: "", status: "");

  final TextEditingController _dateCtrl= TextEditingController();
  final TextEditingController _commentsCtrl= TextEditingController();
  final TextEditingController _amtCtrl= TextEditingController();
  final TextEditingController _locCtrl= TextEditingController();
  final TextEditingController _emiCtrl= TextEditingController();
  final TextEditingController _curPin= TextEditingController();
  final TextEditingController _newPin= TextEditingController();
  final TextEditingController _rePin= TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _dateCtrl.dispose();
    _commentsCtrl.dispose();
    _amtCtrl.dispose();
    _locCtrl.dispose();
    _emiCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInfo();
    setProfileImage();

  }

  setProfileImage()async{

    final response=await apiServices().getBill("${widget.Image}", "Profile");
    if(response!="Failed"){
      profileImage=response;
    }
    setState(() {

    });

  }

  getInfo()async{
    currentUser = await apiServices().getProfile(widget.mobile);
    setState(() {
      progressIndicator=false;
    });
    // Acc=await apiServices().getAccounts();
    personalInfo = await apiServices().checkPersonalInfo(widget.mobile);
  }



  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    // Define controllers for text input fields
    // TextEditingController dobCtrl = TextEditingController();
    // TextEditingController sexCtrl = TextEditingController();
    // TextEditingController adl1Ctrl = TextEditingController();
    // TextEditingController adl2Ctrl = TextEditingController();
    // TextEditingController adl3Ctrl = TextEditingController();
    // TextEditingController zipCtrl = TextEditingController();
    // TextEditingController bgCtrl = TextEditingController();
    // TextEditingController emNameCtrl = TextEditingController();
    // TextEditingController emNumCtrl = TextEditingController();
    // TextEditingController bankNameCtrl = TextEditingController();
    // TextEditingController accNumCtrl = TextEditingController();
    // TextEditingController ifscCtrl = TextEditingController();

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
                            Text(widget.permission=='MAN'?currentUser.Name:"Profile",style: const TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
                const SizedBox(height: 10,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Container(
                            width: w>h?w/5:w/2,
                            height: w>h?w/5:w/2,
                            child: Stack(
                              children: [
                                Container(
                                  width: w>h?w/5:w/2,
                                  height: w>h?w/5:w/2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(w/4),
                                    border: Border.all(color: Colors.black,width: 2),
                                    color: Colors.white,
                                  ),
                                  child: profileImage.isNotEmpty?ClipOval(
                                    child: Image.memory(profileImage,fit: BoxFit.cover,),

                                  ):Image.asset('assets/profile.png'),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    width: w>h?w/5:w/2,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                          onPressed: (){
                                            imgFromCamera=true;
                                            // if(Platform.isAndroid || Platform.isIOS){
                                            //   getImage();
                                            // }
                                            getImage();

                                          },
                                          child: const Icon(Icons.camera,color: Colors.white,),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                          onPressed: (){
                                            imgFromCamera=false;
                                            // if(Platform.isAndroid){
                                            //   getImage();
                                            // }
                                            getImage();

                                          },
                                          child: const Icon(Icons.image,color: Colors.white,),
                                        ),
                                      ],
                                    )
                                  )
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          buildTextField("Name", currentUser.Name),
                          buildTextField("Mobile", currentUser.Mobile),
                          buildTextField("Employee ID", currentUser.EmployeeID),
                          buildTextField("Position", currentUser.Position),
                          buildTextField("Department", currentUser.Department),
                          buildTextField("Manager", currentUser.Manager),
                          SizedBox(height: 5,),
                          !pInfo?InkWell(
                            onTap: (){
                              setState(() {
                                pInfo=true;
                              });
                            },
                            child: Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.withOpacity(.4)
                              ),
                              child: Icon(Icons.keyboard_arrow_down_sharp,size: 20,),
                            ),
                          ):SizedBox(
                            child: Column(
                              children: [
                                buildTextField("DOB", personalInfo.DOB),
                                buildTextField("Sex", personalInfo.Sex),
                                buildTextField("Blood Group", personalInfo.BloodGroup),
                                buildTextField("Address", "${personalInfo.AddL1} \n ${personalInfo.AddL2} \n ${personalInfo.AddL3}"),
                                buildTextField("Zip", personalInfo.Zip),
                                buildTextField("Emerg Contact", personalInfo.EmContactName),
                                buildTextField("Emerg Number", personalInfo.EmContactNum),
                                currentUser.Status!="ACTIVE"?buildTextField("Status", currentUser.Status):SizedBox(),
                              ],
                            ),
                          ),


                          const SizedBox(height: 20,),
                          widget.permission=='EMP'?Column(
                            children: [
                              SizedBox(
                                width: w-50,
                                height: 40,
                                child: ElevatedButton(
                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                  onPressed: ()async{
                                    setState(() {
                                      progressIndicator=true;
                                    });
                                    showPasswordBox(false);
                                    setState(() {
                                      progressIndicator=false;
                                    });
                                  },
                                  child: const Text("Change Password",style: TextStyle(color: Colors.white),),),
                              ),
                              // SizedBox(height: 10,),
                              // SizedBox(
                              //   width: w-50,
                              //   height: 40,
                              //   child: ElevatedButton(
                              //     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.buttonColorDark)),
                              //     onPressed: ()async{
                              //       setState(() {
                              //         progressIndicator=true;
                              //       });
                              //       showSettingsBox(false);
                              //       setState(() {
                              //         progressIndicator=false;
                              //       });
                              //     },
                              //     child: const Text("Change display settings",style: TextStyle(color: Colors.white),),),
                              // ),
                            ],
                          ):Column(
                            children: [
                              widget.permission!='Admin'?const SizedBox():Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: w-50,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                    onPressed: ()async{
                                      setState(() {
                                        progressIndicator=true;
                                      });
                                      Acc = await apiServices().getAccounts();
                                      showDialogBox();
                                      setState(() {
                                        progressIndicator=false;
                                      });
                                    },
                                    child: const Text("Add Daily Expense",style: TextStyle(color: Colors.white),),),
                                ),
                              ),
                              widget.permission!='Admin'?const SizedBox():Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: w-50,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                    onPressed: ()async{
                                      setState(() {
                                        progressIndicator=true;
                                      });
                                      advanceData = await apiServices().getAdvanceDetails(widget.mobile);
                                      Acc = await apiServices().getAccounts();
                                      showSalaryAdvanceBox();
                                      setState(() {
                                        progressIndicator=false;
                                      });
                                    },
                                    child: const Text("Add Salary Advance",style: TextStyle(color: Colors.white),),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: w-50,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return attendancePage(mobile: currentUser.Mobile,permission: widget.permission,);
                                      }));
                                    },
                                    child: const Text("Attendance",style: TextStyle(color: Colors.white),),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: w-50,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return timesheetPage(mobile: currentUser.Mobile, name: currentUser.Name,permission: "EMP-MAN",);
                                      }));
                                    },
                                    child: const Text("Activity",style: TextStyle(color: Colors.white),),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: w-50,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return billPage(mobile: currentUser.Mobile, name: currentUser.Name,permission: "MAN",HLP: widget.HLP,);
                                      }));
                                    },
                                    child: const Text("Claims",style: TextStyle(color: Colors.white),),),
                                ),
                              ),
                            ],
                          ),
                          widget.permission!="Admin"?const SizedBox():Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: w-50,
                                  height: 40,

                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return editEmployeePage(User:currentUser,PersonalInfo: personalInfo,callback: getInfo,);
                                      }));
                                    },
                                    child: const Text("Employee Details",style: TextStyle(color: Colors.white),),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: w-50,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                    onPressed: ()async{
                                      setState(() {
                                        progressIndicator=true;
                                      });
                                      showPasswordBox(true);
                                      setState(() {
                                        progressIndicator=false;
                                      });
                                    },
                                    child: const Text("Reset Password",style: TextStyle(color: Colors.white),),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: w-50,
                                  height: 40,

                                  child: currentUser.Status=="INACTIVE"?const SizedBox():ElevatedButton(
                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.deepOrangeAccent)),
                                    onPressed: ()async{
                                      // String status = await apiServices().deactivateEmployee(widget.currentUser.Mobile);
                                      // showMessage(status);

                                      showDialog(
                                        context: context,
                                        builder: (ctx) => Container(
                                          width: w-50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: AlertDialog(
                                            // backgroundColor: AppColors.boxColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            title: const Text("Deactivate Employee !!"),
                                            content: const Text("Are you sure to deactivate employee?"),

                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () async{
                                                  String status = await apiServices().deactivateEmployee(currentUser.Mobile);
                                                  getInfo();
                                                  showMessage(status);
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  color: AppColors.buttonColor,
                                                  padding: const EdgeInsets.all(14),
                                                  child: const Text("Deactivate",style: TextStyle(color: Colors.white),),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // clearFields();
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  color: AppColors.buttonColor,
                                                  padding: const EdgeInsets.all(14),
                                                  child: const Text("Close",style: TextStyle(color: Colors.white),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );

                                    },
                                    child: const Text("Deactivate Employee",style: TextStyle(color: Colors.white),),),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          progressIndicator?loadingWidget():Container()
        ],
      ),
    );
  }


  // Function to create a text input field
  Widget buildTextField(String labelText, String value) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: w-50,
        // height: 50,
        child: Row(
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
  Widget buildTextForm(String labelText, TextEditingController ctrl,TextInputType type) {
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
              width: w*.2,
              // color: Colors.green,
              child: Text("$labelText : ",style: const TextStyle(fontWeight: FontWeight.bold),),
            ),
            SizedBox(
                width: w*.6,
                child: TextFormField(
                  keyboardType: type,
                  controller: ctrl,
                  decoration: InputDecoration(
                    // icon: Icon(Icons.password),
                    // hintText: "Pin",
                    enabled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }


  Future getImage() async {
    setState(() {
      progressIndicator=true;
    });
    if(imgFromCamera==true){
      // pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
      // pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.camera);
      pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    else{
      pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    // print("===================");
    // print(pickedImage.toString());
    if(pickedImage.toString()!="null") {
      // print("My Comments: Running image picker");

      final croppedFile = (await ImageCropper().cropImage(
        // maxHeight: 800,
        // maxWidth: 800,
        compressFormat: ImageCompressFormat.jpg,
        // compressQuality: 50,
        sourcePath: pickedImage.path,
        // cropStyle: CropStyle.rectangle,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      ));
      if(croppedFile != null){
        // print("My Comments: Running image cropper");
        imageFile = File(croppedFile.path);

        String baseimage="";
        List<int> imageBytes = imageFile!.readAsBytesSync();
        baseimage = base64Encode(imageBytes);

        String status = await apiServices().uploadImage(baseimage, currentUser.Mobile);
        showMessage(status);

        widget.callback();
        await setProfileImage();
        setState(() {
          progressIndicator=false;
        });

      }
      else{
        setState(() {
          progressIndicator=false;
        });
      }
    }
    else{
      setState(() {
        progressIndicator=false;
      });
    }


  }



  Future showPasswordBox(bool reset){
    return showDialog(
      context: context,
      builder: (ctx) => Container(
        width: w-50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: AlertDialog(
          // backgroundColor: AppColors.boxColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text("Change Pin"),
          content: SizedBox(
            width: w-50,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  !reset?PinFieldArea(title: "Current Pin", ctrl: _curPin, type: TextInputType.number, len: 6):const SizedBox(),
                  PinFieldArea(title: "New Pin", ctrl: _newPin, type: TextInputType.number, len: 6),
                  PinFieldArea(title: "Retype Pin", ctrl: _rePin, type: TextInputType.number, len: 6),
                ],
              ),
            ),
          ),

          actions: <Widget>[
            TextButton(
              onPressed: () async{
                // print(reset);
                if(_newPin.text==_rePin.text && _newPin.text.length>3){
                  String status = await apiServices().changePassword(currentUser.Mobile,_curPin.text,_newPin.text,reset);
                  clearFields();
                  // print(status);
                  Navigator.pop(context);
                  if(status=="Success"){
                    showMessage(status);
                  }
                }
                else{
                  showMessage("Invalid Password");
                }

              },
              child: Container(
                color: AppColors.buttonColor,
                padding: const EdgeInsets.all(14),
                child: const Text("Submit",style: TextStyle(color: Colors.white),),
              ),
            ),
            TextButton(
              onPressed: () {
                clearFields();
                Navigator.pop(context);
              },
              child: Container(
                color: AppColors.buttonColor,
                padding: const EdgeInsets.all(14),
                child: const Text("Close",style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future showSettingsBox(bool reset){
  //   return showDialog(
  //     context: context,
  //     builder: (ctx) => Container(
  //       width: w-50,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: AlertDialog(
  //         // backgroundColor: AppColors.boxColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15.0),
  //         ),
  //         title: const Text("Change Display Settings"),
  //         content: SizedBox(
  //           width: w-50,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 !reset?PinFieldArea(title: "Current Pin", ctrl: _curPin, type: TextInputType.number, len: 6):const SizedBox(),
  //                 PinFieldArea(title: "New Pin", ctrl: _newPin, type: TextInputType.number, len: 6),
  //                 PinFieldArea(title: "Retype Pin", ctrl: _rePin, type: TextInputType.number, len: 6),
  //               ],
  //             ),
  //           ),
  //         ),
  //
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () async{
  //               print(reset);
  //               if(_newPin.text==_rePin.text && _newPin.text.length>3){
  //                 String status = await apiServices().changePassword(currentUser.Mobile,_curPin.text,_newPin.text,reset);
  //                 clearFields();
  //                 Navigator.pop(context);
  //                 if(status=="Success"){
  //                   showMessage(status);
  //                 }
  //               }
  //               else{
  //                 showMessage("Invalid Password");
  //               }
  //
  //             },
  //             child: Container(
  //               color: AppColors.buttonColor,
  //               padding: const EdgeInsets.all(14),
  //               child: const Text("Submit",style: TextStyle(color: Colors.white),),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               clearFields();
  //               Navigator.pop(context);
  //             },
  //             child: Container(
  //               color: AppColors.buttonColor,
  //               padding: const EdgeInsets.all(14),
  //               child: const Text("Close",style: TextStyle(color: Colors.white),),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  updateDropDown(String title,String value){
    dropdownAcc=value;
  }

  Future showSalaryAdvanceBox(){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.all(8),
        insetPadding: EdgeInsets.all(8),
        // backgroundColor: AppColors.boxColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text("Salary Advance"),
        content: SizedBox(
          width: w-50,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Advance:  ${advanceData.amount}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("EMI:  ${advanceData.emi}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Start Date:  ${advanceData.startdate}"),
                ),
                FieldAreaWithDropDown(title: "Account", dropList: Acc, dropdownValue: dropdownAcc, callback: updateDropDown),
                FieldArea(title: "EMI", ctrl: _emiCtrl, type: TextInputType.number, len: 3),
                FieldAreaWithCalendar(title: "Start Date", ctrl: _dateCtrl, type: TextInputType.text,days:365),
                FieldArea(title: "Amount", ctrl: _amtCtrl, type: TextInputType.number, len: 6),
                // FieldAreaWithDropDown("Account", Acc, dropdownAcc,),
                // FieldArea("Location", _locCtrl,TextInputType.text),
                // FieldAreaWithCalendar("Date", _dateCtrl, TextInputType.text),
                // FieldArea("Amount", _amtCtrl,TextInputType.number),
                // FieldArea("Comments", _commentsCtrl,TextInputType.text),
              ],
            ),
          ),
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () async{
              Navigator.pop(context);
              String status = await apiServices().addAdvance(dropdownAcc,widget.mobile, _amtCtrl.text, _emiCtrl.text, _dateCtrl.text);
              // String status = await apiServices().addEmployeeAdvance(currentUser.Mobile, currentUser.Name, dropdownAcc, _locCtrl.text, _dateCtrl.text, _amtCtrl.text);
              clearFields();
              showMessage(status);

            },
            child: Container(
              color: AppColors.buttonColor,
              padding: const EdgeInsets.all(14),
              child: const Text("Submit",style: TextStyle(color: Colors.white),),
            ),
          ),
          TextButton(
            onPressed: () {
              clearFields();
              Navigator.pop(context);
            },
            child: Container(
              color: AppColors.buttonColor,
              padding: const EdgeInsets.all(14),
              child: const Text("Close",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }


  Future showDialogBox(){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.all(8),
        insetPadding: EdgeInsets.all(8),
        // backgroundColor: AppColors.boxColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text("Daily Expense"),
        content: SizedBox(
          width: w-50,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FieldAreaWithDropDown(title: "Account", dropList: Acc, dropdownValue: dropdownAcc, callback: updateDropDown),
                FieldArea(title: "Description", ctrl: _locCtrl, type: TextInputType.text, len: 20),
                FieldAreaWithCalendar(title: "Date", ctrl: _dateCtrl, type: TextInputType.text,days:365),
                FieldArea(title: "Amount", ctrl: _amtCtrl, type: TextInputType.number, len: 6),
                // FieldAreaWithDropDown("Account", Acc, dropdownAcc,),
                // FieldArea("Location", _locCtrl,TextInputType.text),
                // FieldAreaWithCalendar("Date", _dateCtrl, TextInputType.text),
                // FieldArea("Amount", _amtCtrl,TextInputType.number),
                // FieldArea("Comments", _commentsCtrl,TextInputType.text),
              ],
            ),
          ),
        ),

        actions: <Widget>[
          TextButton(
            onPressed: () async{
              Navigator.pop(context);
              String status = await apiServices().addEmployeeAdvance(currentUser.Mobile, currentUser.Name, dropdownAcc, _locCtrl.text, _dateCtrl.text, _amtCtrl.text);
              clearFields();
              showMessage(status);

            },
            child: Container(
              color: AppColors.buttonColor,
              padding: const EdgeInsets.all(14),
              child: const Text("Submit",style: TextStyle(color: Colors.white),),
            ),
          ),
          TextButton(
            onPressed: () {
              clearFields();
              Navigator.pop(context);
            },
            child: Container(
              color: AppColors.buttonColor,
              padding: const EdgeInsets.all(14),
              child: const Text("Close",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }


  clearFields(){
    _amtCtrl.clear();
    _dateCtrl.clear();
    _commentsCtrl.clear();
    _locCtrl.clear();
    dropdownAcc="Select";
    _curPin.clear();
    _newPin.clear();
    _rePin.clear();
    _emiCtrl.clear();
  }



  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

}

