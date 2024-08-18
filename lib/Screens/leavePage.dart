import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/classes/event.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/leaveModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Widgets/FieldArea.dart';

class leavePage extends StatefulWidget {

  final String mobile;
  final String name;
  final double leaveCount;
  // final String permission;
  const leavePage({super.key, required this.mobile,required this.name, required this.leaveCount});

  @override
  State<leavePage> createState() => _leavePageState();
}

class _leavePageState extends State<leavePage> {

  var w=0.0,h=0.0,t=0.0;
  bool leavePressed = false;
  DateTime _currentDate = DateTime.now();
  final TextEditingController _commentCtrl= TextEditingController();
  DateTime? _selected;
  String _sel = DateTime?.now().year.toString();
  String _selMonth = DateTime?.now().month.toString();
  final int startYear = 2023;
  int endYear = DateTime.now().year;
  bool halfDay=false;
  List<leaveModel> leaveList = [];
  int _index = 0;
  bool leaveCardPressed =false;
  double leaveApplied = 0.00;
  bool _loading=true;
  List<DateTime> dateList = [];
  List<String> dateList2 = [];
  String leaveStr="";
  final DateFormat dtformat=DateFormat("yyyy-mm-dd");
  double leaveCount=0.0;
  bool deletePressed=false;
  DateTime? _selectedMY = DateTime.now();

  @override
  void dispose() {
    // TODO: implement dispose
    _commentCtrl.dispose();
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData(_sel,_selMonth);
  }

