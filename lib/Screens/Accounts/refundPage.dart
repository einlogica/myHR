
import 'package:flutter/material.dart';
import '../../Widgets/loadingWidget.dart';
import '../../style/colors.dart';

class refundPage extends StatefulWidget {

  // final userModel currentUser;
  const refundPage({super.key});

  @override
  State<refundPage> createState() => _refundPageState();
}

class _refundPageState extends State<refundPage> {

  var w=0.00,h=0.00,t=0.00;

  bool _loading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: w,
        height: h,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 80+t,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.themeStart,AppColors.themeStop]
                    ),
                  ),
                  child: Column(
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
                            const Text("Refund Policy",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            const SizedBox(
                              width: 60,
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                const Expanded(child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        // Text("Grievance Officer", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                        Text("    At Einlogica Solutions Private Limited, we strive to ensure that our customers are completely satisfied with our products and services. However, due to the nature of our offerings, all sales are final, and we do not offer refunds under any circumstances."),
                        SizedBox(height: 20,),
                        Text("No Refunds", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                        Text("    All purchases made on our website or through our services are non-refundable. Once a transaction is completed, it cannot be canceled or reversed, and no refunds will be issued. We encourage our customers to thoroughly review and understand our product offerings and policies before making a purchase."),
                        SizedBox(height: 20,),
                        Text("Contact Us", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                        Text("    If you have any questions or concerns about this Refund Policy, please contact our customer support team at support@einlogica.com. We are here to assist you and address any inquiries you may have."),
                        SizedBox(height: 20,),

                        Text("Thank you for understanding and supporting our policy."),


                      ],
                    ),
                  ),
                ))



              ],
            ),

            _loading?loadingWidget():const SizedBox(),
          ],
        ),
      ),
    );
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }
}
