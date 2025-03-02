import 'dart:convert';
import 'dart:io';
import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithCalendar.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithDropDown.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:einlogica_hr/Models/billerModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

import '../Widgets/imageViewer.dart';

// late double w,h;
var items = [
  'Vehicle',
  'Fuel',
  'Taxi',
  'Daily-Wage',
  'Food',
  'Bus',
  'Accommodation',
  'Purchase',
  'Other',
];

List<String> travel =['Vehicle','Taxi','Bus'];
List<String> districtList = ["Select"];
// String desc="";
bool otherSelected=false;

var pickedImage;
bool imgFromCamera=false;
bool progressIndicator=false;
bool imageLoaded = false;
late File? imageFile;
bool progress=false;
String errMesg="";
bool imageDownloaded = false;


String dropdownvalue = 'Vehicle';
String shopID = "";



List<billerModel> billerList = [];
billerModel selectedBiller = billerModel(id: "", name: "", addressl1: "", addressl2: "", addressl3: "", district: "", mobile: "", gst: "",division: "",type: "",createDate: "",createTime: "",createUser: "",createMobile: "");


class upload_bill extends StatefulWidget {
  const upload_bill({super.key, required this.mobile, required this.name,required this.callback});

  final String mobile;
  final String name;
  final Function() callback;

  @override
  State<upload_bill> createState() => _upload_billState();
}

class _upload_billState extends State<upload_bill> {

  var w=0.00,h=0.00,t=0.00;
  bool shopSelected=false;
  bool addNewShop =false;
  // bool _gst=false;

  final TextEditingController _specifyCtrl = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _L1Controller = TextEditingController();
  final TextEditingController _L2Controller = TextEditingController();
  final TextEditingController _L3Controller = TextEditingController();
  final TextEditingController _distController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();

  final TextEditingController _billnoCtrl = TextEditingController();
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController _siteCtrl = TextEditingController();
  final TextEditingController _fromCtrl = TextEditingController();
  final TextEditingController _toCtrl = TextEditingController();
  final TextEditingController _kmCtrl = TextEditingController();
  final TextEditingController _labourCtrl = TextEditingController();
  final TextEditingController _countCtrl = TextEditingController();
  final TextEditingController _durationCtrl = TextEditingController();

  List<String>vehicleList=['Other'];
  String selectedVehicle="Other";
  List<String> siteList = ["Select","Other"];
  String dropdownsite = "Select";
  String dropdowndistrict = "Select";
  List<String>expenseType=[];

  @override
  void dispose() {
    // TODO: implement dispose
    _specifyCtrl.dispose();
    _shopNameController.dispose();
    _L1Controller.dispose();
    _L2Controller.dispose();
    _L3Controller.dispose();
    _distController.dispose();
    _phoneController.dispose();
    _gstController.dispose();
    _billnoCtrl.dispose();
    _amountCtrl.dispose();
    dateController.dispose();
    _siteCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _kmCtrl.dispose();
    _labourCtrl.dispose();
    _countCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();

  }

  @override
  void initState() {
    // TODO: implement initState
    fetchVehicle();
    super.initState();
  }

  fetchVehicle()async{
    expenseType=await apiServices().getExpenseType();
    items.addAll(expenseType);
    List<String> sites=await apiServices().fetchSettingsList("Site Name",widget.mobile);
    siteList.addAll(sites);
    var response =await apiServices().fetchVehicle(widget.mobile);
    // print(response);
    if(response!="Failed"){
      var data = jsonDecode(response);
      for(var d in data){
        vehicleList.add("${d['Type']}");
      }
    }
    districtList=await apiServices().getDistrict("KERALA");
    setState(() {

    });
  }

