import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:flutter/material.dart';
import 'package:einlogica_hr/Models/leaveModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

import '../../Widgets/loadingWidget.dart';

class leaveApprovalPage extends StatefulWidget {

  final userModel currentUser;
  final Function callback;
  const leaveApprovalPage({super.key, required this.currentUser,required this.callback});

  @override
  State<leaveApprovalPage> createState() => _leaveApprovalPageState();
}

class _leaveApprovalPageState extends State<leaveApprovalPage> {

  var w=0.00,h=0.00,t=0.00;

  List<leaveModel> leaveList = [];
  List<leaveModel> approvedList = [];
  List<leaveModel> pendingList = [];
  bool approved = false;
  String _id = "";
  TextEditingController commentsCtrl = TextEditingController();
  TextEditingController searchCtrl = TextEditingController();
  List<String> pendingId = [];
  String _sel = DateTime?.now().year.toString();
  final int startYear = 2020;
  int endYear = DateTime.now().year;
  DateTime? _selected;
  bool _loading=true;


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
    fetchLeaves(DateTime.now().year.toString());

    searchCtrl.addListener(() {

      filterList(leaveList, searchCtrl.text);
      setState(() {

      });

    });
  }




  fetchLeaves(String year)async{
    // print("fetching leaves list");
    leaveList.clear();
    approvedList.clear();
    pendingList.clear();
    if(widget.currentUser.Permission=="Admin"){
      leaveList=await apiServices().getLeaves(widget.currentUser.Mobile, "ALL",year,"0");
    }
    else{
      leaveList=await apiServices().getLeaves(widget.currentUser.Mobile, "MAN",year,"0");
    }
    for (var d in leaveList){
      if(d.Status=="Approved" || d.Status=="Rejected"){
        approvedList.add(d);
      }
      else{
        // print(d.Name);
        pendingList.add(d);
      }
    }
    setState(() {
      _loading=false;
    });

  }


  filterList(List<leaveModel> userExpenseList,String filter){

    approvedList.clear();
    pendingList.clear();
    for (var d in userExpenseList){

      if(filter!=""){
        if(d.Name.toLowerCase().contains(filter.toLowerCase())) {
          if (d.Status == "Approved" || d.Status == "Rejected" || d.Status == 'Cleared') {
            approvedList.add(d);
          }
          else {
            pendingList.add(d);
          }
        }
      }
      else{
        if(d.Status=="Approved" || d.Status=="Rejected" || d.Status=='Cleared'){
          approvedList.add(d);
        }
        else{
          pendingList.add(d);
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
                            const Text("Leave Approval",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            InkWell(
                              onTap: ()async{
                                _showYearPicker(context);
                                if(_selected!=null){
                                  // fetchData(_selected);
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
                FieldArea(title: "Search", ctrl: searchCtrl, type: TextInputType.text, len: 20),
                const SizedBox(height: 5,),
                SizedBox(
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

                Expanded(
                    child:leaves(),
                ),

                pendingId.isNotEmpty?Container(
                  width: w,
                  height: 50,
                  color: Colors.black.withOpacity(.6),
                  child: Center(
                    child: SizedBox(
                      width: w,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: ()async{
                              setState(() {
                                _loading=true;
                              });
                              String status = await apiServices().updateLeave(pendingId, widget.currentUser.Permission, "Approved", "Approved");
                              pendingId.clear();
                              showMessage(status);
                              widget.callback();
                              fetchLeaves(DateTime.now().year.toString());
                              setState(() {
                                _loading=false;
                              });
                            },
                            child: const Text("Approve All"),
                          ),
                          ElevatedButton(
                            onPressed: ()async{
                              String status = await apiServices().updateLeave(pendingId, widget.currentUser.Permission, "Rejected", "Rejected");
                              pendingId.clear();
                              showMessage(status);
                              widget.callback();
                              fetchLeaves(DateTime.now().year.toString());
                            },
                            child: const Text("Reject All"),
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
                  ),
                ):const SizedBox(),
              ],
            ),
          ),
          _loading?loadingWidget():const SizedBox()
        ],
      ),
    );
  }

  Widget leaves(){
    return Center(
      child: Column(
        children: [

          Expanded(
            child: SizedBox(
              width: w-20,

              child: (approved && approvedList.isEmpty) || (!approved && pendingList.isEmpty)?const Center(
                child: Text("Nothing to display"),
              ):ListView.builder(
                  padding: EdgeInsets.only(bottom: 50),
                  itemCount: approved?approvedList.length:pendingList.length,
                  itemBuilder: (context,index){
                    var item = approved?approvedList[index]:pendingList[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onLongPress: (){
                          if(!approved){
                            // print(pendingList[index].Id);
                            pendingId.add(pendingList[index].Id);
                            setState(() {

                            });
                          }
                        },
                        onTap: (){
                          if(pendingId.isNotEmpty){
                            if(pendingId.contains(pendingList[index].Id)){
                              pendingId.remove(pendingList[index].Id);
                            }
                            else{
                              pendingId.add(pendingList[index].Id);
                            }
                            setState(() {

                            });
                          }
                        },
                        child: Container(
                          width: w-20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: !approved?pendingId.contains(pendingList[index].Id)?Colors.green.shade100:Colors.white:Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: w-20,
                            // height: 200,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  // height: 180,
                                  child: Center(child: item.Days==.5?Image.asset('assets/halfday.png',scale: 15,):Image.asset('assets/fullday.png',scale: 15,)),
                                ),
                                // Container(
                                //     height: 180,
                                //     width: 2,
                                //     child: VerticalDivider(thickness: 1,color: Colors.black,)),
                                Expanded(
                                  child: SizedBox(
                                    // height: 180,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SizedBox(height: 10,),
                                        Text(item.Name,style: const TextStyle(fontSize: 16,color: AppColors.buttonColorDark,fontWeight: FontWeight.bold),),
                                        // const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item.LeaveDate,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                            Text(item.Status,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: item.Status=="Approved"?Colors.green:Colors.orange),),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                                width:w/3,
                                                child:SingleChildScrollView(
                                                    scrollDirection:Axis.horizontal,
                                                    child: Text(item.Comments,style: const TextStyle(fontSize: 16),))),
                                            Text(item.LOP<0?"LOP":"",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                                          ],
                                        ),
                                        item.L1Status==""?const SizedBox():const SizedBox(height: 10,),
                                        item.L1Status==""?const SizedBox():Text("Manager: ${item.L1Status}",style: const TextStyle(fontSize: 16),),
                                        item.L1Comments==""?const SizedBox():Text("Comments: ${item.L1Comments}",style: const TextStyle(fontSize: 16),),
                                        item.L2Status==""?const SizedBox():const SizedBox(height: 10,),
                                        item.L2Status==""?const SizedBox():Text("Admin: ${item.L2Status}",style: const TextStyle(fontSize: 16),),
                                        item.L2Comments==""?const SizedBox():Text("Comments: ${item.L2Comments}",style: const TextStyle(fontSize: 16),),
                                        const SizedBox(height: 10,),
                                      ],
                                    ),
                                  ),
                                ),
                                // Container(
                                //     height: 180,
                                //     width: 2,
                                //     child: VerticalDivider(thickness: 1,color: Colors.black,)),
                                SizedBox(
                                  width: 60,
                                  // height: 180,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      item.Status=="Cancel Req"?SizedBox(
                                        width:60,
                                        height: 60,
                                        child: Center(
                                          child: InkWell(
                                            onTap: ()async{
                                              setState(() {
                                                _loading=true;
                                              });
                                              await showDialogBox(item.Id);
                                              await fetchLeaves(DateTime.now().year.toString());
                                              setState(() {
                                                _loading=false;
                                              });
                                            },
                                            child: const SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Icon(Icons.delete,color: AppColors.buttonColor)),
                                          ),
                                        ),
                                      ):Container(),
                                      SizedBox(
                                        width:60,
                                        height: 60,
                                        child: Center(
                                          child: InkWell(
                                            onTap: (){
                                              _id=item.Id;
                                              showApprovalBox(item.Status=='Approved'?false:true);

                                            },
                                            child: const SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Icon(Icons.arrow_forward_ios_rounded,color: AppColors.buttonColor)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),

        ],
      ),
    );
  }


  Future showDialogBox(String id){
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
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure to delete this leave request? \nLeave count will be modified in respective account"),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                String status = await apiServices().deleteLeave(id,"MAN");
                showMessage(status);
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
      ),
    );
  }

  Future showApprovalBox(bool approve){
    return showDialog(
      context: context,
      builder: (ctx) => Center(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text("Action required"),
          // content: const Text("Are you sure to send regularize request?"),
          content: TextFormField(
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
          actions: <Widget>[
            approve?TextButton(
              onPressed: () async{
                List<String> _idList = [];
                _idList.add(_id);
                String status = await apiServices().updateLeave(_idList, widget.currentUser.Permission, "Approved", commentsCtrl.text);
                if(status=="Success"){
                  showMessage("Successfully updated leave");
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully updated leave")));
                }
                else{
                  showMessage("Failed to update leave");
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update leave")));
                }
                commentsCtrl.clear();
                widget.callback();
                fetchLeaves(DateTime.now().year.toString());
                Navigator.of(ctx).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.buttonColorDark,
                ),

                padding: const EdgeInsets.all(14),
                child: const Text("Approve",style: TextStyle(color: Colors.white),),
              ),
            ):SizedBox(),
            TextButton(
              onPressed: () async{
                List<String> _idList = [];
                _idList.add(_id);
                String status = await apiServices().updateLeave(_idList, widget.currentUser.Permission, "Rejected", commentsCtrl.text);
                if(status=="Success"){
                  showMessage("Successfully updated leave");
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully updated leave")));
                }
                else{
                  showMessage("Failed to update leave");
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update leave")));
                }
                commentsCtrl.clear();
                widget.callback();
                fetchLeaves(DateTime.now().year.toString());
                Navigator.of(ctx).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.buttonColorDark,
                ),
                // color: AppColors.buttonColorDark,
                padding: const EdgeInsets.all(14),
                child: const Text("Reject",style: TextStyle(color: Colors.white)),
              ),
            ),

          ],
        ),
      ),
    );
  }

  _showYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Select a Year')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SizedBox(
            height: 180,
            width: w/2-20,

            // width: double.maxFinite,
            child: ListView.builder(
              itemCount: endYear - startYear + 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Center(child: Text('${endYear-index}')),
                  onTap: () {
                    // Do something with the selected year
                    int year = endYear-index;
                    _sel=year.toString();
                    // print('Selected Year: $_sel');
                    fetchLeaves(_sel);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
  }

}