  fetchData(String _selY, String _selM)async{
    // print("fetching data");

    leaveStr=await apiServices().getSettings("LeaveStructure");
    leaveList=await apiServices().getLeaves(widget.mobile, "EMP",_selY,_selM);
    leaveApplied=0.00;
    leaveCount=widget.leaveCount;
    // if(leaveStr=="MONTHLY"){
      // leaveCount=widget.leaveCount/12;
      for (var d in leaveList){
        // print(d.Days);
        if(d.Status!="Rejected"){
          leaveApplied=leaveApplied+d.Days;
        }
      }
    // }
    // else{
    //   // leaveCount=widget.leaveCount;
    //   for (var d in leaveList){
    //     // print(d.Days);
    //
    //     if(d.Status!="Rejected" && dtformat.parse(d.LeaveDate).month==DateTime.now().month){
    //       leaveApplied=leaveApplied+d.Days;
    //     }
    //   }
    // }


    setState(() {
      _loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {

    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        color:Colors.white,
        child: Stack(
          children: [
            Column(
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
                            const Text("Leave Management",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            InkWell(
                              onTap: ()async{

                                if(leaveStr=="YEARLY"){
                                  _showYearPicker(context);
                                }
                                else{
                                  _selectedMY = await showMonthYearPicker(
                                    context: context,
                                    initialDate: _selected ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                    // locale: localeObj,
                                  );
                                  // print("selected");
                                  if(_selectedMY!=null){
                                    setState(() {
                                      _loading=true;
                                    });
                                    await fetchData(_selectedMY!.year.toString(),_selectedMY!.month.toString());
                                  }
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
                const SizedBox(height: 10,),
                _sel==DateTime.now().year.toString()?SizedBox(
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: w/2.2,
                        // height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0XFFbba4e9),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.3),
                          //     spreadRadius: 2,
                          //     blurRadius: 2,
                          //     offset: Offset(0, 4),
                          //   ),
                          // ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: 5,),
                            Text(leaveCount-leaveApplied<0?"LOP":"Leave Balance",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            Text(leaveCount-leaveApplied<0?"${leaveApplied-leaveCount}":"${leaveCount-leaveApplied}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                            // const Text("Days"),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                      Container(
                        width: w/2.2,
                        // height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0XFFbba4e9),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.3),
                          //     spreadRadius: 2,
                          //     blurRadius: 2,
                          //     offset: Offset(0, 4),
                          //   ),
                          // ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: 5,),
                            const Text("Leave Applied",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            Text(leaveApplied.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                            // const Text("Days"),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):const SizedBox(),
                const SizedBox(height: 20,),
                Expanded(
                  child: SizedBox(
                    width: w-20,
                    // color: Colors.green,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 50),
                        itemCount: leaveList.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  _index=index;
                                  leaveCardPressed=true;

                                });
                              },
                              child: Container(
                                width: w-20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                child: ListTile(
                                  title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(leaveList[index].LeaveDate,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                        Text(leaveList[index].Status,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: leaveList[index].Status=="Rejected"?Colors.red:leaveList[index].Status=="Approved"?Colors.green:Colors.orange),),
                                      ],
                                    ),
                                  // subtitle: Text(leaveList[index].Comments,softWrap: true,style: TextStyle(fontSize: 16),),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(leaveList[index].Comments,softWrap: true,style: const TextStyle(fontSize: 16,color: Colors.blue),),
                                      Text(leaveList[index].LOP==0?"":"LOP : ${leaveList[index].LOP}",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                                    ],
                                  ),
                                  leading: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Center(child: leaveList[index].Days==.5?Image.asset('assets/halfday.png',scale: 15,):Image.asset('assets/fullday.png',scale: 15,)),
                                  ),

                                )
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(height: t,)
              ],
            ),
            AnimatedPositioned(
                // top:leavePressed?h-230-(w-40):h-40,
                top:leavePressed?h*.2:h-50,
                duration: const Duration(milliseconds: 500),
                child: SizedBox(
                  width: w,
                  // height: h-h/3,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: ()async{

                            setState(() {
                              dateList.clear();
                              dateList2.clear();
                              _commentCtrl.clear();
                              leavePressed=!leavePressed;
                            });
                        },
                        child: Container(
                          width: w/3,
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60)),
                            color: AppColors.buttonColorDark
                          ),
                          child: const Center(
                            child: Text("Apply Leave",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                          ),
                        ),
                      ),
                      Container(
                        width: w,
                        height: h-(h*.2)-40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppColors.themeStop,AppColors.themeStart]
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30,),
                              // Text("Add Comments"),
                              Center(
                                child: SizedBox(
                                  width: w-100,
                                  height: 80,
                                  // color: Colors.white,
                                  child: FieldArea(title: "Comments",type: TextInputType.text,ctrl: _commentCtrl,len: 50,),

                                ),
                              ),

                              calendar(),

                              SizedBox(
                                width: w-20,
                                height: 50,
                                child: dateList.length<2?Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 50,),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Checkbox(

                                        value: halfDay,
                                        onChanged: (value){
                                          halfDay= !halfDay;
                                          setState(() {

                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: w/4,
                                      // color: Colors.green,
                                      child: const Text("Half Day?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                    ),
                                  ],
                                ):SizedBox(
                                  child: Center(child: Text("Selected Days : ${dateList.length.toString()}",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),)),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              // Spacer(),
                              SizedBox(
                                width: w,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:w/2-1,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.transparent),shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                              )
                                          )),
                                          onPressed: ()async{
                                            // print(_currentDate);
                                            if(_commentCtrl.text==""){
                                              showMessage("Invalid entry");
                                              return;
                                            }
                                            else if(dateList.isEmpty){
                                              showMessage("Invalid date");
                                              return;
                                            }
                                            setState(() {
                                              _loading=true;
                                            });

                                            dateList.forEach((element) {dateList2.add(DateFormat('yyyy-MM-dd').format(element));});
                                            String status = await apiServices().applyLeave(widget.mobile,widget.name,dateList2, _commentCtrl.text, halfDay?0.5:dateList.length.toDouble());
                                            showMessage(status);
                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
                                            _commentCtrl.clear();
                                            halfDay=false;
                                            leavePressed=false;
                                            await fetchData(DateTime.now().year.toString(),DateTime.now().month.toString());
                                      }, child: const Text("Submit",style: TextStyle(color: Colors.white),)),
                                    ),
                                    SizedBox(
                                      width:w/2-1,
                                      height: 50,
                                      child: ElevatedButton(
                                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.transparent),shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                              )
                                          )
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              _commentCtrl.clear();
                                              leavePressed=false;
                                              dateList.clear();
                                              dateList2.clear();
                                              _currentDate=DateTime.now();
                                            });
                                      }, child: const Text("Cancel",style: TextStyle(color: Colors.white),)),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            leaveCardPressed?Container(
              width: w,
              height: h,
              color: Colors.black.withOpacity(.7),
              child: Center(
                child: leaveCard(_index),
              ),
            ):Container(),
            _loading?loadingWidget():const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget calendar(){
    // CalendarFormat _calendarFormat = CalendarFormat.month;
    // DateTime _focusedDay = DateTime.now();
    // DateTime? _selectedDay;
    return SizedBox(
      width: w-80,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TableCalendar(
            headerVisible: true,
            headerStyle: HeaderStyle(formatButtonVisible: false),
            pageJumpingEnabled: false,
            firstDay: DateTime(DateTime.now().year-1,01,01),
            lastDay: DateTime(DateTime.now().year+2,01,01),
            focusedDay: _currentDate,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle().copyWith(color: Colors.red),
            ),
            calendarStyle: const CalendarStyle(
              isTodayHighlighted: false,
              weekendTextStyle: TextStyle(color: Colors.white),
              defaultTextStyle: TextStyle(color: Colors.white),
              outsideDaysVisible: false,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {

                if (dateList.contains(day)) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),

            onDaySelected: (selectedDay, focusedDay) {
                // print(DateFormat('yyyy-MM-dd').format(selectedDay));
                // print(DateFormat.jmv(selectedDay));
                // print(selectedDay);

                _currentDate = selectedDay;
                focusedDay=_currentDate;
                print(_currentDate);
                if(dateList.contains(_currentDate)){
                  dateList.remove(_currentDate);
                }
                else{
                  dateList.add(_currentDate);
                  if(dateList.length>1){
                    halfDay=false;
                  }
                }
                // print(dateList);
                setState((){

                });
            },

          ),
        ),
      ),
    );

  }


  // Widget calendar() {
  //   return SizedBox(
  //     width: w,
      // color: Colors.white,
      // margin: EdgeInsets.symmetric(horizontal: 10.0),