  dropDownCallback(String title,String selected){
    if(title=="Vehicle"){
      selectedVehicle=selected;
    }
    else if(title=="Location"){
      dropdownsite=selected;
    }
    else if(title=="District"){
      dropdowndistrict=selected;
    }
    else if(title=="Type"){
      addNewShop=false;
      dropdownsite="Select";
      if(selected=='Other'){
        otherSelected=true;
      }
      else{
        otherSelected=false;
      }
      dropdownvalue=selected;
    }
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {

    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    t = MediaQuery.of(context).viewPadding.top;
    // final bottomInset = MediaQuery.of(context).viewInsets.bottom;


    // print("Height=$h");
    // print(addNewShop);

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
                                  clearFields();
                                  clearShop();
                                  Navigator.pop(context);
                                },
                                child: const SizedBox(
                                  width: 60,
                                  height: 40,

                                  // color: Colors.grey,
                                  child: Center(child: Icon(Icons.arrow_back,size: 20,color: Colors.white,)),
                                ),
                              ),
                              const Text("Upload Bill",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
                      // reverse: true,
                      child: Column(
                        children: [
                          const SizedBox(height: 10,),
                          SizedBox(child: FieldAreaWithDropDown(title: "Type", dropList: items, dropdownValue: dropdownvalue, callback: dropDownCallback)),
                          dropdownvalue=='Other' || dropdownvalue=='Purchase' ?FieldArea(title: "Specify Item", ctrl: _specifyCtrl, type: TextInputType.text, len: 40):const SizedBox(),
                          dropdownvalue=='Fuel'?FieldAreaWithDropDown(title: "Vehicle", dropList: vehicleList, dropdownValue: selectedVehicle, callback: dropDownCallback):const SizedBox(),

                          dropdownvalue=='Purchase'?!addNewShop?Column(
                            children: [
                              const SizedBox(height: 10,),
                              SizedBox(
                                width: w-50,
                                height: 60,
                                // color: Colors.grey,
                                child: SizedBox(
                                  // width: w-50,
                                  child: TypeAheadField(
                                      suggestionsCallback: (pattern) async {
                                        // Call a method to fetch shop name suggestions from the database
                                        // print("AAA");
                                        if(pattern.length>2){
                                          shopSelected=false;
                                          return await apiServices().getBiller(pattern,"NONE");
                                        }
                                        else{
                                          return [];
                                        }

                                      },
                                    builder: (context, controller, focusNode) {
                                      return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          autofocus: true,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Search Shop',
                                          )
                                      );
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text("${suggestion.name}, ${suggestion.district}"),
                                      );
                                    },
                                    onSelected: (suggestion) {
                                        // Handle the selection of a suggestion
                                        selectedBiller=suggestion;
                                        shopSelected=true;
                                        _shopNameController.text = suggestion.name;
                                        setState(() {

                                        });
                                      },
                                  )
                                ),
                              ),
                              const SizedBox(height: 10,),
                              shopSelected?SizedBox(
                                width: w-60,
                                // height: 50,
                                // color: Colors.grey,
                                child: Container(
                                    width: w-70,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.grey.withValues(alpha: .2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(selectedBiller.name),
                                          // Text(selectedBiller.addressl1),
                                          // Text(selectedBiller.addressl2),
                                          // Text(selectedBiller.addressl3),
                                          Text(selectedBiller.district),
                                          Text(selectedBiller.mobile),
                                          Text(selectedBiller.gst),
                                          const SizedBox(height: 20,)
                                        ],
                                      ),
                                    )
                                ),
                              ):const SizedBox(),

                            ],
                          ):const SizedBox():const SizedBox(),
                          dropdownvalue!='Purchase'?const SizedBox():SizedBox(
                            width: w-20,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: w/3,
                                  // color: Colors.green,
                                  child: const Text("Add New Shop:",style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(
                                  width: w/2,
                                  // color: Colors.grey,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Checkbox(

                                      value: addNewShop,
                                      onChanged: (value){
                                        clearShop();
                                        shopSelected=false;
                                        addNewShop=!addNewShop;
                                        setState(() {

                                        });


                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          !addNewShop?const SizedBox():Column(
                            children: [
                              FieldArea(title: "Shop Name", ctrl: _shopNameController, type: TextInputType.text, len: 20),
                              // FieldArea(title: "Address L1", ctrl: _L1Controller, type: TextInputType.text, len: 50),
                              // FieldArea(title: "Address L2", ctrl: _L2Controller, type: TextInputType.text, len: 50),
                              // FieldArea(title: "Address L3", ctrl: _L3Controller, type: TextInputType.text, len: 50),
                              // FieldArea(title: "District", ctrl: _distController, type: TextInputType.text, len: 20),
                              FieldAreaWithDropDown(title: "District", dropList: districtList, dropdownValue: dropdowndistrict, callback: dropDownCallback),
                              FieldArea(title: "Phone", ctrl: _phoneController, type: TextInputType.text, len: 15),
                              FieldArea(title: "GST", ctrl: _gstController, type: TextInputType.text, len: 20),

                            ],
                          ),
                          dropdownvalue=='Fuel' && selectedVehicle=='Other' ?FieldArea(title: "Specify", ctrl: _specifyCtrl, type: TextInputType.text, len: 20):const SizedBox(),
                          // FieldArea(title: "Location", ctrl: _siteCtrl, type: TextInputType.text, len: 30),
                          FieldAreaWithDropDown(title: "Location", dropList: siteList, dropdownValue: dropdownsite, callback: dropDownCallback),
                          dropdownsite=="Other"?FieldArea(title: "Specify Location", ctrl: _siteCtrl, type: TextInputType.text, len: 40):const SizedBox(),
                          FieldAreaWithCalendar(title: "Expense Date", ctrl: dateController, type: TextInputType.datetime,days:2,fdays: 0,),
                          travel.contains(dropdownvalue)?FieldArea(title: "From", ctrl: _fromCtrl, type: TextInputType.text, len: 20):const SizedBox(),
                          travel.contains(dropdownvalue)?FieldArea(title: "To", ctrl: _toCtrl, type: TextInputType.text, len: 20):const SizedBox(),
                          dropdownvalue=='Daily-Wage'?FieldArea(title: "Labour Name", ctrl: _labourCtrl, type: TextInputType.text, len: 20):const SizedBox(),
                          dropdownvalue=='Daily-Wage'?FieldArea(title: "Labour Count", ctrl: _countCtrl, type: TextInputType.number, len: 3):const SizedBox(),
                          dropdownvalue=='Daily-Wage'?FieldArea(title: "Duration (Hrs)", ctrl: _durationCtrl, type: TextInputType.number, len: 3):const SizedBox(),
                          dropdownvalue!='Vehicle'?const SizedBox():FieldArea(title: "KM", ctrl: _kmCtrl, type: TextInputType.number, len: 6),
                          dropdownvalue=='Vehicle' || dropdownvalue=='Daily-Wage'?const SizedBox():FieldArea(title: "Bill Number", ctrl: _billnoCtrl, type: TextInputType.text, len: 20),
                          FieldArea(title: "Amount", ctrl: _amountCtrl, type: TextInputType.number, len: 7),
                          const SizedBox(height: 10,),
                          dropdownvalue=='Vehicle' || dropdownvalue=='Daily-Wage'?const SizedBox():SizedBox(
                            width: w-20,
                            height: 50,
                            // color: Colors.grey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: w/4,
                                  // color: Colors.green,
                                  child: const Text("Uploads:",style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(
                                  width: w/2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                        onPressed: (){
                                          imgFromCamera=true;
                                          getImage();
                                        },
                                        child: const Icon(Icons.camera,color: Colors.white,),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                        onPressed: (){
                                          imgFromCamera=false;
                                          getImage();
                                        },
                                        child: const Icon(Icons.image,color: Colors.white,),
                                      ),
                                    ],
                                  ),

                                ),

                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          imageLoaded?SizedBox(
                            width: w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap:(){
                                    // setState(() {
                                    //   imageDownloaded=true;
                                    // });
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return imageViewer(imagefile: imageFile!.readAsBytesSync(), mobile: widget.mobile,download: false,);
                                    }));
                                  },
                                  child: Container(
                                    width: w/4,
                                    height: w/4,
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(w/2),
                                      border: Border.all(color: Colors.grey,width: 2),
                                      color: Colors.white,
                                    ),

                                    child: Image.file(File(imageFile!.path),fit: BoxFit.cover,),

                                  ),
                                ),
                                // Text("${(imageFile!.lengthSync()/2048).toStringAsFixed(0)} Mb"),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      imageLoaded=false;
                                    });
                                  },
                                  child: const SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Icon(Icons.delete),
                                  ),
                                )
                              ],
                            ),
                          ):const SizedBox(),
                          const SizedBox(height: 30,),
                          SizedBox(
                              width: w-20,
                              height: 50,
                              // color: Colors.green,
                              // color: Colors.grey,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: w/3,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                      onPressed: (){
                                        clearFields();
                                        clearShop();
                                        widget.callback();
                                        Navigator.pop(context);
                                      },

                                      child: const Text("Back",style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                  SizedBox(
                                    width: w/3,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                      onPressed: ()async{


                                        bool validate = validateInputs();

                                        String location = dropdownsite;
                                        if(dropdownsite=="Other"){
                                          location=_siteCtrl.text;
                                        }

                                        if(location=="Select"){
                                          validate=false;
                                        }

                                        if(!validate){
                                          showMessage("Invaid Inputs");
                                          return;
                                        }



                                        String status="";
                                        double amt=0;
                                        setState(() {
                                          progress=true;
                                        });
                                        String baseimage="";
                                        // print(imageLoaded.toString());

                                        if(imageLoaded) {

                                          List<int> imageBytes = imageFile!
                                              .readAsBytesSync();
                                          baseimage = base64Encode(imageBytes);
                                        }

                                        String typeName=dropdownvalue.toString();


                                        amt=double.parse(_amountCtrl.text);

                                        if(dropdownvalue=='Purchase'){
                                          // typeName = dropdownvalue + "-" + _specifyCtrl.text;
                                          if(addNewShop){
                                            selectedBiller = billerModel(id: "", name: _shopNameController.text, addressl1: _L1Controller.text, addressl2: _L2Controller.text,
                                                addressl3: _L3Controller.text, district: _distController.text, mobile: _phoneController.text, gst: _gstController.text, division: "",type: "",createDate: "",createTime: "",createUser: "",createMobile: "");
                                          }


                                          status = await apiServices().uploadPurchaseBill(widget.mobile,widget.name, typeName,_specifyCtrl.text,location,_billnoCtrl.text, amt.toString(), dateController.text, baseimage, imageLoaded.toString(),selectedBiller);
                                        }
                                        else if(dropdownvalue=='Daily-Wage'){
                                          status = await apiServices().addDailyWages(widget.mobile, widget.name, location, _labourCtrl.text, _countCtrl.text, _durationCtrl.text,_amountCtrl.text,dateController.text);
                                        }
                                        else{
                                          var sitevalue=_specifyCtrl.text;
                                          if(dropdownvalue=="Fuel"){
                                            if(selectedVehicle=='Other'){
                                              sitevalue=_specifyCtrl.text;
                                            }
                                            else{
                                              sitevalue=selectedVehicle;
                                            }

                                          }
                                          // else if(dropdownvalue=='Other'){
                                          //   typeName = dropdownvalue + "-" + _specifyCtrl.text;
                                          // }
                                          // else{
                                          //   sitevalue=_siteCtrl.text;
                                          // }
                                          status = await apiServices().uploadBill(widget.mobile,widget.name, typeName, sitevalue,location, _fromCtrl.text,
                                              _toCtrl.text, _kmCtrl.text, _billnoCtrl.text, amt.toString(), dateController.text, baseimage, imageLoaded.toString());
                                        }



                                        if(status=="Success"){
                                          showMessage("Bill successfully uploaded");
                                          clearFields();
                                          clearShop();
                                          widget.callback();
                                          setState(() {

                                          });
                                        }
                                        else{
                                          showMessage(status);
                                          // print("Upload Failed");
                                          setState(() {
                                            progress=false;
                                            // errMesg="Upload Failed";
                                          });
                                        }


                                      },
                                      child: const Text("Submit",style: TextStyle(color: Colors.white),),
                                    ),
                                  ),

                                ],
                              )
                          ),

                          const SizedBox(height: 20,),
                          // FieldArea(title, ctrl),
                          // SizedBox(height: 10,),
                          // FieldArea(title, ctrl),
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
          // imageDownloaded?Container(
          //   width: w,
          //   height: h,
          //
          //   color: Colors.white,
          //   // child: Image(image: Image.memory(profileImage).image),
          //   child: PhotoView(
          //     imageProvider: FileImage(imageFile!),
          //   ),
          // ):Container(),
          // imageDownloaded?SafeArea(
          //   child: Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Align(
          //       alignment: Alignment.topRight,
          //       child: InkWell(
          //         onTap: (){
          //           setState(() {
          //             imageDownloaded=false;
          //           });
          //         },
          //         child: Container(
          //           width: 50,
          //           height: 50,
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(25),
          //               color: Colors.white
          //           ),
          //           child: const Icon(Icons.clear,color: Colors.red,),
          //         ),
          //       ),
          //     ),
          //   ),
          // ):Container(),

          progress?loadingWidget():Container(),
        ],
      ),
    );

  }



  void clearFields(){
    dropdownvalue="Vehicle";
    _specifyCtrl.clear();
    _siteCtrl.clear();
    _billnoCtrl.clear();
    _amountCtrl.clear();
    dateController.clear();
    _fromCtrl.clear();
    _toCtrl.clear();
    _kmCtrl.clear();
    _labourCtrl.clear();
    _countCtrl.clear();
    _durationCtrl.clear();
    imageLoaded=false;
    progress=false;
    addNewShop=false;
  }

  void clearShop(){
    selectedBiller = billerModel(id: "", name: "", addressl1: "", addressl2: "", addressl3: "", district: "", mobile: "", gst: "",division: "",type: "",createDate: "",createTime: "",createUser: "",createMobile: "");
    _shopNameController.clear();
    _L1Controller.clear();
    _L2Controller.clear();
    _L3Controller.clear();
    _distController.clear();
    _phoneController.clear();
    _gstController.clear();
    // addNewShop=false;
  }


  Future getImage() async {
    // if(Platform.isAndroid || Platform.isIOS){
      if(imgFromCamera==true){
        // pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
        // pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.camera);
        // pickedImage = await ImagePicker.platform.getImageFromSource(source: ImageSource.camera);
        pickedImage = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 70);
      }
      else{
        pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70);
      }
    // }
    // else if(kIsWeb){
    //   // print("======================WEB");
    //   pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70);
    // }


    // print("===================");
    // print(pickedImage.toString());
    if(pickedImage.toString().isNotEmpty) {
      // print("My Comments: Running image picker");

      final croppedFile = (await ImageCropper().cropImage(
        // maxHeight: 1080,
        // maxWidth: 900,
        compressFormat: ImageCompressFormat.jpg,
        // compressQuality: 80,
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


        setState(() {
          imageLoaded=true;
        });
      }
      else{
        setState(() {
          imageLoaded=false;
        });
      }
    }
    else{
      setState(() {
        imageLoaded=false;
      });
    }

  }



  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

  bool validateInputs(){
    // print(dropdownvalue);

    if(dropdownsite=='Other' && _siteCtrl.text==""){
      return false;
    }
    if(dropdownvalue=='Vehicle'){
      if(_siteCtrl.text=="" || _kmCtrl.text=="" || dateController.text=="" || _amountCtrl.text==""){
        return false;
      }
      else{
        return true;
      }
    }
    else if(dropdownvalue=='Fuel' || dropdownvalue=='Taxi' || dropdownvalue=='Daily-Wage' || dropdownvalue=='Food' || dropdownvalue=='Bus' || dropdownvalue=='Accommodation' || dropdownvalue=='Other'){
      if(_amountCtrl.text=="" || dateController.text==""){
        showMessage("Invalid Inputs");
        return false;
      }
      else{
        return true;
      }
    }
    else if(dropdownvalue=='Purchase'){
      if(_amountCtrl.text=="" || dateController.text=="" || (selectedBiller.name=="" && _shopNameController.text=="")){
        return false;
      }
      else{
        return true;
      }
    }
    else if(dropdownvalue!='Select' && _amountCtrl.text!="" && dateController.text!=""){
      return true;
    }
    else{
      return false;
    }
    // return false;
  }

}