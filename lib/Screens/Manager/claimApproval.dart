import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:einlogica_hr/Models/userExpenseModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../Widgets/FieldArea.dart';
import '../../Widgets/imageViewer.dart';

class claimApprovalPage extends StatefulWidget {

  final userModel currentUser;
  final Function callback;
  const claimApprovalPage({super.key, required this.currentUser,required this.callback});

  @override
  State<claimApprovalPage> createState() => _claimApprovalPageState();
}

class _claimApprovalPageState extends State<claimApprovalPage> {

  var w=0.00,h=0.00,t=0.00;

  List<userExpenseModel> userExpenseList=[];
  List<userExpenseModel> approvedExpenseList=[];
  List<userExpenseModel> pendingExpenseList=[];
  bool approved = false;
  String _id = "";
  TextEditingController commentsCtrl = TextEditingController();
  bool imageDownloaded =false;
  bool refresh = true;
  var profileImage;
  DateTime? _selected;
  String searchWord="";
  TextEditingController searchCtrl = TextEditingController();
  List<String> pendingId = [];
  double total =0;

  @override
  void dispose() {
    // TODO: implement dispose
    commentsCtrl.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected=DateTime.now();
    fetchClaims(_selected!);
    searchCtrl.addListener(() {

      filterList(userExpenseList, searchCtrl.text);
      setState(() {

      });

    });
  }




  fetchClaims(DateTime claimmonth)async{
    // print(claimmonth);
    userExpenseList.clear();
    if(widget.currentUser.Permission=="Admin" || widget.currentUser.Department=='Finance'){
      userExpenseList=await apiServices().getUserExpenses(widget.currentUser.Mobile,claimmonth.month.toString(),claimmonth.year.toString(), "ALL",);
    }
    else{
      userExpenseList=await apiServices().getUserExpenses(widget.currentUser.Mobile,claimmonth.month.toString(),claimmonth.year.toString(), "MAN",);
    }
    // for (var d in userExpenseList){
    //   if(d.Status=="Approved" || d.Status=="Rejected" || d.Status=='Cleared'){
    //     approvedExpenseList.add(d);
    //   }
    //   else{
    //     pendingExpenseList.add(d);
    //   }
    // }
    await filterList(userExpenseList,"");
    setState(() {
      refresh=false;
    });
  }

