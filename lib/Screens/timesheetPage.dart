import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithCalendar.dart';
import 'package:einlogica_hr/Widgets/FieldAreaWithDropDown.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/activityModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/services/locationService.dart';
import 'package:einlogica_hr/style/colors.dart';

class timesheetPage extends StatefulWidget {

  final String mobile;
  final String name;
  final String permission;
  const timesheetPage({super.key,required this.mobile,required this.name,required this.permission});

  @override
  State<timesheetPage> createState() => _timesheetPageState();
}

class _timesheetPageState extends State<timesheetPage> {

  var w=0.00,h=0.00,t=0.00;
  DateTime selectedDate = DateTime.now();
  bool addPressed=false;
  Position _position = Position(longitude: 0.00, latitude: 0.00, timestamp: DateTime.now(), accuracy: 0.00, altitude: 0.00, altitudeAccuracy: 0.00,
      heading: 0.00, headingAccuracy: 0.00, speed: 0.00, speedAccuracy: 0.00);
  final TextEditingController _siteCtrl = TextEditingController();
  final TextEditingController _activityCtrl = TextEditingController();
  final TextEditingController _startCtrl = TextEditingController();
  final TextEditingController _endCtrl = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController custCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();
  final TextEditingController searchCtrl = TextEditingController();
  int _pending=-1;
  bool _drive=false;
  // List<activityModel> driveList =[];
  bool _loading= true;
  List<activityModel> actList =[];
  List<activityModel> filteredactList =[];
  // bool _addActivity=false;
  DateTime? _selected=DateTime.now();
  String formattedDate="";
  List<String> typeList=[];
  List<String> customerList=[];
  List<String> siteList = ["Select","Other"];
  String dropdownvalue = "Select"; //for Type
  String dropdowncustomer = "Select";
  String dropdownsite = "Select";
  bool unknowndevice=false;

  @override
  void dispose() {
    // TODO: implement dispose
    _siteCtrl.dispose();
    _activityCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    dateController.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // print("permission= ${widget.permission}");
    searchCtrl.addListener(() {
      filterList(searchCtrl.text);
      setState(() {
      });
    });

    fetchData();
  }

  filterList(String filter){

    filteredactList.clear();
    if(filter!=""){
      filteredactList = actList.where((item) => item.name.toLowerCase().contains(filter.toLowerCase()) || item.type.toLowerCase().contains(filter.toLowerCase()) || item.site.toLowerCase().contains(filter.toLowerCase())).toList();

    }
    else{
      filteredactList.addAll(actList);
    }
  }

  checkDevice()async{
    unknowndevice = await apiServices().checkDevice();
    // print("device status = ${unknowndevice.toString()}");
  }

  fetchData()async{
    if(w<h){
      await checkDevice();
    }

    await fetchType();
    List<String> sites=await apiServices().fetchSettingsList("Site Name",widget.mobile);
    siteList.addAll(sites);
    await fetchList(_selected);
  }

  fetchType()async{
    typeList = await apiServices().getActivityType();
    customerList = await apiServices().getCustomerType();
    // print(typeList);
  }

  fetchList(DateTime? sel)async{
    actList.clear();
    filteredactList.clear();
    formattedDate = DateFormat('yyyy-MM-dd').format(sel!);
    // print(formattedDate);
    // print(widget.mobile);
    // print(widget.permission);

    actList = await apiServices().getActivity(widget.mobile, formattedDate,widget.permission);
    filteredactList.addAll(actList);
    setState(() {
      _loading=false;
    });
  }

