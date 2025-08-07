
import 'dart:convert';
import 'dart:io';

import 'package:einlogica_hr/Screens/Accounts/privacyPage.dart';
import 'package:einlogica_hr/Screens/Accounts/refundPage.dart';
import 'package:einlogica_hr/Screens/Accounts/terms.dart';
import 'package:einlogica_hr/Screens/Accounts/transactions.dart';
import 'package:einlogica_hr/Widgets/FieldArea.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../Models/employerModel.dart';
import '../../Models/userModel.dart';
import '../../Widgets/loadingWidget.dart';
import '../../style/colors.dart';
import 'dropDownSetting.dart';
import 'locationsPage.dart';

class settingsPage extends StatefulWidget {

  final userModel currentUser;
  final Function callback;
  const settingsPage({super.key,required this.currentUser,required this.callback});

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {

  var w=0.00,h=0.00,t=0.00;
  // final TextEditingController _addCtrl = TextEditingController();
  String selectedOption = "";
  bool optionSelected=false;
  bool _loading=true;
  bool _payment=false;
  bool _upgrade=false;
  bool _quoteSend=false;
  int _quantity =1;
  int _amount = 0;
  String orderID="";
  bool imgFromCamera=false;
  var pickedImage;
  late File? imageFile;

  List<String> settings = ["Drop Down","Locations"];
  Uint8List empIcon= Uint8List(0);
  List<employerModel> empDetails = [];
  List<Map<String,dynamic>> subList = [];
  final TextEditingController _empCtrl= TextEditingController();

  // List<String> settingsImage = ['assets/Drop Down.png','assets/Locations.png'];
  // List<String> selectedList = [];

  // Future fetchList(String selectedOption)async{
  //   print(selectedOption);
  //   selectedList.clear();
  //   selectedList=await apiServices().fetchSettingsList(selectedOption,widget.currentUser.Mobile);
  //
  //   optionSelected=true;
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    _empCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  fetchData()async{
    empIcon=await apiServices().getBill(widget.currentUser.Employer, "Employer");
    empDetails = await apiServices().getEmployer(widget.currentUser.Employer);
    await fetchSubscription();
    // subList = await apiServices().getSubscription(widget.currentUser.Mobile);
    _amount=subList[0]['Amount'];
    // print(subList);
    setState(() {
      _loading=false;
    });
  }

  fetchSubscription()async{
    subList = await apiServices().getSubscription(widget.currentUser.Mobile);
    // print(subList[0]);
  }

  menuFunction(String name){
    if(name=="Drop Down"){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return dropDownSettingsPage(currentUser: widget.currentUser);
      }));
    }
    else if(name=="Office Locations"){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return locationsPage(currentUser: widget.currentUser);
      }));
    }
    else if(name=="Transactions"){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return transactionsPage(currentUser: widget.currentUser);
      }));
    }

  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SizedBox(
            width: w,
            height: h,
            // color: Colors.grey,
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
                            const Text("Account Settings",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            const SizedBox(
                              width: 60,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          
                SizedBox(
                  width: w,
                  // color: Colors.blue,
                  height: h-60-t-50,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        subList.isEmpty?const SizedBox():widget.currentUser.Permission!="Admin"?const SizedBox():Center(
                          child: Container(
                            width: w,
                            // height: 130,
                            color: Colors.blue.withValues(alpha:.2),
                            child: Column(
                              children: [
                                Container(
                                    width: w,
                                    color: Colors.blue.shade300,
                                    child: const Center(child: Text("Subscription",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),))
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        // color: Colors.grey,
                                        width: w/2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // const Text("Subscription : Active",style: TextStyle(fontSize: 16),),
                                            Text(subList[0]['Amount']==0?"Plan : Free":"Plan : ${subList[0]['Amount']}",style: const TextStyle(fontSize: 16),),
                                            Text("Employees : ${subList[0]['EmpCount']}",style: const TextStyle(fontSize: 16),),
                                            Text("Expiry: ${subList[0]['Expiry']}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                            // SizedBox(height: 10,),
                                            //
                                            // SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: w/3,
                                        // color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            subList[0]['Amount']==0?const SizedBox():SizedBox(
                                              width: 100,
                                              height: 40,
                                              child: ElevatedButton(

                                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark.withValues(alpha: .5))),
                                                  onPressed: (){
                                                    setState(() {
                                                      _payment=true;
                                                    });
                                                  },
                                                  child: const Text("Pay",style: TextStyle(color: Colors.white),)),
                                            ),
                                            const SizedBox(height: 10,),
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  _upgrade=true;
                                                });
                                              },
                                              child: Container(
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      color: Colors.blue
                                                  ),
                                                  child: const Center(child: Text("Upgrade",style: TextStyle(fontSize: 12,color: Colors.white),))
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10,),
                        Stack(
                          children: [
                            Center(
                              child: Container(
                                width: w>h?w/5*1.2:w/3*1.2,
                                height: w>h?w/5*1.2:w/3*1.2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(w>h?w/5*1.2:w/3*1.2,),
                                  // border: Border.all(color: Colors.blue,width: 6),
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
                                child: SizedBox(
                                  width: w>h?w/5:w/3,
                                  height: w>h?w/5:w/3,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(w/4),
                                  //   // border: Border.all(color: Colors.black,width: 2),
                                  //   color: Colors.white,
                                  // ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: empIcon.isNotEmpty?Image.memory(empIcon,fit: BoxFit.contain,):Container(
                                        width: w>h?w/5:w/3,
                                        height: w>h?w/5:w/3,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(80),
                                            // border: Border.all(color: Colors.black,width: 5),
                                        ),
                                        child: const Center(child: Text("Logo",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),))),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: w>h?w/5*2:w/3*2,
                                height: w>h?w/5*1.2:w/3*1.2,
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                        width: w>h?w/5:w/2,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                              onPressed: (){
                                                imgFromCamera=true;
                                                // if(Platform.isAndroid || Platform.isIOS){
                                                //   getImage();
                                                // }
                                                getImage();

                                              },
                                              child: const Icon(Icons.camera,color: Colors.white,),
                                            ),
                                            ElevatedButton(
                                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                                              onPressed: (){
                                                imgFromCamera=false;
                                                // if(Platform.isAndroid){
                                                //   getImage();
                                                // }
                                                getImage();

                                              },
                                              child: const Icon(Icons.image,color: Colors.white,),
                                            ),
                                          ],
                                        )
                                    )
                                ),
                              ),
                            )
                            // SizedBox(
                            //   height: w/3,
                            //   child: Align(
                            //     alignment: Alignment.bottomRight,
                            //     child: Padding(
                            //       padding: EdgeInsets.all(8.0),
                            //       child: SizedBox(
                            //         // child: ElevatedButton(
                            //         //     style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white.withOpacity(.5))),
                            //         //     onPressed: (){
                            //         //
                            //         //     },
                            //         //     child: const Icon(Icons.edit,color: Colors.black,)
                            //         // ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        empDetails.isNotEmpty?SizedBox(
                          child: Column(
                            children: [
                              Text(empDetails[0].name,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              Text(empDetails[0].addl1),
                              Text(empDetails[0].addl2),
                            ],
                          ),
                        ):const SizedBox(),

                        const SizedBox(height: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            menuButton("Drop Down",menuFunction),
                            menuButton("Office Locations",menuFunction),
                            menuButton("Transactions",menuFunction),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                

                // const SizedBox(height: 10,),
                SizedBox(
                  // color: Colors.green,
                  width: w,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return const termsPage();
                            }));
                          },
                          child: SizedBox(
                            width: w/4,
                            child: const Center(child: Text("T&C",style: TextStyle(fontSize: 11),)),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return const privacyPage();
                            }));
                          },
                          child: SizedBox(
                            width: w/4,
                            child: const Center(child: Text("Privacy",style: TextStyle(fontSize: 11),)),
                          ),
                        ),

                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return const refundPage();
                            }));
                          },
                          child: SizedBox(
                            width: w/4,
                            child: const Center(child: Text("Refund",style: TextStyle(fontSize: 11),)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          
          
                // SizedBox(height: 10,),
              ],
            ),
          ),
          _upgrade?Container(
            width: w,
            height: h,
            color: Colors.black.withValues(alpha: .7),
            child: Center(
              child: Container(
                width: w-50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: _quoteSend?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10,),
                      const Text("Quote request has been send",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue),),
                      const SizedBox(height: 20,),
                      const Text("Thanks for your query, Our team will be contacting you soon.."),
                      // SizedBox(height: 10,),
                      // Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text("Regards")),
                      // Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text("myHR Team")),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                        onPressed: (){
                          setState(() {
                            _loading=false;
                            _quoteSend=false;
                            _upgrade=false;
                          });
                        },
                        child: const Text("OK",style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ):Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10,),
                    const Text("Upgrade plan",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue),),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FieldArea(title: "Expected Employee Count", ctrl: _empCtrl, type: TextInputType.number, len: 3),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                            onPressed: ()async{
                              setState(() {
                                _loading=true;
                              });
                              String status = await apiServices().getQuote(widget.currentUser.Mobile, _empCtrl.text);
                              _empCtrl.clear();
                              // print(status);
                              _loading=false;
                              if(status=="Success"){
                                _quoteSend=true;
                              }
                              setState(() {

                              });

                            },
                            child: const Text("Get Quote",style: TextStyle(color: Colors.white),),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                          onPressed: ()async{
                            setState(() {
                              _upgrade=false;
                            });
                          },
                          child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,)
                  ],
                ),
              ),
            ),

          ):const SizedBox(),
          _payment?Container(
            width: w,
            height: h,
            color: Colors.black.withValues(alpha: .7),
            child: Center(
              child: Container(
                width: w-50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: w-50,
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                          color: Colors.blue
                        ),
                        child: const Center(child: Text("Choose Subscription",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),))),
                    const SizedBox(height: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("Months",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            // const SizedBox(height: 5,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: (){
                                      setState(() {
                                        _quantity==1?1:_quantity--;
                                        _amount = _quantity*int.parse(subList[0]['Amount'].toString());
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('$_quantity',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: (){
                                      setState(() {
                                        _quantity==24?24:_quantity++;
                                        _amount = _quantity*int.parse(subList[0]['Amount'].toString());
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          // decoration:BoxDecoration(
                          //   borderRadius: BorderRadius.circular(5),
                          //   color: Colors.blue,
                          // ),
                          color: Colors.blue.withValues(alpha: .3),
                          // width: w/3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("Amount: Rs ${_amount.toString()} /-",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                            onPressed: ()async{
                              setState(() {
                                _payment=false;
                                // _loading=true;
                              });
                              orderID=await apiServices().getOrderid(widget.currentUser.Mobile, _amount.toString(), _quantity.toString());
                              // print(orderID);
                              // await apiServices().insertTransaction(widget.currentUser.Mobile,_amount,_quantity,orderID);
                              // showMessage("Payment Successfull: ${response.paymentId}");
                              Razorpay razorpay = Razorpay();
                              var options = {
                                'key': 'rzp_live_aUnuQeSvJAEjzs',
                                // 'key': 'rzp_test_9OpZHzb53yxKPB',
                                'amount': _amount*100,
                                'name': "myHR from Einlogica",
                                'order_id': orderID,
                                'description': 'myHR Subscription',
                                'retry': {'enabled': true, 'max_count': 1},
                                'send_sms_hash': true,
                                'prefill': {'contact': widget.currentUser.Mobile},
                                // 'external': {
                                //   'wallets': ['paytm']
                                // }
                              };
                              razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                              // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                              razorpay.open(options);

                            }, child: const Text("Pay",style: TextStyle(color: Colors.white),)),
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColorDark)),
                            onPressed: (){
                              setState(() {
                                _quantity=1;

                                _payment=false;
                                _loading=false;
                              });
                        }, child: const Text("Cancel",style: TextStyle(color: Colors.white),)),
                      ],
                    ),
                    const SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          ):const SizedBox(),
          _loading?loadingWidget():const SizedBox(),
        ],
      ),
    );
  }

  // _loading?loadingWidget():const SizedBox(),


  Future getImage() async {
    setState(() {
      _loading=true;
    });
    if(imgFromCamera==true){
      // pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
      // pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.camera);
      pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    else{
      pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    // print("===================");
    // print(pickedImage.toString());
    if(pickedImage.toString()!="null") {
      // print("My Comments: Running image picker");

      final croppedFile = (await ImageCropper().cropImage(
        // maxHeight: 800,
        // maxWidth: 800,
        compressFormat: ImageCompressFormat.jpg,
        // compressQuality: 50,
        sourcePath: pickedImage.path,
        // cropStyle: CropStyle.rectangle,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      ));
      if(croppedFile != null){
        // print("My Comments: Running image cropper");
        imageFile = File(croppedFile.path);

        String baseimage="";
        List<int> imageBytes = imageFile!.readAsBytesSync();
        baseimage = base64Encode(imageBytes);

        String status = await apiServices().uploadLogo(baseimage, widget.currentUser.Mobile);
        showMessage(status);

        widget.callback();
        // print("Calling callback");
        await fetchData();

        setState(() {
          _loading=false;
        });

      }
      else{
        setState(() {
          _loading=false;
        });
      }
    }
    else{
      setState(() {
        _loading=false;
      });
    }
  }

  Widget menuButton(String item,Function callback){
    // print(item);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          callback(item);
        },
        child: Container(
          width: w-10,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 30,
              height: 30,
              // child: Center(child: Icon(Icons.)),
              ),
              SizedBox(
                width: w/2,
                height: 60,
                child: Align(alignment: Alignment.centerLeft,child: Text(item)),
              ),
              const SizedBox(
                width: 100,
                height: 40,
                // child: Image.asset('assets/$item.png'),
                child: Icon(Icons.arrow_forward_ios_outlined),
              )
            ],
          ),
        ),
      ),
    );
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response)async{
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    // showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
    clearScreen();
    await apiServices().updatePayment(widget.currentUser.Mobile,"NA",orderID,"Failed");
    showMessage("Payment Failed");

  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response)async{
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
    // print(response);
    // print(response.signature);
    // print(response.paymentId);
    // print(response.orderId);
    bool signature = await apiServices().validateSignature(response.signature!, response.paymentId!, response.orderId!);
    if(signature){
      await apiServices().updatePayment(widget.currentUser.Mobile,response.paymentId!,response.orderId!,"Received");
      showMessage("Payment Successfull: ${response.paymentId}");
      await fetchSubscription();
    }
    else{
      showMessage("Invalid Signature");
    }

    clearScreen();


  }

  // void handleExternalWalletSelected(ExternalWalletResponse response){
  //   showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  // }

  void clearScreen(){
    setState(() {
      _quantity=1;
      _payment=false;
      _loading=false;
    });
  }

}