  filterList(List<userExpenseModel> userExpenseList,String filter){
    // print("filter word = $filter");
    approvedExpenseList.clear();
    pendingExpenseList.clear();
    for (var d in userExpenseList){

      if(filter!=""){
        if(d.Name.toLowerCase().contains(filter.toLowerCase()) || d.Type.toString().toLowerCase().contains(filter.toLowerCase()) || d.LabourName.toLowerCase().contains(filter.toLowerCase()) || d.Site.toLowerCase().contains(filter.toLowerCase())) {
          if (d.Status == "Approved" || d.Status == "Rejected" || d.Status == 'Cleared') {
            approvedExpenseList.add(d);
          }
          else {
            pendingExpenseList.add(d);
          }
        }
      }
      else{
        if(d.Status=="Approved" || d.Status=="Rejected" || d.Status=='Cleared'){
          approvedExpenseList.add(d);
        }
        else{
          pendingExpenseList.add(d);
        }
      }

    }

  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        width: w,
        height: h,
        child: Stack(
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
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
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
                                  Navigator.pop(context);
                                },
                                child: const SizedBox(
                                  width: 60,
                                  height: 40,
                                  // color: Colors.grey,
                                  child: Center(child: Icon(Icons.arrow_back,size: 20,color: Colors.white,)),
                                ),
                              ),
                              const Text("Claim Approval",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                              SizedBox(
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: ()async{
                                        _selected = await showMonthYearPicker(

                                          context: context,
                                          initialDate: _selected ?? DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime.now(),
                                          // locale: localeObj,
                                        );
                                        // print(_selected!.toString());
                                        if(_selected!=null){
                                          // print("fetching new claim");
                                          fetchClaims(_selected!);
                                        }

                                      },
                                      child: const SizedBox(
                                        width: 60,
                                        height: 40,
                                        child: Icon(Icons.calendar_month,color: Colors.white,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  FieldArea(title: "Search", ctrl: searchCtrl, type: TextInputType.text, len: 20),
                  const SizedBox(height: 5,),
                  Container(
                    width: w-20,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(

                          child: Container(
                            width: w/2-20,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: !approved?Colors.blue:Colors.grey
                            ),
                            child: const Center(child: Text("Pending",style: TextStyle(color: Colors.white),)),
                          ),
                          onTap: (){
                            setState(() {
                              approved=false;
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: w/2-20,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: approved?Colors.blue:Colors.grey
                            ),
                            child: const Center(child: Text("Approved",style: TextStyle(color: Colors.white),)),
                          ),
                          onTap: (){
                            setState(() {
                              approved=true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),

                  Expanded(
                    child:claims(),
                  ),

                  pendingId.isNotEmpty?Container(
                    width: w,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                      color: Colors.green.shade100,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 5,),
                        const Text("Finance Clearence",style: TextStyle(fontWeight: FontWeight.bold),),
                        Container(
                          width: w,
                          color: Colors.blue.shade100,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 30,

                                child: Center(
                                  child: Text("${total.toString()} /-",style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                              ),
                              const SizedBox(width: 5,),
                              SizedBox(
                                width: w-105,

                                child: TextFormField(
                                  enabled: true,
                                  controller: commentsCtrl,
                                  // keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.phone),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Comments",
                                    enabled: true,
                                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(color: Colors.blue.shade900),
                                    ),

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: w,
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              ElevatedButton(
                                onPressed: ()async{
                                  if(commentsCtrl.text==""){
                                    showMessage("Invalid remarks entry");
                                    return;
                                  }
                                  String status = await apiServices().clearBill(pendingId, widget.currentUser.Permission, "Cleared",commentsCtrl.text);
                                  if(status=="Success"){

                                    showMessage("Successfully updated expense");
                                  }
                                  else{
                                    showMessage("Failed to update expense");
                                  }
                                  fetchClaims(_selected!);
                                  commentsCtrl.clear();
                                  pendingId.clear();
                                  setState(() {

                                  });

                                },
                                child: const Text("Clear All"),
                              ),
                              ElevatedButton(
                                onPressed: (){
                                  pendingId.clear();
                                  setState(() {

                                  });
                                },
                                child: const Text("Cancel"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
                      ],
                    ),
                  ):const SizedBox(),

                ],
              ),
            ),
            // imageDownloaded?Container(
            //   width: w,
            //   height: h,
            //   color: Colors.black,
            //   child: Center(
            //     child: SizedBox(
            //       width: w-50,
            //       height: h-50,
            //       child: PhotoView(
            //         imageProvider: Image.memory(profileImage).image,
            //       ),
            //     ),
            //   ),
            // ):const SizedBox(),
            // imageDownloaded?SafeArea(
            //     child:Align(
            //       alignment: Alignment.bottomCenter,
            //       child: SizedBox(
            //         width: w,
            //         height: 50,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             ElevatedButton(
            //                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
            //                 onPressed: ()async{
            //
            //                   setState(() {
            //                     refresh=true;
            //                   });
            //                   String status = await savefile().downloadImage("${widget.currentUser.Mobile}-${DateTime.now().millisecond}.png" , profileImage);
            //                   showMessage(status);
            //                   setState(() {
            //                     refresh=false;
            //                   });
            //                 }, child: const Text("Download",style: TextStyle(color: Colors.white),)),
            //             ElevatedButton(
            //                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
            //                 onPressed: (){
            //                   setState(() {
            //                     imageDownloaded=false;
            //                   });
            //                 }, child: const Text("Close",style: TextStyle(color: Colors.white),))
            //           ],
            //         ),
            //       ),
            //     )
            // ):SizedBox(),
            // imageDownloaded?Container(
            //   width: w,
            //   height: h,
            //
            //   color: Colors.white,
            //   // child: Image(image: Image.memory(profileImage).image),
            //   child: PhotoView(
            //     imageProvider: Image.memory(profileImage).image,
            //   ),
            // ):const SizedBox(),
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
            // ):const SizedBox(),
            refresh?loadingWidget():const SizedBox(),
          ],
        ),
      ),
    );
  }




  Future showDialogBox(String id){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // backgroundColor: AppColors.boxColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure to delete this claim request? "),
        actions: <Widget>[
          TextButton(
            onPressed: () async{
              // String status = await apiServices().deleteLeave(id,"MAN");
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
              widget.callback();
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: AppColors.buttonColor,
              padding: const EdgeInsets.all(14),
              child: const Text("Confirm",style: TextStyle(color: Colors.white),),
            ),
          ),
          TextButton(
            onPressed: () {

              Navigator.of(ctx).pop();
            },
            child: Container(
              color: AppColors.buttonColor,
              padding: const EdgeInsets.all(14),
              child: const Text("Cancel",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }



  Widget claims(){
    return SizedBox(
      width: w-20,
      child: (approved && approvedExpenseList.isEmpty) || (!approved && pendingExpenseList.isEmpty)? const Center(
        child: Text("Nothing to display"),
      ):ListView.builder(
          padding: EdgeInsets.only(bottom: 50),
          itemCount: approved?approvedExpenseList.length:pendingExpenseList.length,
          itemBuilder: (context,int index){
            // print(index);
            // var item=userExpenseList[userExpenseList.length-index-1];
            var item = approved?approvedExpenseList[index]:pendingExpenseList[index];
            // return expenseCard(item);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onLongPress: (){
                  if(approved && approvedExpenseList[index].Status=='Approved' && (widget.currentUser.Department=='Finance' || widget.currentUser.Permission=='Admin')){
                    total=0;
                    // print(pendingList[index].Id);
                    pendingId.add(approvedExpenseList[index].ID);
                    total=total+double.parse(approvedExpenseList[index].Amount);
                    setState(() {

                    });
                  }
                },
                onTap: (){
                  if(pendingId.isNotEmpty && approvedExpenseList[index].Status=='Approved'){
                    if(pendingId.contains(approvedExpenseList[index].ID)){
                      pendingId.remove(approvedExpenseList[index].ID);
                      total=total-double.parse(approvedExpenseList[index].Amount);
                    }
                    else{
                      pendingId.add(approvedExpenseList[index].ID);
                      total=total+double.parse(approvedExpenseList[index].Amount);
                    }
                    setState(() {

                    });
                  }
                },
                child: Container(
                  width: w-20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: approved?pendingId.contains(approvedExpenseList[index].ID)?Colors.green.shade100:Colors.white:Colors.white,
                      boxShadow: const [BoxShadow(
                        color: Colors.black26,
                        blurRadius: 0.2,
                        spreadRadius: 0.2,
                        offset: Offset(0.0, 4.0,),
                      ),]
                  ),
                  child: ListTile(
                    onTap: (){
                      commentsCtrl.clear();
                      showDetailBox(item);
                    },
                    title: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.Name,style: const TextStyle(color: Colors.blue),),
                            Text(item.Date)
                          ],
                        )),
                    subtitle: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: w/5,
                                child: SingleChildScrollView(
                                    scrollDirection:Axis.horizontal,
                                    child: Text(item.Type))),
                            Text("${item.Status}",style: TextStyle(color: item.Status=='Approved'?Colors.green:item.Status=='Applied'?Colors.blue:Colors.red),),
                            Text(item.Amount,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),)
                          ],
                        )),
                    leading: InkWell(
                      onTap: ()async{
                        if(item.Filename=="NONE"){
                          return;
                        }
                        else{
                          setState(() {
                            refresh=true;
                          });

                          profileImage=await apiServices().getBill(item.Filename,"Bill");

                          setState(() {
                            refresh=false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return imageViewer(imagefile: profileImage, mobile: widget.currentUser.Mobile,download: true,);
                          }));
                        }
                      },
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(Icons.receipt,color: item.Filename=="NONE"?Colors.grey:Colors.green,)),
                    ),
                    // trailing: InkWell(
                    //   onTap: (){
                    //     commentsCtrl.clear();
                    //     showDetailBox(item);
                    //   },
                    //   child: const SizedBox(
                    //       width: 30,
                    //       height: 30,
                    //       child: Icon(Icons.arrow_forward_ios_rounded)),
                    // ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }


  Future showDetailBox(userExpenseModel item){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.all(10),
          insetPadding: EdgeInsets.all(10),
          // title: Text(item.Name),
          content: expenseCard(item),
        )
    );
  }





  Widget expenseCard(userExpenseModel item){
    // =userItem;
    return Container(
      // width: w-10,
      // height: w+20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Colors.black,width: 1),
          boxShadow: const [BoxShadow(
            color: Colors.black26,
            blurRadius: 0.2,
            spreadRadius: 0.2,
            offset: Offset(0.0, 4.0,),
          ),
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SizedBox(height: 10,),

              Container(
                width: w-10,
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                  color: AppColors.buttonColor,
                ),
                child: Center(child: Text(item.Name,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),)),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                // height:200,
                // color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: w/4,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.boxColor
                            ),
                            child: Center(
                              child: Text("Rs ${item.Amount} /-",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),),
                            ),
                          ),
                          SizedBox(
                            width: w/4,
                            child: Text(item.Date,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black)),
                          )

                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    billText("Type", item.Type),
                    item.Item==""?const SizedBox():billText("Specify", item.Item),
                    // SizedBox(height: 5,),
                    item.Type=="Purchase"?Column(
                      children: [
                        billText("Shop Name", item.ShopName),
                        billText("District", item.ShopDist),
                        billText("GST", item.ShopGst),
                        billText("Phone", item.ShopPhone),
                      ],
                    ):const SizedBox(),
                    item.Site==""?const SizedBox():billText("Location", item.Site),
                    item.LabourName==""?const SizedBox():billText("Labour Name", item.LabourName),
                    item.Duration==""?const SizedBox():billText("Duration", item.Duration),
                    item.FromLoc==""?const SizedBox():billText("From", item.FromLoc),
                    item.ToLoc==""?const SizedBox():billText("To", item.ToLoc),
                    item.KM.toString()=="0"?const SizedBox():billText("KM", item.KM),
                    item.L1Status==""?const SizedBox():billText("Manager", item.L1Status),
                    item.L1Comments==""?const SizedBox():billText("Comments", item.L1Comments),
                    item.L2Status==""?const SizedBox():billText("Admin", item.L2Status),
                    item.L2Comments==""?const SizedBox():billText("Comments", item.L2Comments),
                    item.FinRemarks==""?const SizedBox():billText("Finance", item.FinRemarks),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        const SizedBox(width: 20,),
                        Text("Status: ${item.Status}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        const SizedBox(width: 20,),

                      ],
                    ),
                    const SizedBox(height: 10,)

                  ],
                ),
              ),
              item.Status=="Cancel Req"?const SizedBox(height: 10,):const SizedBox(),
              item.Status=="Cancel Req"?SizedBox(
                  child:InkWell(
                    onTap:(){

                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.buttonColorDark.withOpacity(.4),
                          boxShadow: const [BoxShadow(
                            color: Colors.black26,
                            blurRadius: 0.2,
                            spreadRadius: 0.2,
                            offset: Offset(0.0, 4.0,),
                          ),
                          ]
                      ),
                      child: const Text("Delete",style: TextStyle(color: Colors.white),),
                    ),
                  )
              ):const SizedBox(),

              //Approval if status is pending
              item.Status=="Applied"?const SizedBox(height: 10,):const SizedBox(),
              (widget.currentUser.Permission=='Admin' || widget.currentUser.Permission=='Manager')?SizedBox(
                  child: (widget.currentUser.Permission=='Manager' && (item.Status=='L1 Approved' || item.Status=='Approved'))?SizedBox():Column(
                    children: [
                      FieldArea(title: "Comments",type: TextInputType.text,ctrl: commentsCtrl,len: 50,),

                      Row(
                        children: [
                          TextButton(
                            onPressed: () async{
                              setState(() {
                                refresh=true;
                              });
                              Navigator.of(context).pop();
                              String status = await apiServices().updateBill(item.ID, widget.currentUser.Permission, "Approved", commentsCtrl.text);
                              if(status=="Success"){

                                showMessage("Successfully updated expense");
                              }
                              else{
                                showMessage("Failed to update expense");
                              }
                              commentsCtrl.clear();
                              widget.callback();
                              // print(_selected);
                              fetchClaims(_selected!);
                              // setState(() {
                              //   refresh=true;
                              // });

                            },
                            child: Container(
                              width: w/4,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.buttonColorDark,
                              ),

                              // padding: const EdgeInsets.all(14),
                              child: const Center(child: Text("Approve",style: TextStyle(color: Colors.white),)),
                            ),
                          ),
                          TextButton(
                            onPressed: () async{

                              String status = await apiServices().updateBill(item.ID, widget.currentUser.Permission, "Rejected", commentsCtrl.text);
                              if(status=="Success"){
                                showMessage("Successfully updated expense");
                              }
                              else{
                                showMessage("Failed to update expense");
                              }
                              commentsCtrl.clear();
                              widget.callback();
                              fetchClaims(DateTime.now());
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: w/4,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.buttonColorDark,
                              ),
                              // color: AppColors.buttonColorDark,
                              // padding: const EdgeInsets.all(14),
                              child: Center(child: const Text("Reject",style: TextStyle(color: Colors.white))),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
              ):const SizedBox(),

              //if status id Approved

              item.Status=="Approved"?const SizedBox(height: 10,):const SizedBox(),
              (item.Status=="Approved" && (widget.currentUser.Permission=='Admin' || widget.currentUser.Department=='Finance'))?SizedBox(
                  child: Column(
                    children: [
                      Text("Finance Clearence",style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      FieldArea(title: "Comments",type: TextInputType.text,ctrl: commentsCtrl,len: 50,),
                      // TextFormField(
                      //   enabled: true,
                      //   controller: commentsCtrl,
                      //   // keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     // prefixIcon: Icon(Icons.phone),
                      //     fillColor: Colors.white,
                      //     filled: true,
                      //     hintText: "Comments",
                      //     enabled: true,
                      //     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //       borderSide: BorderSide(color: Colors.blue.shade900),
                      //     ),
                      //
                      //   ),
                      // ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () async{
                            if(commentsCtrl.text==""){
                              showMessage("Invalid remarks entry");
                              return;
                            }
                            List<String> idList = [_id];
                            String status = await apiServices().clearBill(idList, widget.currentUser.Permission, item.Status=="Cleared"?"Approved":"Cleared", commentsCtrl.text);
                            if(status=="Success"){

                              showMessage("Successfully updated expense");
                            }
                            else{
                              showMessage("Failed to update expense");
                            }
                            commentsCtrl.clear();
                            widget.callback();
                            fetchClaims(_selected!);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: w/4,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.buttonColorDark,
                            ),

                            // padding: const EdgeInsets.all(14),
                            child: Center(child: Text(item.Status=="Cleared"?"Reverse":"Clear",style: TextStyle(color: Colors.white),)),
                          ),
                        ),
                      ),
                    ],
                  )
              ):const SizedBox(),


              const SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }

  // Future showApprovalBox(){
  //   return showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(15.0),
  //       ),
  //       title: const Text("Action required"),
  //       // content: const Text("Are you sure to send regularize request?"),
  //       content: SizedBox(
  //         width: w-50,
  //         child: TextFormField(
  //           enabled: true,
  //           controller: commentsCtrl,
  //           // keyboardType: TextInputType.number,
  //           decoration: InputDecoration(
  //             // prefixIcon: Icon(Icons.phone),
  //             fillColor: Colors.white,
  //             filled: true,
  //             hintText: "Comments",
  //             enabled: true,
  //             // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(8.0),
  //               borderSide: BorderSide(color: Colors.blue.shade900),
  //             ),
  //
  //           ),
  //         ),
  //       ),
  //       actions: <Widget>[
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             TextButton(
  //               onPressed: () async{
  //
  //                 String status = await apiServices().updateBill(_id, widget.currentUser.Permission, "Approved", commentsCtrl.text);
  //                 if(status=="Success"){
  //
  //                   showMessage("Successfully updated expense");
  //                 }
  //                 else{
  //                   showMessage("Failed to update expense");
  //                 }
  //                 commentsCtrl.clear();
  //                 widget.callback();
  //                 fetchClaims(DateTime.now());
  //                 Navigator.of(ctx).pop();
  //               },
  //               child: Container(
  //                 width: w/4,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(20),
  //                   color: AppColors.buttonColorDark,
  //                 ),
  //
  //                 padding: const EdgeInsets.all(14),
  //                 child: Center(child: const Text("Approve",style: TextStyle(color: Colors.white),)),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () async{
  //
  //                 String status = await apiServices().updateBill(_id, widget.currentUser.Permission, "Rejected", commentsCtrl.text);
  //                 if(status=="Success"){
  //                   showMessage("Successfully updated expense");
  //                 }
  //                 else{
  //                   showMessage("Failed to update expense");
  //                 }
  //                 commentsCtrl.clear();
  //                 widget.callback();
  //                 fetchClaims(DateTime.now());
  //                 Navigator.of(ctx).pop();
  //               },
  //               child: Container(
  //                 width: w/4,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(20),
  //                   color: AppColors.buttonColorDark,
  //                 ),
  //                 // color: AppColors.buttonColorDark,
  //                 padding: const EdgeInsets.all(14),
  //                 child: Center(child: const Text("Reject",style: TextStyle(color: Colors.white))),
  //               ),
  //             ),
  //
  //           ],
  //         ),
  //         Container(
  //           child: Center(
  //             child: TextButton(
  //               onPressed: () async{
  //                 commentsCtrl.clear();
  //                 Navigator.of(ctx).pop();
  //               },
  //               child: Container(
  //                 width: w/2,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(20),
  //                   color: AppColors.buttonColorDark,
  //                 ),
  //                 // color: AppColors.buttonColorDark,
  //                 padding: const EdgeInsets.all(14),
  //                 child: Center(child: const Text("Cancel",style: TextStyle(color: Colors.white))),
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }

  Future showClearenceBox(String stat){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text("Finance Clearence"),
        // content: const Text("Are you sure to send regularize request?"),
        content: SizedBox(
          width: w-50,
          child: TextFormField(
            enabled: true,
            controller: commentsCtrl,
            // keyboardType: TextInputType.number,
            decoration: InputDecoration(
              // prefixIcon: Icon(Icons.phone),
              fillColor: Colors.white,
              filled: true,
              hintText: "Comments",
              enabled: true,
              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blue.shade900),
              ),

            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () async{
                  if(commentsCtrl.text==""){
                    showMessage("Invalid remarks entry");
                    return;
                  }
                  List<String> idList = [_id];
                  String status = await apiServices().clearBill(idList, widget.currentUser.Permission, stat=="Cleared"?"Approved":"Cleared", commentsCtrl.text);
                  if(status=="Success"){

                    showMessage("Successfully updated expense");
                  }
                  else{
                    showMessage("Failed to update expense");
                  }
                  commentsCtrl.clear();
                  widget.callback();
                  fetchClaims(_selected!);
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  width: w/4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.buttonColorDark,
                  ),

                  padding: const EdgeInsets.all(14),
                  child: Center(child: Text(stat=="Cleared"?"Reverse":"Clear",style: TextStyle(color: Colors.white),)),
                ),
              ),
              TextButton(
                onPressed: () async{
                  commentsCtrl.clear();
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  width: w/4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.buttonColorDark,
                  ),
                  // color: AppColors.buttonColorDark,
                  padding: const EdgeInsets.all(14),
                  child: Center(child: const Text("Cancel",style: TextStyle(color: Colors.white))),
                ),
              ),

            ],
          ),


        ],
      ),
    );
  }





  Widget billText(String title, String value){
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          const SizedBox(width: 20,),
          SizedBox(
              width: w/4,
              // height: 10,
              // color: Colors.grey,
              child:Text("$title: ",style: TextStyle(fontSize: 12),)
          ),
          Expanded(
            child: Text(value,style: TextStyle(fontSize: 12),),
          )
        ],
      ),
    );
  }


  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

}