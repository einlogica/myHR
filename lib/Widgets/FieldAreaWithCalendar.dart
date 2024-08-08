import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FieldAreaWithCalendar extends StatefulWidget {

  final String title;
  final TextEditingController ctrl;
  final TextInputType type;
  final int days;
  const FieldAreaWithCalendar({super.key,required this.title,required this.ctrl,required this.type,required this.days});

  @override
  State<FieldAreaWithCalendar> createState() => _FieldAreaWithCalendarState();
}

class _FieldAreaWithCalendarState extends State<FieldAreaWithCalendar> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: w-50,
        height: 60,
        // color: Colors.grey,
        child: TextFormField(
          keyboardType: widget.type,
          enabled: true,
          readOnly: true,
          controller: widget.ctrl,
          onTap: ()async{
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), //get today's date
              firstDate:DateTime.now().subtract(Duration(days: widget.days)),
              lastDate: DateTime.now(),
            );
            if(pickedDate != null ){
              // print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
              // print(formattedDate); //formatted date output using intl package =>  2022-07-04
              //You can format date as per your need

              setState(() {
                widget.ctrl.text = formattedDate; //set foratted date to TextField value.
              });
            }else{
              print("Date is not selected");
            }
          },
          decoration: InputDecoration(

            // suffixIcon: GestureDetector(
            //     onTap: ()async{
            //       DateTime? pickedDate = await showDatePicker(
            //           context: context,
            //           initialDate: DateTime.now(), //get today's date
            //           firstDate:DateTime(1960), //DateTime.now() - not to allow to choose before today.
            //           lastDate: DateTime.now(),
            //       );
            //       if(pickedDate != null ){
            //         // print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
            //         String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
            //         // print(formattedDate); //formatted date output using intl package =>  2022-07-04
            //         //You can format date as per your need
            //
            //         setState(() {
            //           widget.ctrl.text = formattedDate; //set foratted date to TextField value.
            //         });
            //       }else{
            //         print("Date is not selected");
            //       }
            //     },
            //     child: const Icon(Icons.calendar_month_sharp)),
            label: Text(widget.title),
            filled: true,
            fillColor: Colors.white,
            enabled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
