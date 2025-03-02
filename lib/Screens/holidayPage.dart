

import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/eventsModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';

class holidayPage extends StatefulWidget {

  final String permission;
  const holidayPage({super.key, required this.permission});

  @override
  State<holidayPage> createState() => _holidayPageState();
}

class _holidayPageState extends State<holidayPage> {

  var w=0.00,h=0.00,t=0.00;
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  List<eventsModel> holidayList=[];
  bool _loading=true;
  DateTime? _selected =DateTime.now();

  @override
  void dispose() {
    // TODO: implement dispose
    _titleCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData()async{
    holidayList = await apiServices().getHoliday();
    // print(policyList);
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
      floatingActionButton:widget.permission=='Admin'?FloatingActionButton(
        backgroundColor: AppColors.buttonColorDark,
        onPressed: (){
          showDialogBox();
        },
        child: const Icon(Icons.add_circle_outline,color: Colors.white,),
      ):const SizedBox(),
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
                            const Text("Holiday Calender",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: DataTable(
                      columnSpacing: 20,
                      columns: [
                        const DataColumn(label: Text('Date')),
                        const DataColumn(label: Text('Day')),
                        const DataColumn(label: Text('Event')),
                        widget.permission=="Admin"?const DataColumn(label: Text('Actions')):const DataColumn(label:Text("")),
                        // DataColumn(label: Text('Action')),
                      ],
                      rows: holidayList.map((model) {
                        return DataRow(
                          cells: [
                            DataCell(Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(model.date)))),
                            DataCell(Text(DateFormat('EEEE').format(DateTime.parse(model.date)))),
                            // DataCell(Text('${DateFormat('MMM').format(DateTime(2023,model.Month))} ${model.Year.toString()}')),
                            // DataCell(Text(model.Year.toString())),
                            DataCell(Text(model.title)),
                            widget.permission=="Admin"?DataCell(
                              Center(
                                child: InkWell(
                                  child: const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Icon(Icons.delete,size: 20,),
                                  ),
                                  onTap: ()async{
                                    String status = await apiServices().deleteHoliday(model.id);
                                    showMessage(status);
                                    fetchData();
                                  },
                                ),
                              )
                            ):const DataCell(Text("")),
                            // widget.permission=="Admin"?DataCell(
                            //     ElevatedButton(onPressed:()async{
                            //       String status = await apiServices().deleteHoliday(model.id);
                            //       showMessage(status);
                            //       fetchData();
                            //     }, child: const Icon(Icons.delete,size: 20,),
                            //   style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                            // )):const DataCell(Text("")),

                          ],
                        );
                      }).toList(),
                    ),
                  ),
                )

              ],
            ),
          ),
          _loading?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }



  Future showDialogBox(){
    return showDialog(
      context: context,
      builder: (ctx) => Container(
        width: w-20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: AlertDialog(
          // backgroundColor: AppColors.boxColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text("Add Holiday"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FieldArea("Event",_titleCtrl,TextInputType.text),
              const SizedBox(height: 20,),
              SizedBox(
                width: w-20,
                height: 50,
                // color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: w*.15,
                      // color: Colors.green,
                      child: const Text("Date :",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                        width: w*.3,
                        child: TextFormField(

                          enabled: false,
                          controller: _dateCtrl,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.password),
                            // hintText: "Pin",

                            filled: true,
                            fillColor: Colors.white,
                            enabled: true,
                            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        )
                    ),
                    SizedBox(
                        width: w*.15,
                        child: ElevatedButton(
                          onPressed: ()async{
                            _selected = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), //get today's date
                                firstDate:DateTime(2022), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2030)
                            );
                            _dateCtrl.text=DateFormat('yyyy-MM-dd').format(_selected!);
                          },
                          child: const Icon(Icons.calendar_month_sharp),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async{

                String status = await apiServices().postHoliday(_titleCtrl.text, _dateCtrl.text);
                showMessage(status);
                fetchData();
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
                _titleCtrl.clear();
                _dateCtrl.clear();
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

  Widget FieldArea(String title,TextEditingController ctrl,TextInputType type){
    return SizedBox(
      width: w-20,
      height: 50,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: w*.15,
            // color: Colors.green,
            child: Text("$title :",style: const TextStyle(fontWeight: FontWeight.bold),),
          ),
          SizedBox(
              width: w*.5,
              child: TextFormField(
                keyboardType: type,
                enabled: true,
                controller: ctrl,
                decoration: InputDecoration(
                  // icon: Icon(Icons.password),
                  // hintText: "Pin",

                  filled: true,
                  fillColor: Colors.white,
                  enabled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )
          ),
        ],
      ),
    );
  }



  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }




}

