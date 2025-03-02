import 'package:flutter/material.dart';
import 'package:einlogica_hr/Models/directoryModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class directoryPage extends StatefulWidget {


  const directoryPage({super.key});

  @override
  State<directoryPage> createState() => _directoryPageState();
}

class _directoryPageState extends State<directoryPage> {

  var w=0.00,h=0.00,t=0.00;
  final TextEditingController _nameCtrl= TextEditingController();
  List<directoryModel> searchList = [];
  List<directoryModel> dirList = [];
  bool _loading=true;


  @override
  void dispose() {
    // TODO: implement dispose
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAll();
  }

  fetchAll()async{
    dirList.clear();
    dirList = await apiServices().searchDirectory('');
    searchList=dirList;
    setState(() {
      _loading=false;
    });
  }

  fetchData(String filter)async{
      searchList.clear();
      searchList = await apiServices().searchDirectory(filter);
      setState(() {
        _loading=false;
      });
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
                            const Text("Employee Directory",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
                const SizedBox(height: 10,),
                SizedBox(
                  width: w-20,
                  height: 60,
                  // color: Colors.green,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        SizedBox(
                          width: w-100,
                          // height: 80,
                          // color: Colors.white,
                          child: TextFormField(
                            enabled: true,
                            controller: _nameCtrl,

                            // keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              // prefixIcon: Icon(Icons.phone),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Name/Department/Position/Mobile",
                              enabled: true,
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.blue.shade900),
                              ),

                            ),
                          ),
                        ),
                        InkWell(
                          onTap: ()async{
                            if(_nameCtrl.text!=""){
                              setState(() {
                                _loading=true;
                              });
                              fetchData(_nameCtrl.text);
                              _nameCtrl.clear();
                              setState(() {
                                _loading=false;
                              });
                            }
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.buttonColorDark
                            ),
                            child: const Icon(Icons.search,color: Colors.white,),

                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: searchList.isEmpty?const Center(child: Text("Nothing to display"),):ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: searchList.length,
                      itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: w-50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          title: Text(searchList[index].Name),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(searchList[index].Mobile),
                              Text(searchList[index].Position,style: TextStyle(fontSize: 12),),
                            ],
                          ),
                          leading: const SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(child: Icon(Icons.person),),
                          ),
                          trailing: InkWell(
                            onTap: ()async{

                              final Uri phone = Uri(scheme: 'tel', path: searchList[index].Mobile);
                              if(await canLaunchUrl(phone)){
                                await launchUrl(phone);
                              }
                            },
                            child: const SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(child: Icon(Icons.call)),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
                  ),

              ],
            ),
          ),
          _loading?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }
}

