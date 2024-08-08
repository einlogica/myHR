import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/classes/event.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/summaryModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/style/colors.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:einlogica_hr/Models/attendanceModel.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/services/locationService.dart';
import 'package:table_calendar/table_calendar.dart';

class attendancePage extends StatefulWidget {

  final String mobile;
  // final String name;
  final String permission;
  // final Function() callback;

  const attendancePage({super.key, required this.mobile, required this.permission});

  @override
  State<attendancePage> createState() => _attendancePageState();
}

class _attendancePageState extends State<attendancePage> {

  var w=0.0,h=0.0,t=0.00;
  // locationModel currLocation = locationModel(locationName: "", posLat: 0.00, posLong: 0.00);
  bool attPressed =false;
  bool loading =false;
  List<attendanceModel> attList = [];
  DateTime? _selected;
  TimeOfDay _selTime = TimeOfDay.now();
  String regIn ="",regOut="";


  //For summary view
  // bool _loading=false;
  List<int> presentDays =[];
  List<int> leaveDays =[];
  List<summaryModel> summList = [];
  Map<String,double> result={};
  double leaveBal=0.0;
  bool chartdata = false;
  int currMonth = DateTime?.now().month;
  int currYear = DateTime?.now().year;


  final TextEditingController _commentsCtrl= TextEditingController();
  final TextEditingController _regInCtrl = TextEditingController();
  final TextEditingController _regOutCtrl = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _commentsCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loading=true;
    fetchData(DateTime?.now());

  }

  fetchData(DateTime? sel)async{
    // print("Fetching data");
    // print(sel!.month);
    // print(sel!.year);
    setState(() {
      loading=true;
    });

    currMonth=sel!.month;
    currYear=sel.year;

    attList=await apiServices().getAttendanceData(widget.mobile,sel.month,sel.year);

    presentDays.clear();
    leaveDays.clear();
    for(var d in attList){
      if(d.status=='Absent' || d.status=='Leave'){
        leaveDays.add(int.parse(d.attDate.substring(0,2)));
      }
      else{
        presentDays.add(int.parse(d.attDate.substring(0,2)));
      }
    }

    // print(leaveDays.length);
    // print(leaveDays.first);
    // print("===============");
    // print(attList[0].location);
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {

    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: w,
            height: h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(height: 20,),
                Container(
                  width: w,
                  // height: w+t,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                    // color: AppColors.appBarColor,
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.themeStart,AppColors.themeStop]
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                            const Text("Attendance Management",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),),
                            InkWell(
                              onTap: ()async{

                                _selected = await showMonthYearPicker(
                                  context: context,
                                  initialDate: _selected ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                  // locale: localeObj,
                                );
                                // print("selected");
                                if(_selected!=null){
                                  // print("AAAA");

                                  fetchData(_selected);
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
                      w>h?const SizedBox():calendar(),
                    ],
                  ),
                ),

                Expanded(
                  child: SizedBox(
                    width: w-20,
                    // height: h/2,
                    // color: Colors.grey,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: attList.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                onTap: (){
                                  _regInCtrl.text=attList[index].attTime;
                                  _regOutCtrl.text=attList[index].outTime;
                                  showDialogBox(index);
                                },
                                leading: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Center(child: Icon(Icons.calendar_month_outlined,color: ['Leave','Absent'].contains(attList[index].status)?Colors.red:Colors.green,))),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(attList[index].attDate, style:const TextStyle(fontWeight: FontWeight.bold),),
                                    Text(attList[index].status=='Present'?attList[index].location:attList[index].status, style:const TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                subtitle: attList[index].status!='Present'?const SizedBox():Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(attList[index].attTime.substring(0,5),style: const TextStyle(color: Colors.green),),
                                    Text(attList[index].outTime.substring(0,5),style: TextStyle(color: attList[index].outTime=="00:00:00"?Colors.red:Colors.green),),
                                  ],
                                ),
                                // trailing: InkWell(
                                //   onTap:(){
                                //     _regInCtrl.text=attList[index].attTime;
                                //     _regOutCtrl.text=attList[index].outTime;
                                //     showDialogBox(index);
                                //   },
                                //   child: const SizedBox(
                                //     width: 20,
                                //     height: 50,
                                //     child: Center(child: Icon(Icons.arrow_forward_ios_rounded),),
                                //   ),
                                // ),

                              ),
                            ),
                          );
                        }
                        ),
                  ),
                ),

              ],
            ),
          ),
          loading?loadingWidget():const SizedBox(),
        ],
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
            headerVisible: false,
            firstDay: DateTime(currYear, currMonth, 1),
            lastDay: DateTime(currYear, currMonth, 31),
            focusedDay: DateTime(currYear, currMonth, 1),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle().copyWith(color: Colors.red),
            ),
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(color: Colors.white),
              defaultTextStyle: TextStyle(color: Colors.white),
              outsideDaysVisible: false,
              isTodayHighlighted: false,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {

                if (presentDays.contains(day.day)) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                else if(leaveDays.contains(day.day)){
                  // print(leaveDays[0]);
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            // calendarFormat: _calendarFormat,
            // selectedDayPredicate: (day) {
            //   return isSameDay(_selectedDay, day);
            // },
            // onDaySelected: (selectedDay, focusedDay) {
            //   if (!isSameDay(_selectedDay, selectedDay)) {
            //     setState(() {
            //       _selectedDay = selectedDay;
            //       _focusedDay = focusedDay;
            //     });
            //   }
            // },
            // onFormatChanged: (format) {
            //   if (_calendarFormat != format) {
            //     setState(() {
            //       _calendarFormat = format;
            //     });
            //   }
            // },
            // onPageChanged: (focusedDay) {
            //   _focusedDay = focusedDay;
            // },
          ),
        ),
      ),
    );

}

