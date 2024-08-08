import 'package:flutter/material.dart';

class PinFieldArea extends StatefulWidget {

  final String title;
  final TextEditingController ctrl;
  final TextInputType type;
  final int len;
  const PinFieldArea({super.key,required this.title,required this.ctrl, required this.type,required this.len});

  @override
  State<PinFieldArea> createState() => _PinFieldAreaState();
}

class _PinFieldAreaState extends State<PinFieldArea> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: w-50,
        height: 50,
        // color: Colors.grey,
        child: SizedBox(
          // width: w-20,
            child: TextFormField(
              keyboardType: widget.type,
              enabled: true,
              obscureText: true,
              controller: widget.ctrl,
              maxLength: widget.len,
              decoration: InputDecoration(
                // icon: Icon(Icons.password),
                counterText: '',
                label: Text(widget.title),
                filled: true,
                fillColor: Colors.white,
                enabled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            )
        ),
      ),
    );
  }
}
