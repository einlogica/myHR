import 'dart:convert';
import 'dart:io';

import 'package:einlogica_hr/Models/collectionModel.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithCalendar.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithDropDown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../Models/billerModel.dart';
import '../../Widgets/FieldArea.dart';
import '../../Widgets/imageViewer.dart';
import '../../Widgets/loadingWidget.dart';
import '../../services/apiServices.dart';
import '../../services/locationService.dart';
import '../../style/colors.dart';

DateTime? _selected = DateTime.now();

class collectMaterial extends StatefulWidget {
  const collectMaterial(
      {super.key,
      required this.mobile,
      required this.name,
      required this.permission});

  final String mobile;
  final String name;
  final String permission;

  @override
  State<collectMaterial> createState() => _collectMaterialState();
}

class _collectMaterialState extends State<collectMaterial> {



  List<collectionModel> collectionList =[];
  List<collectionModel> filteredcollectionList =[];
  List<billerModel> billerList = [];
  billerModel selectedBiller = billerModel(
      id: "", name: "", addressl1: "", addressl2: "", addressl3: "", district: "",
      mobile: "", gst: "",division: "",type: "",createDate: "",createTime: "",createUser: "",createMobile: "");

  Position _position = Position(longitude: 0.00, latitude: 0.00, timestamp: DateTime.now(), accuracy: 0.00, altitude: 0.00, altitudeAccuracy: 0.00,
      heading: 0.00, headingAccuracy: 0.00, speed: 0.00, speedAccuracy: 0.00);

  bool imageDownloaded = false;
  var pickedImage;
  bool imgFromCamera=false;
  bool imageLoaded = false;
  late File? imageFile;
  List<String>vehicleList=['Other'];
  final TextEditingController _specifyCtrl = TextEditingController();


  var w = 0.00, h = 0.00, t = 0.00;
  bool _loading = true;
  bool _addData = false;
  bool addNewShop = false;
  bool shopSelected = false;


  // final TextEditingController _divisionCtrl = TextEditingController();
  // final TextEditingController _typeCtrl = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _L1Controller = TextEditingController();
  final TextEditingController _L2Controller = TextEditingController();
  final TextEditingController _L3Controller = TextEditingController();
  // final TextEditingController _distController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dryController = TextEditingController();
  final TextEditingController _clothController = TextEditingController();
  final TextEditingController _billnoCtrl = TextEditingController();
  final TextEditingController _amountCtrl = TextEditingController();

  TextEditingController searchCtrl = TextEditingController();


  // List<String> typeList = ["Select", "Bank","Flat", "Hospital", "Office", "Shop"];
  List<String> typeList = ["Select"];
  List<String> divList = ["Select"];
  List<String> itemList = ["Material","Yard","Cash","UPI","GST"];
  List<String> districtList = ["Select"];
  String dropDownDiv = "Select";
  String dropDownType = "Select";
  String distDropDown = "Select";
  String itemDropDown = "Material";
  String selectedVehicle="Other";


  String selectedDate ="";


  @override
  void dispose() {
    // TODO: implement dispose
    // _divisionCtrl.dispose();
    // _typeCtrl.dispose();
    _specifyCtrl.dispose();
    _shopNameController.dispose();
    _L1Controller.dispose();
    _L2Controller.dispose();
    _L3Controller.dispose();
    // _distController.dispose();
    _phoneController.dispose();
    _gstController.dispose();
    _dateController.dispose();
    _dryController.dispose();
    _clothController.dispose();
    _billnoCtrl.dispose();
    _amountCtrl.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fetchData();
    searchCtrl.addListener(() {
      filterList(searchCtrl.text);
      setState(() {

      });
    });
    fetchCollection(selectedDate);
    super.initState();
  }

  fetchData() async {
    districtList=await apiServices().getDistrict("KERALA");
    // print(districtList);
    divList.addAll(await apiServices().fetchSettingsList("Site Name",widget.mobile));
    // print(divList);
    typeList.addAll(await apiServices().fetchSettingsList("Customer",widget.mobile));
    // print(typeList);
    var response =await apiServices().fetchVehicle(widget.mobile);
    // print(response);
    if(response!="Failed" && response.isNotEmpty){
      var data = jsonDecode(response);
      for(var d in data){
        vehicleList.add("${d['Type']}");
      }
    }

    // await fetchCollection(selectedDate);
    setState(() {
      _loading=false;
    });
  }