  dropdowncallback(String title,String value){
    // print(value);
    if(title=="Activity"){
      dropdownvalue = value;
    }
    else if(title=="Customer"){
      dropdowncustomer = value;
    }
    else if(title=="Location"){
      dropdownsite = value;
    }
    // print(dropdownvalue);
    setState(() {

    });
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
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
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
                            const Text("Activity Tracker",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            InkWell(
                              onTap: ()async{
                                setState(() {
                                  _loading=true;
                                });

                                _selected = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(), //get today's date
                                    firstDate:DateTime(2022), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2030)
                                );
                                // print(_selected);
                                if(_selected!=null){
                                  await fetchList(_selected);
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
                // SizedBox(height: 5,),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     width: w,
                //     height: 30,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(5),
                //       color: Colors.blue,
                //     ),
                //
                //     child: Center(child: Text(formattedDate,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),)),
                //   ),
                // ),

                const SizedBox(height: 5,),
                FieldArea(title: "Search", ctrl: searchCtrl, type: TextInputType.text, len: 20),
                const SizedBox(height: 5,),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 50),
                      itemCount: filteredactList.length,
                      itemBuilder: (context,index){

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                                width: w-20,
                                // height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: filteredactList[index].type=="Pending"?Colors.red.shade50:Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                ),
                                child:Row(
                                  children: [
                                    InkWell(
                                      onTap: (){

                                        if(filteredactList[index].drive==true && (filteredactList[index].sKM==0 || filteredactList[index].eKM==0)){
                                          setState(() {
                                            _pending=index;
                                            // print(_pending);
                                            _drive=true;
                                            _siteCtrl.text=filteredactList[_pending].site;
                                            _startCtrl.text=filteredactList[_pending].sKM.toString();
                                            _endCtrl.text=filteredactList[_pending].eKM.toString();
                                            // _activityCtrl.text=actList[_pending].activity;

                                            // _addActivity=true;
                                          });
                                        }

                                      },
                                      child: SizedBox(
                                        width: 60,
                                        child: Icon(filteredactList[index].drive==true?Icons.drive_eta_sharp:Icons.list_alt_sharp,color: (filteredactList[index].drive==true && (filteredactList[index].sKM==0 || filteredactList[index].eKM==0))?Colors.red:Colors.black,size: 30,),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10,),
                                          SizedBox(
                                            // height: 130,
                                            width: w-170,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                widget.permission=="EMP"?Container():Align(
                                                    alignment: Alignment.center,
                                                    child: Text(filteredactList[index].name,style: const TextStyle(color: AppColors.buttonColorDark,fontWeight: FontWeight.bold),)),
                                                Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(filteredactList[index].type,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),),
                                                    const Spacer(),
                                                    filteredactList[index].type=='Pending'?SizedBox():Text(filteredactList[index].date,style: const TextStyle(fontSize: 10,))
                                                  ],
                                                ),

                                                // const SizedBox(height: 10,),
                                                filteredactList[index].type=='Pending'?SizedBox():filteredactList[index].time!=""?Align(alignment: Alignment.centerRight,child: Text(filteredactList[index].time.substring(0,5),style: const TextStyle(color: Colors.black,fontSize: 10),)):const SizedBox(),
                                                filteredactList[index].cust!=""?Text("Customer: ${filteredactList[index].cust}",style: const TextStyle(color: Colors.black,fontSize: 14),):const SizedBox(),
                                                filteredactList[index].site!=""?Text("Location: ${filteredactList[index].site}",style: const TextStyle(color: Colors.black,fontSize: 14),):const SizedBox(),

                                                filteredactList[index].drive==true?Text("${filteredactList[index].sKM} to ${filteredactList[index].eKM} KM",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),):const SizedBox(),
                                                filteredactList[index].remarks!=""?Text("Remarks: ${filteredactList[index].remarks}",style: const TextStyle(color: Colors.black,fontSize: 12),):const SizedBox(),
                                                // Row(
                                                //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //   children: [
                                                //     actList[index].drive==true?Text("${actList[index].sKM} to ${actList[index].eKM} KM",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),):Container(),
                                                //     const Spacer(),
                                                //     // Text("${actList[index].time}",style: TextStyle(fontWeight: FontWeight.bold),)
                                                //   ],
                                                // )
                                              ],
                                            ),
                                          ),

