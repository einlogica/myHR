
import 'package:einlogica_hr/Screens/Accounts/privacyPage.dart';
import 'package:einlogica_hr/Screens/Accounts/refundPage.dart';
import 'package:einlogica_hr/Screens/Accounts/terms.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Models/employerModel.dart';
import '../../Models/userModel.dart';
import '../../Widgets/loadingWidget.dart';
import '../../style/colors.dart';
import 'dropDownSetting.dart';
import 'locationsPage.dart';

class settingsPage extends StatefulWidget {

  final userModel currentUser;
  const settingsPage({super.key,required this.currentUser});

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {

  var w=0.00,h=0.00,t=0.00;
  // final TextEditingController _addCtrl = TextEditingController();
  String selectedOption = "";
  bool optionSelected=false;
  bool _loading=true;

  List<String> settings = ["Drop Down","Locations"];
  Uint8List empIcon= Uint8List(0);
  List<employerModel> empDetails = [];

  // List<String> settingsImage = ['assets/Drop Down.png','assets/Locations.png'];
  // List<String> selectedList = [];

  // Future fetchList(String selectedOption)async{
  //   print(selectedOption);
  //   selectedList.clear();
  //   selectedList=await apiServices().fetchSettingsList(selectedOption,widget.currentUser.Mobile);
  //
  //   optionSelected=true;
  // }


  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  fetchData()async{
    empIcon=await apiServices().getBill(widget.currentUser.Employer, "Employer");
    empDetails = await apiServices().getEmployer(widget.currentUser.Employer);
    setState(() {
      _loading=false;
    });
  }

  menuFunction(String name){
    if(name=="Drop Down"){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return dropDownSettingsPage(currentUser: widget.currentUser);
      }));
    }
    else if(name=="Locations"){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return locationsPage(currentUser: widget.currentUser);
      }));
    }

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
            // color: Colors.grey,
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
                            const Text("Account Settings",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            const SizedBox(
                              width: 60,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: w>h?w/5:w/2,
                  height: w>h?w/5:w/2,
                  child: Stack(
                    children: [
                      Container(
                        width: w>h?w/5:w/2,
                        height: w>h?w/5:w/2,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(w/4),
                        //   // border: Border.all(color: Colors.black,width: 2),
                        //   color: Colors.white,
                        // ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: empIcon.isNotEmpty?Image.memory(empIcon,fit: BoxFit.contain,):Image.asset('assets/profile.png'),
                        ),
                      ),

                    ],
                  ),
                ),
                // SizedBox(height: 20,),
                empDetails.length!=0?SizedBox(
                  child: Column(
                    children: [
                      Text(empDetails[0].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      Text(empDetails[0].addl1),
                      Text(empDetails[0].addl2),
                    ],
                  ),
                ):SizedBox(),
                SizedBox(height: 20,),
                Expanded(

                  child: Container(
                    // height: settings.length*76,
                    // color: Colors.blue,
                    child: ListView.builder(
                        itemCount: settings.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context,index){
                          return menuButton(settings[index].toString(),menuFunction);

                        }),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return termsPage();
                        }));
                      },
                      child: SizedBox(
                        width: w/4,
                        child: Center(child: Text("T&C",style: TextStyle(fontSize: 11),)),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return privacyPage();
                        }));
                      },
                      child: SizedBox(
                        width: w/4,
                        child: Center(child: Text("Privacy",style: TextStyle(fontSize: 11),)),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return refundPage();
                        }));
                      },
                      child: SizedBox(
                        width: w/4,
                        child: Center(child: Text("Refund",style: TextStyle(fontSize: 11),)),
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 20,),
              ],
            ),
          ),
          _loading?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }

  // _loading?loadingWidget():const SizedBox(),

  Widget menuButton(String item,Function callback){
    // print(item);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          callback(item);
        },
        child: Container(
          width: w-50,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 80,
              height: 30,
              child: Center(child: Icon(Icons.settings)),),
              SizedBox(
                width: w/2,
                height: 60,
                child: Align(alignment: Alignment.centerLeft,child: Text(item)),
              ),
              SizedBox(
                width: 100,
                height: 40,
                child: Image.asset('assets/$item.png'),
              )
            ],
          ),
        ),
      ),
    );
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }
}
