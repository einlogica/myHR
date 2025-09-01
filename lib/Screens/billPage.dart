import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:einlogica_hr/Screens/upload_bill.dart';
import 'package:einlogica_hr/Models/userExpenseModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../Widgets/imageViewer.dart';

Uint8List newImage=Uint8List(0);
bool imageDownloaded=false;
bool refresh =false;
bool clearPressed=false;
bool delPressed=false;
bool editPressed=false;
String buttonValue="";
String selectedID="";
String selectedStatus="";


TextEditingController commentsCtrl = TextEditingController();

class billPage extends StatefulWidget {
  const billPage({super.key,required this.mobile,required this.name,required this.permission,required this.HLP});

  final String mobile;
  final String name;
  final String permission;
  final String HLP;

  @override
  State<billPage> createState() => _billPageState();
}

class _billPageState extends State<billPage> {

  var w=0.00,h=0.00,t=0.00,b=0.00;
  double cleared=0,pending=0,rejected=0,advance=0,salary=0;
  List<userExpenseModel> userExpenseList=[];
  bool addBillPressed = false;
  bool expenseCardPressed = false;
  userExpenseModel userItem = userExpenseModel(ID: "", Mobile: "",Name: "", Site: "",LabourName: "",LabourCount: "",Duration: "", FromLoc: "", ToLoc: "", KM: "", Date: "", Type: "",Item:"", ShopName: "",ShopDist: "",ShopPhone: "",ShopGst: "" ,BillNo: "", Amount: "", Filename: "", Status: "", L1Status: "", L1Comments: "", L2Status: "", L2Comments: "",FinRemarks: "");
  // List<billerModel> selectedBiller = [];
  DateTime? _selected=DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh =true;
    fetchBills(_selected);
  }

  CallBack(){
    fetchBills(_selected);
  }

  imageViewerCallback(){
    setState(() {
      imageDownloaded=false;
    });
  }

  fetchBills(DateTime? _sel)async{
    userExpenseList = await apiServices().getUserExpenses(widget.mobile,_sel!.month.toString(),_sel.year.toString(),"EMP");
    cleared=0;pending=0;rejected=0;advance=0;salary=0;
    double bal = await apiServices().getPreExpenses(widget.mobile,_sel.month.toString(),_sel.year.toString(),"EMP");
    // print("Balance = $bal");
    for (var d in userExpenseList){
      // if(d.Status=="Approved" && d.Type!='Advance' && d.Type!='Salary Advance'){
      //   cleared=cleared+double.parse(d.Amount);
      // }
      // else
      if(d.Type=='Advance'){
        advance=advance+double.parse(d.Amount);
      }
      else if(d.Type=='Salary Advance'){
        salary=salary+double.parse(d.Amount);
      }
      else if(d.Status!="Rejected"){
        pending=pending+double.parse(d.Amount);
      }
    }
    advance=advance+bal;


    setState(() {
      refresh=false;
    });
  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;
    b=MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.teal,
      //   onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(builder: (context){
      //       return upload_bill(mobile: widget.mobile,name:widget.name,permission: widget.permission,callback: fetchBills,);
      //     }));
      //   },
      //   child: Icon(Icons.add_circle_outline),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        height: h-b,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: w,
                  // height: h,
                  height: 120+t,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
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
                        width:w,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                Navigator.pop(context);
                              },
                              child: const SizedBox(
                                width: 60,
                                height: 40,
                                child: Center(child: Icon(Icons.arrow_back,size: 20,color: Colors.white),),
                              ),
                            ),
                            const Text("Expense Tracker",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold)),
                            InkWell(
                              onTap: ()async{
                                _selected = await showMonthYearPicker(

                                  context: context,
                                  initialDate: _selected ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                  // locale: localeObj,
                                );
                                if(_selected!=null){
                                  fetchBills(_selected);
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
                      SizedBox(
                        width: w,
                        height: 60,

                        child: Center(
                          child: Container(
                            width: w-30,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(width: 1,color: Colors.black)
                            ),
                            // color: Colors.green.shade300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Container(
                                //   width: w-20,
                                //   height: 30,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                //     color: Colors.green,
                                //   ),
                                //
                                //   child: Center(child: Text("Summary",style: TextStyle(fontWeight: FontWeight.bold),),),
                                // ),
                                SizedBox(
                                  width: w-20,
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        // width: w/3,
                                        height: 20,
                                        child: Center(child: Text("Advance: $advance",style: const TextStyle(fontWeight: FontWeight.bold),),),
                                      ),
                                      SizedBox(
                                        // width: w/3,
                                        height: 20,
                                        child: Center(child: Text("Salary Adv: $salary",style: const TextStyle(fontWeight: FontWeight.bold),),),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: w-20,
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        // width: w/3,
                                        height: 20,
                                        child: Center(child: Text("Expense: $pending",style: const TextStyle(fontWeight: FontWeight.bold),),),
                                      ),
                                      SizedBox(
                                        // width: w/3,
                                        height: 20,
                                        child: Center(child: Text("Balance: ${pending-advance}",style: const TextStyle(fontWeight: FontWeight.bold),),),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // SizedBox(height: 50,)
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: w,
                    // height: widget.permission=="admin"?h-100:h,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: userExpenseList.length,
                        itemBuilder: (context,int index){
                          // print(index);
                          var item=userExpenseList[userExpenseList.length-index-1];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: ()async{
                                // if(widget.permission!="MAN"){
                                //   // if(item.Type=="Purchase"){
                                //   //   selectedBiller.clear();
                                //   //   selectedBiller = await apiServices().getBiller(item.Site,"ID");
                                //   // }
                                //   setState(() {
                                //     userItem=item;
                                //     expenseCardPressed=true;
                                //   });
                                // }
                                setState(() {
                                  userItem=item;
                                  expenseCardPressed=true;
                                });

                              },
                              child: Container(
                                width: w-20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: const [BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 2,
                                      spreadRadius: 3,
                                      offset: Offset(0.0, 2,),
                                    ),
                                    ]
                                ),
                                child: ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item.Type,style: const TextStyle(fontWeight: FontWeight.bold),),
                                        Text(item.Date,style: const TextStyle(fontSize: 14),)
                                      ],
                                    ),
                                    // trailing: Container(
                                    //   width: 80,
                                    //   height: 40,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(5),
                                    //       color: AppColors.boxColor
                                    //   ),
                                    //   child: Center(child: Text(item.Amount)),
                                    // ),
                                    subtitle: SizedBox(child: Row(
                                      children: [
                                        Text(item.Status,style: TextStyle(fontSize: 14,color: item.Status=="Approved"?Colors.green:Colors.orange),),
                                        const Spacer(),
                                        Container(
                                          width: 80,
                                          // height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: AppColors.boxColor
                                          ),
                                          child: Center(child: Text("${item.Amount}/-",style: const TextStyle(fontWeight: FontWeight.bold),)),
                                        ),
                                      ],
                                    )),
                                    leading: InkWell(
                                      onTap: ()async{
                                        setState(() {
                                          refresh=true;
                                        });

                                        newImage=await apiServices().getBill(item.Filename,"Bill");
                                        // print(newImage.toString());

                                        setState(() {
                                          refresh=false;
                                          // imageDownloaded=true;
                                        });
                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                          return imageViewer(imagefile: newImage, mobile: widget.mobile,download: true,);
                                        }));
                                      },
                                      child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Center(child: Icon(Icons.receipt,color: item.Filename.length>10?Colors.green:Colors.grey,))),
                                    )
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
                widget.permission!="MAN"?SizedBox(
                  width: w,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark),shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        )
                    )),
                    onPressed: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return upload_bill(mobile: widget.mobile,name:widget.name,callback: CallBack,);
                      }));
                    },
                    child: const Text("Add Bill",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                ):const SizedBox()

              ],
            ),
            expenseCardPressed?Container(
              width: w,
              height: h,
              color: Colors.black.withValues(alpha: .7),
              child: expenseCard(),
            ):const SizedBox(),

            // imageDownloaded?imageViewer(imagefile: newImage, mobile: widget.mobile,callback: imageViewerCallback,):SizedBox(),

            // imageDownloaded?Container(
            //   width: w,
            //   height: h,
            //   color: Colors.black,
            //   child: Center(
            //     child: SizedBox(
            //       width: w-50,
            //       height: h-50,
            //       child: PhotoView(
            //         imageProvider: Image.memory(newImage).image,
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
            //                 setState(() {
            //                   refresh=true;
            //                 });
            //                 String status = await savefile().downloadImage("${widget.mobile}-${DateTime.now().millisecond}.png" , newImage);
            //                 showMessage(status);
            //                 setState(() {
            //                   refresh=false;
            //                 });
            //             }, child: const Text("Download",style: TextStyle(color: Colors.white),)),
            //             ElevatedButton(
            //                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
            //                 onPressed: (){
            //               setState(() {
            //                 imageDownloaded=false;
            //               });
            //             }, child: const Text("Close",style: TextStyle(color: Colors.white),))
            //           ],
            //         ),
            //       ),
            //     )
            // ):SizedBox(),
            //

            delPressed?Container(
              width: w,
              height: h,
              color: Colors.black.withValues(alpha: .7),

              child: Center(
                child: Container(
                  width: w-100,
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color: Colors.black),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: w-100,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                        ),

                        child: const Center(child: Text("Confirm Deletion!!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                      ),
                      SizedBox(
                        width: w-100,
                        height: 50,
                        child: const Center(child: Text("Please confirm to delete this bill."),),
                      ),
                      SizedBox(
                        width: w-100,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: w/4,
                              height: 30,
                              child: ElevatedButton(
                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.teal)),
                                onPressed: (){
                                  setState(() {
                                    delPressed=false;
                                  });
                                },
                                child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                              ),
                            ),
                            SizedBox(
                              width: w/4,
                              height: 30,
                              child: ElevatedButton(
                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.teal)),
                                onPressed: ()async{
                                  setState(() {
                                    refresh=true;
                                  });
                                  String status = await apiServices().deleteBill(widget.mobile, selectedID);

                                  refresh=false;
                                  delPressed=false;
                                  expenseCardPressed=false;
                                  if(status=="Success"){
                                    fetchBills(_selected);
                                  }
                                  else{
                                    setState(() {
                                    });
                                  }

                                },
                                child: const Text("Delete",style: TextStyle(color: Colors.white),),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ):const SizedBox(),

            refresh?loadingWidget():const SizedBox(),

          ],
        ),
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
              child:Text("$title: ")
          ),
          Expanded(
            child: Text(value),
          )
        ],
      ),
    );
  }


  Widget expenseCard(){
    userExpenseModel item=userItem;
    // print(item.Type);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: w-50,
          // height: w,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const SizedBox(height: 20,),
                SizedBox(
                  width: w-20,
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
                                  color: AppColors.buttonColor
                              ),
                              child: Center(
                                child: Text("Rs ${item.Amount} /-",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                              ),
                            ),
                            SizedBox(
                              width: w/2,
                              child: Align(alignment: Alignment.centerRight,child: Text(item.Date,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black))),
                            )

                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        child: Column(

                          children: [
                          billText("Type", item.Type),
                          item.Item==""?const SizedBox():billText("Specify", item.Item),
                          item.Site==""?const SizedBox():billText(item.Type=="Advance" || item.Type=="Salary Advance"?"Via":"Location", item.Site),
                          item.Type=="Purchase"?Column(
                            children: [
                              item.ShopName==""?const SizedBox():billText("Shop", item.ShopName),
                              item.ShopDist==""?const SizedBox():billText("District", item.ShopDist),
                              item.ShopDist==""?const SizedBox():billText("GST", item.ShopGst),
                              item.ShopPhone==""?const SizedBox():billText("Phone", item.ShopPhone),
                            ],
                          ):const SizedBox(),
                          // item.FromLoc==""?Container():SizedBox(height: 5,),
                          item.LabourName==""?const SizedBox():billText("Labour Name", item.LabourName),
                          item.Duration==""?const SizedBox():billText("Duration", item.Duration),
                          item.FromLoc==""?const SizedBox():billText("From", item.FromLoc),
                          item.ToLoc==""?const SizedBox():billText("To", item.ToLoc),
                          item.KM.toString()=="0"?const SizedBox():billText("KM", item.KM),
                          item.L1Status==""?const SizedBox():billText("Manager", item.L1Status),
                          item.L1Comments==""?const SizedBox():billText("Comments", item.L1Comments),
                          item.L2Status==""?const SizedBox():billText("Admin", item.L2Status),
                          item.L2Comments==""?const SizedBox():billText("Comments", item.L2Comments),
                        ],),
                      ),

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
                const SizedBox(height: 20,),
                SizedBox(
                  width: w,
                  // height: 200,
                  // color: Colors.grey,
                  child: Row(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      (item.Status=="Applied" || widget.HLP=='Admin') && item.Type!="Salary Advance"?InkWell(
                        onTap:(){
                          // print(widget.HLP);
                          setState(() {
                            selectedID=item.ID;
                            delPressed=true;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.buttonColorDark,
                              boxShadow: const [BoxShadow(
                                color: Colors.black26,
                                blurRadius: 0.2,
                                spreadRadius: 0.2,
                                offset: Offset(0.0, 4.0,),
                              ),
                              ]
                          ),
                          child: const Icon(Icons.delete_outline,color: Colors.white,),
                        ),
                      ):const SizedBox(),
                      InkWell(
                        onTap:(){
                          setState(() {
                            expenseCardPressed=false;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.buttonColorDark,
                              boxShadow: const [BoxShadow(
                                color: Colors.black26,
                                blurRadius: 0.2,
                                spreadRadius: 0.2,
                                offset: Offset(0.0, 4.0,),
                              ),
                              ]
                          ),
                          child: const Center(child: Text("Close",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

}