                                          // const SizedBox(height: 10,),
                                          // SizedBox(
                                          //   // height: 130,
                                          //   width: w-170,
                                          //   child: Column(
                                          //     crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //       Text("Activity: ${actList[index].type}",softWrap: true,style: const TextStyle(fontSize: 12),),
                                          //       actList[index].remarks!=""?Text("Remarks: ${actList[index].remarks}",style: const TextStyle(color: Colors.black,fontSize: 12),):const SizedBox(),
                                          //     ],
                                          //   ),
                                          // ),
                                          const SizedBox(height: 10,),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: filteredactList[index].type=="Pending"?SizedBox():Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [

                                          InkWell(
                                            onTap:()async{
                                              setState(() {
                                                _loading=true;
                                              });

                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  title: const Text("Warning!!!"),
                                                  content: const Text("Confirm to delete this activity"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () async{
                                                        Navigator.of(ctx).pop();
                                                        String status = await apiServices().deleteActivity(widget.mobile, filteredactList[index].id);
                                                        _loading=false;
                                                        if(status == "Success"){
                                                          fetchList(DateTime?.now());
                                                        }
                                                        else{
                                                          setState(() {

                                                          });
                                                          showMessage("Failed to delete activity");
                                                        }

                                                      },
                                                      child: Container(
                                                        // color: Colors.green,
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
                                                          _loading=false;
                                                        });
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        // color: Colors.green,
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
                                              );

                                            },
                                            child: const SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Icon(Icons.close,color: Colors.black,size: 30,),
                                            ),
                                          ),
                                          InkWell(
                                            onTap:()async{
                                              await locationServices().openMap(double.parse(actList[index].lat), double.parse(actList[index].long));
                                            },
                                            child: const SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Icon(Icons.location_on_rounded,color: Colors.teal,size: 30,),
                                            ),
                                          ),
                                        ],
                                      ),

                                    )

                                  ],
                                )

                            ),
                          ),
                        );
                      }),
                ),

              ],
            ),
          ),
           widget.permission=="EMP"?unknowndevice?const SizedBox():AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            top: addPressed?t:widget.permission=="MAN"?h:h-60,
            child: SizedBox(
              width: w,
              height: h,
              child: Column(
                children: [
                  SizedBox(

                    width: w,
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.buttonColorDark),shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                          )
                      )),
                      onPressed: ()async{

                        if(addPressed==false){
                          setState(() {
                            addPressed=!addPressed;
                            // print(addPressed.toString());
                          });
                          bool status=await locationServices().checkLocationServices();
                          if(status==true) {
                            _position = await Geolocator.getCurrentPosition();
                            setState(() {
                            });
                          }

                        }


                      },
                      child: const Text("Add Activity",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
                    ),
                  ),
                  Container(
                    height: h-120,
                    color: Colors.white,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                      
                            // const SizedBox(height: 20,),
                            FieldAreaWithDropDown(title: "Activity", dropList: typeList, dropdownValue: dropdownvalue, callback: dropdowncallback),
                            dropdownvalue=="Others"?FieldArea(title: "Activity Name", ctrl: _activityCtrl, type: TextInputType.text, len: 50):SizedBox(),
                            FieldAreaWithDropDown(title: "Customer", dropList: customerList, dropdownValue: dropdowncustomer, callback: dropdowncallback),
                            dropdowncustomer=="Others"?FieldArea(title: "Customer Name", ctrl: custCtrl, type: TextInputType.text, len: 20):SizedBox(),
                            // FieldArea(title: "Location", ctrl: _siteCtrl, type: TextInputType.text, len: 40),
                            FieldAreaWithDropDown(title: "Location", dropList: siteList, dropdownValue: dropdownsite, callback: dropdowncallback),
                            dropdownsite=="Other"?FieldArea(title: "Specify Location", ctrl: _siteCtrl, type: TextInputType.text, len: 40):SizedBox(),
                            FieldAreaWithCalendar(title: "Date", ctrl: dateController, type: TextInputType.datetime,days:365),
                            // FieldArea(title: "Activity", ctrl: _activityCtrl, type: TextInputType.text, len: 200),
                            // FieldArea(title: "Customer Name", ctrl: custCtrl, type: TextInputType.text, len: 20),
                            FieldArea(title: "Remarks", ctrl: remarksCtrl, type: TextInputType.text, len: 50),
                      
                            SizedBox(
                              width: w-20,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: w*.2,
                                    // color: Colors.green,
                                    child: const Text("Drive:",style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  SizedBox(
                                    width: w*.6,
                                    // color: Colors.grey,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Checkbox(
                      
                                        value: _drive,
                                        onChanged: (value){
                                          if(_pending==-1){
                                            _drive=!_drive;
                                            setState(() {
                      
                                            });
                                          }
                      
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            _drive?FieldArea(title: "Start KM:", ctrl: _startCtrl, type: TextInputType.number, len: 10):SizedBox(),
                            _drive?FieldArea(title: "End KM:", ctrl: _endCtrl, type: TextInputType.number, len: 10):SizedBox(),
                      
                            _pending==-1?SizedBox(
                              width: w-20,
                              height: 30,
                              // color: Colors.grey,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: w*.2,
                                    // color: Colors.green,
                                    child: const Text("Latitude:",style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  SizedBox(
                                      width: w*.6,
                                      child: Text("${_position.latitude}")
                                  ),
                                ],
                              ),
                            ):const SizedBox(),
                            // SizedBox(height: 10,),
                            _pending==-1?SizedBox(
                              width: w-20,
                              height: 30,
                              // color: Colors.grey,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: w*.2,
                                    // color: Colors.green,
                                    child: const Text("Longitude:",style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  SizedBox(
                                      width: w*.6,
                                      child: Text("${_position.longitude}")
                                  ),
                                ],
                              ),
                            ):const SizedBox(),
                            const SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.buttonColorDark)),
                                    onPressed: ()async{
                                      setState(() {
                                        _loading=true;
                                      });
                                      String status="";
                                      if(dropdownsite!="Select" && dateController.text!="" && dropdownvalue!="Select" && dropdowncustomer!="Select"){
                                        String cust=dropdowncustomer;
                                        String act=dropdownvalue;
                                        String loc=dropdownsite;
                                          if(dropdowncustomer=='Others'){
                                            cust=custCtrl.text;
                                          }
                      
                                          if(dropdownvalue=="Others"){
                                            act=_activityCtrl.text;
                                          }

                                          if(dropdownsite=="Other"){
                                            loc=_siteCtrl.text;
                                          }
                      
                      
                                          status = await apiServices().postActivity(widget.name, widget.mobile, act, loc,dateController.text,_drive,_startCtrl.text,_endCtrl.text, _position.latitude.toString(), _position.longitude.toString(), act,cust,remarksCtrl.text);
                                          if(status=="Success"){
                                            clearFields();
                                            addPressed=false;
                                            fetchList(DateTime?.now());
                      
                                          }
                                          else{
                                            showMessage("Error submitting data");
                                          }
                                      }
                                      else{
                                        showMessage("Invalid inputs");
                                      }
                                      setState(() {
                                        _loading=false;
                                      });
                      
                                    }, child: const Text("Submit",style: TextStyle(color: Colors.white),)),
                                ElevatedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.buttonColorDark)),
                                    onPressed: (){
                                      clearFields();
                                      setState(() {
                                        // _addActivity=false;
                                        addPressed=false;
                                      });
                                    }, child: const Text("Cancel",style: TextStyle(color: Colors.white),))
                              ],
                            ),
                            const SizedBox(height: 60,),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ):const SizedBox(),
          _loading?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }

  clearFields(){
    _pending=-1;
    _activityCtrl.clear();
    _siteCtrl.clear();
    _drive=false;
    _startCtrl.clear();
    _endCtrl.clear();
    dateController.clear();
    dropdownvalue = "Select";
    dropdowncustomer="Select";
    dropdownsite="Select";
    custCtrl.clear();
    remarksCtrl.clear();
    // _addActivity=false;
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }


  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2022),
  //     lastDate: DateTime(2030),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     // setState(() {
  //     //   selectedDate = picked;
  //     // });
  //     fetchData(picked);
  //   }
  // }

}
