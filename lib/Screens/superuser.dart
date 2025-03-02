import 'package:einlogica_hr/Models/userModel.dart';
// import 'package:einlogica_hr/Widgets/loadingWidget.dart';
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
  // bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    getList();
    super.initState();
  }

  void getList()async{
    adminList = await apiServices().getUserDetails(widget.currentUser.Mobile, "SUPER");
    // print(adminList.toString());
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
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
                            width:80,
                            height:50,
                            child: Icon(Icons.arrow_back,color: Colors.white,)
                        ),
                      ),
                      const Text("myHR Accounts",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                      const SizedBox(
                        width: 60,
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          adminList.isEmpty?const CircularProgressIndicator():SizedBox(
            width: w,
            height: h-60-t,
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                itemCount: adminList.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      apiServices().setEmp(adminList[index].Employer);
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return homePage(currentUser:adminList[index],superAdmin: true,);
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
                              color: Colors.black.withValues(alpha: .3),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(adminList[index].Name,style: const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                          subtitle: Text(adminList[index].Employer),
                          trailing: const Icon(Icons.arrow_forward_ios_sharp),
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