//       child: Center(
//         child: CalendarCarousel<Event>(
//           // onDayPressed: (DateTime date, List<Event> events) {
//           //   this.setState(() => _currentDate = date);
//           // },
//           weekendTextStyle: const TextStyle(
//             color: Colors.yellowAccent,fontWeight: FontWeight.bold,
//           ),
//           daysTextStyle: const TextStyle(
//             color: Colors.white,fontWeight: FontWeight.bold,
//           ),
//           weekdayTextStyle: const TextStyle(
//             color: Colors.yellowAccent,fontWeight: FontWeight.bold,
//           ),
//           onDayPressed: (DateTime date, List<Event> events) {
//             setState((){
//               _currentDate = date;
//               if(dateList.contains(date)){
//                 dateList.remove(date);
//               }
//               else{
//                 dateList.add(date);
//                 if(dateList.length>1){
//                   halfDay=false;
//                 }
//               }
//               // print(dateList);
//             });
//           },
//           dayPadding: 5,
//           selectedDayButtonColor: Colors.transparent,
//           thisMonthDayBorderColor: Colors.black,
//           disableDayPressed: false,
//           showHeader: true,
//           headerTextStyle: const TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),
//           iconColor: Colors.white,
//           headerMargin: EdgeInsets.zero,
//           todayButtonColor: Colors.transparent,
//           todayBorderColor: Colors.black,
//           selectedDayBorderColor: Colors.black,
//           showOnlyCurrentMonthDate: true,
//           // headerTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),
//           showHeaderButton: true,
//
//           // targetDateTime: DateTime(currYear,currMonth),
//           // markedDatesMap: _markedDateMap,
//           isScrollable: false,
//           // pageScrollPhysics: NeverScrollableScrollPhysics(),
//           // customGridViewPhysics: NeverScrollableScrollPhysics(),
//
// //      weekDays: null, /// for pass null when you do not want to render weekDays
// //      headerText: Container( /// Example for rendering custom header
// //        child: Text('Custom Header'),
// //      ),
//           customDayBuilder: (   /// you can provide your own build function to make custom day containers
//               bool isSelectable,
//               int index,
//               bool isSelectedDay,
//               bool isToday,
//               bool isPrevMonthDay,
//               TextStyle textStyle,
//               bool isNextMonthDay,
//               bool isThisMonthDay,
//               DateTime day,
//               ) {
//             /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
//             /// This way you can build custom containers for specific days only, leaving rest as default.
//
//             // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
//
//             if(dateList.contains(DateTime(day.year,day.month,day.day))){
//               return Center(
//                 child: Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.blue,
//                   ),
//                   child: Center(child: Text(day.day.toString(),style: const TextStyle(color: Colors.black),)),
//                 ),
//               );
//             }
//             else{
//               return null;
//             }
//
//           },
//           weekFormat: false,
//           // markedDatesMap: _markedDateMap,
//           width: w>h?h/2.8:w*.8,
//           height: w>h?h/2.5:w*.9,
//           selectedDateTime: _currentDate,
//           daysHaveCircularBorder: true, /// null for not rendering any border, true for circular border, false for rectangular border
//         ),
//       ),
//     );
//   }


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
                  title: Center(child: Text('${endYear - index}')),
                  onTap: () async{
                    setState(() {
                      _loading=true;
                    });
                    // Do something with the selected year
                    int year = endYear-index;
                    _sel=year.toString();
                    // print('Selected Year: ${startYear + index}');
                    await fetchData(_sel,"0");
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


  Widget leaveCard(int index){

    return Container(
      width: w-50,
      // height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            SizedBox(
              width: w-20,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(child: leaveList[index].Days==.5?Image.asset('assets/halfday.png',scale: 15,):Image.asset('assets/fullday.png',scale: 15,)),
                  ),
                  Text(leaveList[index].LeaveDate,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  Text(leaveList[index].Status,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: leaveList[index].Status=="Approved"?Colors.green:Colors.orange),),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Text("Comments: ${leaveList[index].Comments}",style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 20,),
            leaveList[index].L1Status==""?const SizedBox():Text("Manager: ${leaveList[index].L1Status}",style: const TextStyle(fontSize: 16),),
            leaveList[index].L1Status==""?const SizedBox():const SizedBox(height: 10,),
            leaveList[index].L1Comments==""?const SizedBox():Text("Comments: ${leaveList[index].L1Comments}",style: const TextStyle(fontSize: 16),),
            leaveList[index].L1Comments==""?const SizedBox():const SizedBox(height: 20,),
            leaveList[index].L2Status==""?const SizedBox():Text("Admin: ${leaveList[index].L2Status}",style: const TextStyle(fontSize: 16),),
            leaveList[index].L2Status==""?const SizedBox():const SizedBox(height: 10,),
            leaveList[index].L2Comments==""?const SizedBox():Text("Comments: ${leaveList[index].L2Comments}",style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 20,),
            SizedBox(
              width: w-20,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: w/3,
                    height: 40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColorDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Adjust the border radius here
                          ),
                        ),
                        onPressed: (){
                      setState(() {
                        leaveCardPressed=false;
                        _loading=false;
                      });
                    }, child: const Text("Close",style: TextStyle(color: Colors.white),))
                  ),
                  leaveList[index].Status=="Cancel Req"?Container(width: w/3,):Container(
                      width: w/3,
                      height: 40,
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColorDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Adjust the border radius here
                          ),
                        ),
                          onPressed: ()async{
                            setState(() {
                              _loading=true;
                            });
                            String status = await apiServices().deleteLeave(leaveList[index].Id,"EMP");
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
                            await fetchData(_selectedMY!.year.toString(),_selectedMY!.month.toString());
                            showMessage(status);
                            setState(() {
                              leaveCardPressed=false;
                              _loading=false;
                            });
                      }, child: const Text("Delete",style: TextStyle(color: Colors.white),))
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }


  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }



}
