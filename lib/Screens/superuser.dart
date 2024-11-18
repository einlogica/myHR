import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';
import 'homePage.dart';

class superUser extends StatefulWidget {
  final userModel currentUser;
  const superUser({super.key,required this.currentUser});

  @override
  State<superUser> createState() => _superUserState();
}

class _superUserState extends State<superUser> {

  var w=0.00,h=0.00,t=0.00;
  List<userModel> adminList = [];

  @override
  void initState() {
    // TODO: implement initState
    getList();
    super.initState();
  }

  void getList()async{
    adminList = await apiServices().getUserDetails(widget.currentUser.Mobile, "SUPER");
    print(adminList.toString());
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
      body: Column(
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
                      const SizedBox(
                        width: 60,
                        height: 40,
                      ),
                      Text("Super User",style: const TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
                            width:80,
                            height:50,
                            child: Icon(Icons.exit_to_app,color: Colors.white,)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: w,
            height: h-60-t,
            child: adminList.isEmpty?SizedBox():ListView.builder(
                padding: EdgeInsets.only(bottom: 50),
                itemCount: adminList.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      apiServices().setEmp(adminList[index].Employer);
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return homePage(currentUser:adminList[index]);
                      }));
                    },
                    child: Padding(
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
                        child: ListTile(
                          title: Text(adminList[index].Name),
                          subtitle: Text(adminList[index].Employer),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
