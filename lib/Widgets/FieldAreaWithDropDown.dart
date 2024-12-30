import 'package:einlogica_hr/Screens/upload_bill.dart';
import 'package:flutter/material.dart';

class FieldAreaWithDropDown extends StatefulWidget {

  final String title;
  final List<String> dropList;
  String dropdownValue;
  final Function callback;
  FieldAreaWithDropDown({super.key,required this.title,required this.dropList, required this.dropdownValue, required this.callback});

  @override
  State<FieldAreaWithDropDown> createState() => _FieldAreaWithDropDownState();
}

class _FieldAreaWithDropDownState extends State<FieldAreaWithDropDown> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: w-50,
        child: DropdownButtonFormField(
          borderRadius: BorderRadius.circular(10),
          menuMaxHeight: 200,
          dropdownColor: Colors.blue.shade50,
          items: widget.dropList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: widget.dropdownValue,
          onChanged: (String? newValue) {
            widget.dropdownValue = newValue!;
            widget.callback(widget.title,newValue);
            setState(() {

            });
            // print(dropdownSex);
          },
          decoration: InputDecoration(
            // icon: Icon(Icons.password),
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
