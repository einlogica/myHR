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


  var w = 0.00, h = 0.00, t = 0.00;
  bool _loading = true;
  bool _addData = false;
  bool addNewShop = false;
  bool shopSelected = false;


  final TextEditingController _divisionCtrl = TextEditingController();
  final TextEditingController _typeCtrl = TextEditingController();
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


  List<String> typeList = ["Select", "Bank","Flat", "Hospital", "Office", "Shop"];
  List<String> divList = ["Select","Division 12", "Division 13", "Division 14"];
  List<String> itemList = ["Material","Cash"];
  List<String> districtList = ["Select"];
  String dropDownDiv = "Select";
  String dropDownType = "Select";
  String distDropDown = "Select";
  String itemDropDown = "Material";


  String selectedDate ="";


  @override
  void dispose() {
    // TODO: implement dispose
    _divisionCtrl.dispose();
    _typeCtrl.dispose();
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
    super.initState();
  }

  fetchData() async {
    districtList=await apiServices().getDistrict("KERALA");
    await fetchCollection(selectedDate);
    setState(() {
      _loading=false;
    });
  }

  fetchCollection(String date)async{
    // print("calling fetch collection");
    filteredcollectionList.clear();
    collectionList = await apiServices().getCollection(widget.mobile,widget.permission,date);

    filteredcollectionList.addAll(collectionList);

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
    else if(title == "District"){
      distDropDown = selected;
    }
    else if(title == "Item"){
      _clothController.clear();
      _dryController.clear();
      _amountCtrl.clear();
      itemDropDown = selected;
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
                  height: 80 + t,
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
                        height: 80,
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
                const SizedBox(height: 5,),
                _addData || imageDownloaded?SizedBox():FieldArea(title: "Search Name/Shop", ctrl: searchCtrl, type: TextInputType.text, len: 20),
                const SizedBox(height: 5,),
                Expanded(
                  child: SizedBox(
                    child: Stack(
                      children: [

                        filteredcollectionList.isEmpty?Center(child:Text("Nothing to display")):SizedBox(
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
                                                // SizedBox(
                                                //   width: w-150,
                                                //   child: Row(
                                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //     children: [
                                                //       Text("${collectionList[index].shopname}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                                                //       Text("${collectionList[index].date}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                                                //
                                                //     ],
                                                //   ),
                                                // ),
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
                                                Text("${filteredcollectionList[index].name}"),

                                                SizedBox(height: 10,),
                                                // Text("${collectionList[index].name}"),
                                                filteredcollectionList[index].item=="Cash"?SizedBox():SizedBox(
                                                  // width: w/2,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text("Dry : ${filteredcollectionList[index].dry} Kg"),
                                                      Text("Cloth : ${filteredcollectionList[index].cloth} Kg"),

                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: w-150,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      filteredcollectionList[index].item=="Cash"?Text("CASH",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),):Text("Amount : ${filteredcollectionList[index].amt} /-"),
                                                      Text("Total : ${filteredcollectionList[index].tot} /-",style: TextStyle(fontWeight: FontWeight.bold),),

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

                        _addData
                            ? Container(
                          width: w,
                          color: Colors.white,
                          // height: h-100,
                          child: SingleChildScrollView(

                            child: Column(
                              children: [
                                FieldArea(title: "Division", ctrl: _divisionCtrl, type: TextInputType.number, len: 3),
                                // FieldAreaWithDropDown(
                                //     title: "Division",
                                //     dropList: divList,
                                //     dropdownValue: dropDownDiv,
                                //     callback: dropDownCallback),
                                FieldAreaWithDropDown(
                                    title: "Type",
                                    dropList: typeList,
                                    dropdownValue: dropDownType,
                                    callback: dropDownCallback),
                                SizedBox(
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
                                    ? Column(
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
                                                  autofocus: true,
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
                                        // width: w-50,
                                        // child: TypeAheadField(
                                        //   textFieldConfiguration:
                                        //   TextFieldConfiguration(
                                        //     controller:
                                        //     _shopNameController,
                                        //     decoration: InputDecoration(
                                        //       // icon: Icon(Icons.password),
                                        //       hintText:
                                        //       "Search Name",
                                        //       // labelText: 'Name/GST',
                                        //       filled: true,
                                        //       fillColor: Colors.white,
                                        //       enabled: true,
                                        //       border: OutlineInputBorder(
                                        //           borderRadius:
                                        //           BorderRadius
                                        //               .circular(10)),
                                        //     ),
                                        //     // decoration: InputDecoration(labelText: 'Enter shop name'),
                                        //   ),
                                        //   suggestionsCallback:
                                        //       (pattern) async {
                                        //     // Call a method to fetch shop name suggestions from the database
                                        //     // print("AAA");
                                        //     if (pattern.length > 2) {
                                        //       shopSelected = false;
                                        //       return await apiServices()
                                        //           .getBiller(
                                        //           pattern, "Name");
                                        //     } else {
                                        //       return [];
                                        //     }
                                        //   },
                                        //   itemBuilder:
                                        //       (context, suggestion) {
                                        //     return ListTile(
                                        //       title: Text(
                                        //           "${suggestion.name}, Div: ${suggestion.division}"),
                                        //       // subtitle: Text(suggestion.gst),
                                        //     );
                                        //   },
                                        //   onSuggestionSelected:
                                        //       (suggestion) {
                                        //     // Handle the selection of a suggestion
                                        //     selectedBiller = suggestion;
                                        //     shopSelected = true;
                                        //     _shopNameController.text =
                                        //         suggestion.name;
                                        //   },
                                        // ),
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
                                    FieldAreaWithCalendar(title: "Date", ctrl: _dateController, type: TextInputType.datetime,days: 365,),
                                    FieldAreaWithDropDown(title: "Item", dropList: itemList, dropdownValue: itemDropDown, callback: dropDownCallback),
                                    itemDropDown=='Cash'?SizedBox():FieldArea(title: "Dry Weight (KG)", ctrl: _dryController, type: TextInputType.number, len: 8),
                                    itemDropDown=='Cash'?SizedBox():FieldArea(title: "Cloth Weight (KG)", ctrl: _clothController, type: TextInputType.number, len: 8),
                                    FieldArea(title: "Collected Amount", ctrl: _amountCtrl, type: TextInputType.number, len: 5),
                                    SizedBox(height: 5,),
                                    SizedBox(
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
                                                if(_divisionCtrl.text.length>0 && dropDownType!="Select" && _shopNameController.text!="" && _L1Controller.text!="" && distDropDown!="Select"){

                                                  setState(() {
                                                    _loading=true;
                                                  });
                                                  selectedBiller=billerModel(id: "", name: _shopNameController.text, addressl1: _L1Controller.text, addressl2: _L2Controller.text, addressl3: _L3Controller.text, district: distDropDown, mobile: _phoneController.text, gst: _gstController.text, division: _divisionCtrl.text, type: dropDownType,createDate: "",createTime: "",createUser: "",createMobile: "");
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

                                                if(selectedBiller.name!="" && _dateController.text!=""){
                                                  // if(imageLoaded && imageFile!.lengthSync()/1024>200){
                                                  //   showMessage("Image size should not be greater that 200Kb");
                                                  //   return;
                                                  // }
                                                  setState(() {
                                                    _loading=true;
                                                  });
                                                  _position = await Geolocator.getCurrentPosition();
                                                  String baseimage="";

                                                  if(imageLoaded) {
                                                    List<int> imageBytes = imageFile!.readAsBytesSync();
                                                    baseimage = base64Encode(imageBytes);
                                                  }

                                                  var res = await apiServices().uploadCollection(widget.mobile, widget.name, selectedBiller.id, selectedBiller.name,_dateController.text, _dryController.text, _clothController.text, _amountCtrl.text,baseimage,_position.latitude,_position.longitude,itemDropDown);
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
                                                else{
                                                  showMessage("Invalid Inputs");
                                                }
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
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ):SizedBox(),

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),


          // imageDownloaded?Container(
          //   width: w,
          //   height: h,
          //
          //   color: Colors.white,
          //   // child: Image(image: Image.memory(profileImage).image),
          //   child: PhotoView(
          //     imageProvider: Image.memory(pickedImage).image,
          //   ),
          // ):Container(),
          //     imageDownloaded?SafeArea(
          //         child:Align(
          //           alignment: Alignment.bottomCenter,
          //           child: SizedBox(
          //             width: w,
          //             height: 50,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: [
          //                 ElevatedButton(
          //                     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
          //                     onPressed: ()async{
          //
          //                       setState(() {
          //                         _loading=true;
          //                       });
          //                       String status = await savefile().downloadImage("${widget.mobile}-${DateTime.now().millisecond}.png" , pickedImage);
          //                       showMessage(status);
          //                       setState(() {
          //                         _loading=false;
          //                       });
          //                     }, child: const Text("Download",style: TextStyle(color: Colors.white),)),
          //                 ElevatedButton(
          //                     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
          //                     onPressed: (){
          //                       setState(() {
          //                         imageDownloaded=false;
          //                       });
          //                     }, child: const Text("Close",style: TextStyle(color: Colors.white),))
          //               ],
          //             ),
          //           ),
          //         )
          //     ):SizedBox(),

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
    dropDownType="Select";
    dropDownDiv="Select";
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

}


