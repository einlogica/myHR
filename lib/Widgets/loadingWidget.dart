import 'package:flutter/material.dart';

class loadingWidget extends StatelessWidget {
  loadingWidget({super.key});



  @override
  Widget build(BuildContext context) {

    final double w=MediaQuery.of(context).size.width;
    final double h=MediaQuery.of(context).size.height;

    return Container(
      width: w,
      height: h,
      color: Colors.black.withOpacity(.4),
      child: Center(
        child: Container(
          width: w/2,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Loading.. "),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
