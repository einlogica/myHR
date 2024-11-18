import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/patternPainter.dart';

class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {

  var w=0.00,h=0.00,t=0.00;
  bool card = false;
  bool loading= false;
  TextEditingController _mobileCtrl = TextEditingController();
  TextEditingController _nameCtrl= TextEditingController();
  TextEditingController _emailCtrl= TextEditingController();
  TextEditingController _idCtrl= TextEditingController();
  TextEditingController _empCtrl= TextEditingController();
  TextEditingController _l1Ctrl= TextEditingController();
  TextEditingController _l2Ctrl= TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _mobileCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _empCtrl.dispose();
    _l1Ctrl.dispose();
    _l2Ctrl.dispose();
    _idCtrl.dispose();

    super.dispose();
  }

  void clearall(){
    _nameCtrl.clear();
    _emailCtrl.clear();
    _mobileCtrl.clear();
    _empCtrl.clear();
    _l1Ctrl.clear();
    _l2Ctrl.clear();
    _idCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {

    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomPaint(
        painter: PatternPainter(),
        child: Center(
          child: Container(
            width: w>h?w/2:w,
            height: w>h?h/2:h,
            // color: Colors.grey,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: w>h?w/2-20:w-20,
                    height: w>h?h/2-20:h-20,
                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                    //   color: Colors.white.withOpacity(.8),),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 80,),
                          Text ("New Employer Registration",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                          SizedBox(height: 20,),
                          FieldArea(title: "Admin Name", ctrl: _nameCtrl, type: TextInputType.text, len: 20),
                          SizedBox(height: 5,),
                          FieldArea(title: "Admin Mobile", ctrl: _mobileCtrl, type: TextInputType.number, len: 10),
                          SizedBox(height: 5,),
                          FieldArea(title: "Admin Email", ctrl: _emailCtrl, type: TextInputType.text, len: 49),
                          SizedBox(height: 5,),
                          FieldArea(title: "Admin Employee Id", ctrl: _idCtrl, type: TextInputType.text, len: 10),
                          SizedBox(height: 5,),
                          FieldArea(title: "Company Name", ctrl: _empCtrl, type: TextInputType.text, len: 50),
                          SizedBox(height: 5,),
                          FieldArea(title: "Address Line 1", ctrl: _l1Ctrl, type: TextInputType.text, len: 40),
                          SizedBox(height: 5,),
                          FieldArea(title: "Address Line 2", ctrl: _l2Ctrl, type: TextInputType.text, len: 40),
                          SizedBox(height: 20,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                                  onPressed: (){
                                    clearall();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel",style: TextStyle(color: Colors.white),)
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                                  onPressed: ()async{
                                    if(_nameCtrl.text=="" || _mobileCtrl.text=="" || _emailCtrl.text=="" || _idCtrl.text=="" || _empCtrl.text=="" || _l1Ctrl.text=="" || _l2Ctrl.text==""){
                                      showMessage("Invalid Inputs");
                                      return;
                                    }
                                    setState(() {
                                      loading=true;
                                    });
                                    String status = await apiServices().registration(_nameCtrl.text, _mobileCtrl.text, _emailCtrl.text, _idCtrl.text, _empCtrl.text, _l1Ctrl.text, _l2Ctrl.text);
                                    if(status=="Success"){
                                      clearall();
                                      setState(() {
                                        card=true;
                                        loading=false;
                                      });
                                    }
                                    else{
                                      setState(() {
                                        loading=false;
                                      });
                                      showMessage(status);
                                    }
                                  },
                                  child: Text("Submit",style: TextStyle(color: Colors.white),)
                              ),
                            ],
                          )


                        ],
                      ),
                    ),
                  ),
                ),
                loading?loadingWidget():SizedBox(),
                card?Container(
                  width: w>h?w/2:w,
                  height: w>h?h/2:h,
                  color: Colors.black.withOpacity(.6),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 80,
                          ),
                          SizedBox(height: 16),
                          const Text(
                            'Thank You for Registering!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          const Text(
                            'An email has been sent to your registered email address with the login credentials.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                            onPressed: () {
                              Navigator.pop(context); // Navigate back or take any action
                            },
                            child: Text('Continue',style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ):SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 2),));
  }

}