//   Widget calendar() {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: CalendarCarousel<Event>(
//         // onDayPressed: (DateTime date, List<Event> events) {
//         //   this.setState(() => _currentDate = date);
//         // },
//         weekendTextStyle: const TextStyle(
//           color: Colors.yellowAccent,
//         ),
//         daysTextStyle: const TextStyle(
//           color: Colors.white
//         ),
//         weekdayTextStyle: const TextStyle(
//           color: Colors.yellowAccent
//         ),
//         thisMonthDayBorderColor: Colors.black,
//         disableDayPressed: true,
//         showHeader: false,
//         todayButtonColor: Colors.transparent,
//         todayBorderColor: Colors.black,
//         showOnlyCurrentMonthDate: true,
//         targetDateTime: DateTime(currYear,currMonth),
//
//         // markedDatesMap: _markedDateMap,
//         isScrollable: false,
//         // pageScrollPhysics: NeverScrollableScrollPhysics(),
//         customGridViewPhysics: const NeverScrollableScrollPhysics(),
//         dayPadding: 5,
//
// //      weekDays: null, /// for pass null when you do not want to render weekDays
// //      headerText: Container( /// Example for rendering custom header
// //        child: Text('Custom Header'),
// //      ),
//         customDayBuilder: (   /// you can provide your own build function to make custom day containers
//             bool isSelectable,
//             int index,
//             bool isSelectedDay,
//             bool isToday,
//             bool isPrevMonthDay,
//             TextStyle textStyle,
//             bool isNextMonthDay,
//             bool isThisMonthDay,
//             DateTime day,
//             ) {
//           /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
//           /// This way you can build custom containers for specific days only, leaving rest as default.
//
//           // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
//
//           if (presentDays.contains(day.day)) {
//             return Center(
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.green.shade300,
//                 ),
//
//                 child: Center(child: Text(day.day.toString(),style: const TextStyle(color: Colors.black),)),
//               ),
//             );
//           } else if(leaveDays.contains(day.day)){
//             return Center(
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.red.shade300,
//                 ),
//                 child: Center(child: Text(day.day.toString(),style: const TextStyle(color: Colors.black),)),
//               ),
//             );
//           }
//           else{
//             return null;
//           }
//
//
//         },
//         weekFormat: false,
//         // markedDatesMap: _markedDateMap,
//         width: w*.8,
//         height: w*.75,
//         // selectedDateTime: _currentDate,
//         daysHaveCircularBorder: true, /// null for not rendering any border, true for circular border, false for rectangular border
//       ),
//     );
//   }


  Future showDialogBox(int _selectedIndex){
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        insetPadding: EdgeInsets.all(20),
        // backgroundColor: AppColors.boxColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(attList[_selectedIndex].status,style: const TextStyle(color: AppColors.buttonColorDark),),
            Text(attList[_selectedIndex].attDate.toString(),style: const TextStyle(color: AppColors.buttonColorDark,fontSize: 18),),
          ],
        ),
        content: SizedBox(
          width: w-10,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                attList[_selectedIndex].status=='Present'?Text(attList[_selectedIndex].location,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.buttonColorDark),):const SizedBox(),
                const SizedBox(height: 10,),
                attList[_selectedIndex].attTime!='00:00:00'?Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("CheckIn : ${attList[_selectedIndex].attTime}"),
                    attList[_selectedIndex].posLat!=0.00?InkWell(
                      onTap: ()async{
                        await locationServices().openMap(attList[_selectedIndex].posLat, attList[_selectedIndex].posLong);
                        // if(Platform.isAndroid){
                        //   await locationServices().openMap(attList[_selectedIndex].posLat, attList[_selectedIndex].posLong);
                        // }
                      },
                      child: const SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.location_on,color: Colors.green,),
                      ),
                    ):const SizedBox(),
                  ],
                ):SizedBox(
                  child: attList[_selectedIndex].flag!='true'?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                          width:100,
                          child: Text("CheckIn : ")),
                      SizedBox(
                        width: 100,
                        // height: 50,
                        child: TextFormField(
                          enabled: false,
                          controller: _regInCtrl,
                          // keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.phone),
                            fillColor: Colors.white,
                            filled: true,
                            enabled: false,
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
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _selTime,
                          );

                          if (picked != null && picked != _selTime) {
                            setState(() {
                              _regInCtrl.text = _formatTime(picked);
                            });
                          }
                        },
                        child: const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.access_time,color: Colors.deepOrange,),
                        ),
                      )
                    ],
                  ):const Text("Checkin under validation"),
                ),
                const SizedBox(height: 10,),
                attList[_selectedIndex].outTime!='00:00:00'?Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Checkout : ${attList[_selectedIndex].outTime}"),
                    attList[_selectedIndex].posLat2!=0.00?InkWell(
                      onTap: ()async{
                        await locationServices().openMap(attList[_selectedIndex].posLat, attList[_selectedIndex].posLong);
                        // if(Platform.isAndroid){
                        //     await locationServices().openMap(attList[_selectedIndex].posLat2, attList[_selectedIndex].posLong2);
                        // }
                      },
                      child: const SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.location_on,color: Colors.green,),
                      ),
                    ):const SizedBox(),
                  ],
                ):SizedBox(
                  child: attList[_selectedIndex].flag!='true'?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                          width:100,
                          child: Text("CheckOut : ")),
                      SizedBox(
                        width: 100,
                        // height: 50,
                        child: TextFormField(
                          enabled: false,
                          controller: _regOutCtrl,
                          // keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.phone),
                            fillColor: Colors.white,
                            filled: true,
                            enabled: false,
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
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _selTime,
                          );

                          if (picked != null && picked != _selTime) {
                            setState(() {
                              _regOutCtrl.text = _formatTime(picked);
                            });
                          }
                        },
                        child: const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.access_time,color: Colors.deepOrange,),
                        ),
                      )
                    ],
                  ):const Text("Checkout under validation"),
                ),
                const SizedBox(height: 10,),
                attList[_selectedIndex].flag=='true'?const SizedBox():attList[_selectedIndex].attTime=='00:00:00' || attList[_selectedIndex].outTime=='00:00:00'?SizedBox(
                  child: SizedBox(
                    width: w-100,
                    child: FieldArea(title: "Comments",type: TextInputType.text,ctrl: _commentsCtrl,len: 50,),

                  ),
                ):const SizedBox(),
              ],
            ),
          ),
        ),

        actions: <Widget>[
          attList[_selectedIndex].flag=='true'?const SizedBox():attList[_selectedIndex].attTime=='00:00:00' || attList[_selectedIndex].outTime=='00:00:00'?TextButton(
            // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
            onPressed: () async{
              if(_regInCtrl.text!='00:00:00' && _regOutCtrl.text!='00:00:00' && _commentsCtrl.text!=""){
                setState(() {
                  loading=true;
                });
                Navigator.of(ctx).pop();
                await apiServices().postRegularization(attList[_selectedIndex].Mobile, attList[_selectedIndex].Name,attList[_selectedIndex].attDate, _regInCtrl.text,_regOutCtrl.text,_commentsCtrl.text);
                fetchData(DateTime?.now());

              }
              else{
                showMessage("Invalid Inputs");
              }
            },
            child: Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.buttonColor,
              ),
              padding: const EdgeInsets.all(10),
              child: const Text("Modify",style: TextStyle(color: Colors.white),),
            ),
          ):const SizedBox(),
          attList[_selectedIndex].status=='Present'?TextButton(
            onPressed: (){
              showMessage("Long press to mark Absent");
            },
            onLongPress: () async{
              await apiServices().markAbsent(attList[_selectedIndex].Mobile,attList[_selectedIndex].attDate);
              fetchData(DateTime?.now());
              Navigator.of(ctx).pop();
              setState(() {

              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.buttonColor,
              ),
              padding: const EdgeInsets.all(10),
              child: const Text("Mark Absent",style: TextStyle(color: Colors.white),),
            ),
          ):SizedBox(),
          TextButton(
            onPressed: () {
              _commentsCtrl.clear();
              Navigator.of(ctx).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.buttonColor,
              ),
              padding: const EdgeInsets.all(10),
              child: const Text("Close",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final DateTime selectedTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(selectedTime);
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

}