  fetchCollection(String date)async{
    // print("calling fetch collection");
    filteredcollectionList.clear();
    collectionList = await apiServices().getCollection(widget.mobile,widget.permission,date);

    filteredcollectionList.addAll(collectionList);
    setState(() {
      _loading=false;
    });

  }

  filterList(String filter){

    filteredcollectionList.clear();
    if(filter!=""){
      filteredcollectionList = collectionList.where((item) => item.name.toLowerCase().contains(filter.toLowerCase()) || item.shopname.toLowerCase().contains(filter.toLowerCase()) ).toList();

    }
    else{
      filteredcollectionList.addAll(collectionList);
    }
  }

  dropDownCallback(String title, String selected) {

    // if (title == "Division") {
    //   dropDownDiv = selected;
    // } else
    if (title == "Type") {
      dropDownType = selected;
    }
    else if(title == "Division"){
      dropDownDiv = selected;
    }
    else if(title == "District"){
      distDropDown = selected;
    }
    else if(title == "Item"){
      _clothController.clear();
      _dryController.clear();
      _amountCtrl.clear();
      itemDropDown = selected;
    }
    else if(title == "Vehicle"){
      selectedVehicle=selected;
      print(selectedVehicle);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    t = MediaQuery.of(context).viewPadding.top;
    // print(_addData);

    return Scaffold(
        floatingActionButton: _addData || imageDownloaded
            ? SizedBox()
            : FloatingActionButton(
                backgroundColor: AppColors.buttonColorDark,
                onPressed: () {
                  setState(() {
                    _addData = true;
                  });
                },
                child: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
              ),
        body: Stack(
            children: [
          SizedBox(
            width: w,
            height: h,
            child: Column(
              children: [
                Container(
                  height: 60 + t,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.themeStart, AppColors.themeStop]),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: t,
                      ),
                      SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                // widget.callback();
                                Navigator.pop(context);
                              },
                              child: const SizedBox(
                                width: 60,
                                height: 40,
                                // color: Colors.grey,
                                child: Center(
                                    child: Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                  color: Colors.white,
                                )),
                              ),
                            ),
                            const Text(
                              "Collections",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            _addData
                                ? const SizedBox(
                                    width: 60,
                                    height: 40,
                                  )
                                : InkWell(
                                  onTap: ()async{
                                    setState(() {
                                      _loading=true;
                                    });

                                    _selected = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(), //get today's date
                                        firstDate:DateTime(2022), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime.now(),
                                    );
                                    // print(_selected);
                                    if(_selected!=null){
                                      await fetchCollection(DateFormat('yyyy-MM-dd').format(_selected!));
                                      setState(() {
                                        _loading=false;
                                      });
                                    }
                                    else{
                                      setState(() {
                                        _loading=false;
                                      });
                                    }

                                  },
                                  child: const SizedBox(
                                    width: 60,
                                    height: 40,
                                    child: Icon(Icons.calendar_month,color: Colors.white,),
                                  ),
                                )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


                Expanded(
                  child: _addData?addShop():SizedBox(
                    child: Column(
                      children: [
                        const SizedBox(height: 5,),
                        _addData || imageDownloaded?SizedBox():FieldArea(title: "Search Name/Shop", ctrl: searchCtrl, type: TextInputType.text, len: 20),
                        const SizedBox(height: 5,),
                        Expanded(
                          child: SizedBox(
                            child: filteredcollectionList.isEmpty?Center(child:Text("Nothing to display")):SizedBox(
                              child: ListView.builder(
                                  padding: EdgeInsets.only(bottom: 80),
                                  itemCount: filteredcollectionList.length,
                                  itemBuilder: (context,int index){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: w-20,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap:()async{
                                                    if(filteredcollectionList[index].file=="NONE"){
                                                      return;
                                                    }
                                                    else{
                                                      setState(() {
                                                        _loading=true;
                                                      });
                                                      // print(collectionList[index].file);
                                                      pickedImage = await apiServices().getBill(filteredcollectionList[index].file,"Collection");
                                                      // print(pickedImage.toString());
                                                      setState(() {
                                                        _loading=false;
                                                      });
                                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                                        return imageViewer(imagefile: pickedImage, mobile: widget.mobile,download: true,);
                                                      }));
                    
                                                    }
                                                  },
                                                  child: SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Center(
                                                      child: filteredcollectionList[index].file=="NONE"?SizedBox():Icon(Icons.image,color: Colors.green,),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        width:w/2,
                                                        child: SingleChildScrollView(
                                                            scrollDirection:Axis.horizontal,
                                                            child: Text("${filteredcollectionList[index].shopname}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))),
                                                    SizedBox(height: 10,),
                                                    SizedBox(
                                                      width: w-150,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text("${filteredcollectionList[index].date}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                                          Text("${filteredcollectionList[index].time}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    
                                                        ],
                                                      ),
                                                    ),
                                                    Text(filteredcollectionList[index].name),
                    
                                                    const SizedBox(height: 10,),
                                                    // Text("${collectionList[index].name}"),
                                                    filteredcollectionList[index].item=="Cash"?SizedBox():SizedBox(
                                                      // width: w/2,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          filteredcollectionList[index].vehicle=="NA"?SizedBox():Text("Vehicle : ${filteredcollectionList[index].vehicle} Kg"),
                                                          filteredcollectionList[index].dry=="0"?SizedBox():Text("Dry : ${filteredcollectionList[index].dry} Kg"),
                                                          filteredcollectionList[index].cloth=="0"?SizedBox():Text("Cloth : ${filteredcollectionList[index].cloth} Kg"),
                    
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: w-150,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          filteredcollectionList[index].item=="Cash"?Text("CASH",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),):filteredcollectionList[index].amt=="0"?SizedBox():Text("Amount : ${filteredcollectionList[index].amt} /-"),
                                                          filteredcollectionList[index].tot=="0"?SizedBox():Text("Total : ${filteredcollectionList[index].tot} /-",style: TextStyle(fontWeight: FontWeight.bold),),
                    
                                                        ],
                                                      ),
                                                    ),
                    
                    
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: (){
                                                        showMessage("Long press to delete");
                                                      },
                                                      onLongPress: ()async{
                                                        setState(() {
                                                          _loading=true;
                                                        });
                                                        String status = await apiServices().deleteCollection(filteredcollectionList[index].id,widget.mobile);
                                                        showMessage(status);
                                                        await fetchCollection(selectedDate);
                                                        setState(() {
                                                          _loading=false;
                                                        });
                                                      },
                                                      child: const SizedBox(
                                                        width: 40,
                                                        height: 50,
                                                        child: Center(
                                                          child: Icon(Icons.delete),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 20,),
                    
                                                    InkWell(
                                                      onTap: ()async{
                                                        await locationServices().openMap(double.parse(filteredcollectionList[index].lat), double.parse(filteredcollectionList[index].long));
                                                      },
                                                      child: Icon(Icons.location_on,color: Colors.green,),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          _loading ? loadingWidget() : const SizedBox(),
        ]));
  }

  void clearShop() {
    selectedBiller = billerModel(
        id: "", name: "", addressl1: "", addressl2: "", addressl3: "", district: "",
        mobile: "", gst: "", division: "", type: "",createDate: "",createTime: "",createUser: "",createMobile: "");
    _shopNameController.clear();
    _L1Controller.clear();
    _L2Controller.clear();
    _L3Controller.clear();
    // _distController.clear();
    distDropDown="Select";
    _phoneController.clear();
    _gstController.clear();
    // addNewShop=false;
  }

  void clearCollection(){
    addNewShop=false;
    _addData=false;
    itemDropDown="Material";
    dropDownType="Select";
    dropDownDiv="Select";
    selectedVehicle="Other";
    _specifyCtrl.clear();
    _shopNameController.clear();
    shopSelected=false;
    _dateController.clear();
    _dryController.clear();
    _clothController.clear();
    _amountCtrl.clear();
    imageLoaded=false;
  }

  Future getImage() async {
    // if(Platform.isAndroid){
      if(imgFromCamera==true){
        pickedImage = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 70);
        // pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.camera);
        // pickedImage = await ImagePicker.platform.getImageFromSource(source: ImageSource.camera,);
      }
      else{
        // pickedImage = await ImagePicker.platform.getImageFromSource(source: ImageSource.gallery);
        pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70);
      }
    // }
    // else if(kIsWeb){
    //   // print("======================WEB");
    //   pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70);
    // }
    // else{
    //   print("======================Other");
    // }

    // print("===================");
    // print(pickedImage.toString());
    if(pickedImage.toString().isNotEmpty) {
      // print("My Comments: Running image picker");
      // print(pickedImage)

      final croppedFile = (await ImageCropper().cropImage(
        // maxHeight: 1000,
        // maxWidth: 800,
        compressFormat: ImageCompressFormat.jpg,
        // compressQuality: 90,
        sourcePath: pickedImage.path,
        // cropStyle: CropStyle.rectangle,
        // aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
          ),

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

  Widget addShop(){
    return Container(
      width: w,
      color: Colors.white,
      height: h,
      child: SingleChildScrollView(

        child: Column(
          children: [
            // FieldArea(title: "Division", ctrl: _divisionCtrl, type: TextInputType.number, len: 3),
            FieldAreaWithDropDown(title: "Item", dropList: itemList, dropdownValue: itemDropDown, callback: dropDownCallback),
            itemDropDown=="Yard"?SizedBox():FieldAreaWithDropDown(
                title: "Division",
                dropList: divList,
                dropdownValue: dropDownDiv,
                callback: dropDownCallback),
            itemDropDown=="Yard"?SizedBox():FieldAreaWithDropDown(
                title: "Type",
                dropList: typeList,
                dropdownValue: dropDownType,
                callback: dropDownCallback),

            itemDropDown=="Yard"?SizedBox():SizedBox(
              width: w - 20,
              height: 50,
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: w / 3,
                    // color: Colors.green,
                    child: const Text(
                      "Add new location:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: w / 2,
                    // color: Colors.grey,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Checkbox(
                        value: addNewShop,
                        onChanged: (value) {
                          clearShop();
                          shopSelected = false;
                          addNewShop = !addNewShop;
                          setState(() {});
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            !addNewShop
                ? itemDropDown=="Yard"?SizedBox():Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: w - 50,
                  height: 60,
                  // color: Colors.grey,
                  child: SizedBox(
                      child:TypeAheadField(
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
                              autofocus: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Search',
                              )
                          );
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text("${suggestion.name}, Div: ${suggestion.division}"),
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
                const SizedBox(
                  height: 10,
                ),
                shopSelected
                    ? Container(
                    width: w - 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black),
                      color: Colors.grey
                          .withOpacity(.2),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                          8.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(selectedBiller
                              .name),
                          Text(selectedBiller
                              .addressl1),
                          Text(selectedBiller
                              .addressl2),
                          Text(selectedBiller
                              .addressl3),
                          Text(selectedBiller
                              .district),
                          Text(selectedBiller
                              .mobile),
                          Text(
                              selectedBiller.gst),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ))
                    : const SizedBox(),
              ],
            )
                : SizedBox(),

            addNewShop
                ? Column(
              children: [
                FieldArea(
                    title: "Building/Shop Name",
                    ctrl: _shopNameController,
                    type: TextInputType.text,
                    len: 20),
                FieldArea(
                    title: "Address L1",
                    ctrl: _L1Controller,
                    type: TextInputType.text,
                    len: 50),
                FieldArea(
                    title: "Address L2",
                    ctrl: _L2Controller,
                    type: TextInputType.text,
                    len: 50),
                FieldArea(
                    title: "Address L3",
                    ctrl: _L3Controller,
                    type: TextInputType.text,
                    len: 50),
                FieldAreaWithDropDown(title: "District", dropList: districtList, dropdownValue: distDropDown, callback: dropDownCallback),
                FieldArea(
                    title: "Phone",
                    ctrl: _phoneController,
                    type: TextInputType.text,
                    len: 15),
                FieldArea(
                    title: "GST",
                    ctrl: _gstController,
                    type: TextInputType.text,
                    len: 20),
              ],
            ):Column(
              children: [
                FieldAreaWithCalendar(title: "Date", ctrl: _dateController, type: TextInputType.datetime,days: 365,fdays: 0,),
                itemDropDown=="Yard"?FieldAreaWithDropDown(title: "Vehicle", dropList: vehicleList, dropdownValue: selectedVehicle, callback: dropDownCallback):SizedBox(),
                itemDropDown=="Yard" && selectedVehicle=="Other"?FieldArea(title: "Specify", ctrl: _specifyCtrl, type: TextInputType.text, len: 20):SizedBox(),
                // FieldAreaWithDropDown(title: "Item", dropList: itemList, dropdownValue: itemDropDown, callback: dropDownCallback),
                itemDropDown!='Material' && itemDropDown!="Yard"?const SizedBox():FieldArea(title: "Dry Weight (KG)", ctrl: _dryController, type: TextInputType.number, len: 8),
                itemDropDown!='Material'?const SizedBox():FieldArea(title: "Cloth Weight (KG)", ctrl: _clothController, type: TextInputType.number, len: 8),
                itemDropDown=="Yard"?SizedBox():FieldArea(title: "Collected Amount", ctrl: _amountCtrl, type: TextInputType.number, len: 5),
                SizedBox(height: 5,),
                itemDropDown=="Yard"?SizedBox():SizedBox(
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(w/2),
                          //   border: Border.all(color: Colors.grey,width: 2),
                          //   color: Colors.white,
                          // ),

                          child: Image.file(File(imageFile!.path),fit: BoxFit.cover,),

                        ),
                      ),
                      Text("${(imageFile!.lengthSync()/1024).toStringAsFixed(0)} Kb"),
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
              ],
            ),

            SizedBox(
              height: 40,
            ),
            SizedBox(
                width: w - 20,
                height: 50,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: w / 4,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.all(
                                AppColors
                                    .buttonColorDark)),
                        onPressed: () {
                          setState(() {
                            _addData=false;
                            clearCollection();
                            clearShop();
                          });
                        },
                        child: const Text(
                          "Back",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: w / 4,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.all(
                                AppColors
                                    .buttonColorDark)),
                        onPressed: () async{

                          //to add a new shop
                          if(addNewShop){
                            if(dropDownDiv!="Select" && dropDownType!="Select" && _shopNameController.text!="" && _L1Controller.text!="" && distDropDown!="Select"){

                              setState(() {
                                _loading=true;
                              });
                              selectedBiller=billerModel(id: "", name: _shopNameController.text, addressl1: _L1Controller.text, addressl2: _L2Controller.text, addressl3: _L3Controller.text, district: distDropDown, mobile: _phoneController.text, gst: _gstController.text, division: dropDownDiv, type: dropDownType,createDate: "",createTime: "",createUser: "",createMobile: "");
                              var status = await apiServices().addBiller(selectedBiller,widget.name,widget.mobile);
                              if(status=="Success"){
                                setState(() {
                                  _loading=false;
                                  clearShop();
                                  clearCollection();
                                  addNewShop=false;
                                });
                                showMessage("Details has been added");
                              }
                            }
                            else{
                              showMessage("Invalid Inputs");
                            }
                          }
                          //to add collection data
                          else{

                            if(itemDropDown!="Yard" && selectedBiller.name=="" && _dateController.text==""){
                              showMessage("Invalid Inputs");
                              return;
                            }
                            else if(itemDropDown=="Yard" && selectedVehicle=="Other" && _specifyCtrl.text==""){
                              showMessage("Invalid Inputs");
                              return;
                            }

                              setState(() {
                                _loading=true;
                              });
                              bool locPer = await locationServices().checkLocationServices();
                              if(!locPer){
                                setState(() {
                                  _loading=false;
                                });
                                showMessage("Location permission denied");
                                return;
                              }
                              else{
                                _position = await Geolocator.getCurrentPosition();
                              }
                              // showMessage("Location fetch completed");
                              String baseimage="";

                              if(imageLoaded) {
                                List<int> imageBytes = imageFile!.readAsBytesSync();
                                baseimage = base64Encode(imageBytes);
                              }
                              var res="";
                              if(itemDropDown=="Yard"){
                                String veh = selectedVehicle;
                                if(selectedVehicle=="Other"){
                                  veh = _specifyCtrl.text;
                                }
                                res = await apiServices().uploadCollection(widget.mobile, widget.name, "2","Yard",veh,_dateController.text, _dryController.text, "0", "0","",_position.latitude,_position.longitude,itemDropDown);
                              }
                              else{
                                res = await apiServices().uploadCollection(widget.mobile, widget.name, selectedBiller.id, selectedBiller.name,"NA",_dateController.text, _dryController.text, _clothController.text, _amountCtrl.text,baseimage,_position.latitude,_position.longitude,itemDropDown);
                              }
                              // var res = await apiServices().uploadCollection(widget.mobile, widget.name, selectedBiller.id, selectedBiller.name,_dateController.text, _dryController.text, _clothController.text, _amountCtrl.text,baseimage,_position.latitude,_position.longitude,itemDropDown);
                              var data = jsonDecode(res);
                              // print(data);
                              if(data['Status']=="Success"){
                                clearCollection();
                                showMessage("Collection uploaded");
                              }
                              else{
                                showMessage("Upload failed");
                              }
                              // print(selectedDate);
                              await fetchCollection(selectedDate);
                              setState(() {
                                _loading=false;
                              });

                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )),

            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

}


