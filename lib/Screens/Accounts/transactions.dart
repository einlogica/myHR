import 'package:einlogica_hr/services/apiServices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/paymentModel.dart';
import '../../Models/userModel.dart';
import '../../Widgets/loadingWidget.dart';
import '../../style/colors.dart';


class transactionsPage extends StatefulWidget {

  final userModel currentUser;
  const transactionsPage({super.key,required this.currentUser});

  @override
  State<transactionsPage> createState() => _transactionsPageState();
}

class _transactionsPageState extends State<transactionsPage> {

  var w=0.00,h=0.00,t=0.00;
  // final TextEditingController _nameCtrl = TextEditingController();
  // final TextEditingController _latCtrl = TextEditingController();
  // final TextEditingController _longCtrl = TextEditingController();
  // final TextEditingController _rangeCtrl = TextEditingController();
  List<paymentModel> paymentList = [];

  bool _loading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchList();
  }


  Future fetchList()async{

    paymentList=await apiServices().getPaymentList(widget.currentUser.Mobile);

    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        width: w,
        height: h,
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
                            const Text("Transactions",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            const SizedBox(
                              width: 60,
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: paymentList.isNotEmpty?ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: paymentList.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black,width: 2),
                            color: Colors.blue.shade50
                            ),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text("Bill Period:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                  Text("Bill Period: ${DateFormat('MMM yyyy').format(DateTime.parse(paymentList[index].FromDate))}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                  // Text("${paymentList[index].FromDate} - ${paymentList[index].ToDate} ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Txn id: ${paymentList[index].TransactionID}"),
                                  Text("Date: ${DateFormat('dd MM yyyy').format(DateTime.parse(paymentList[index].Date))}")
                                ],
                              ),
                              trailing: Text("${paymentList[index].Total}/-",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                            ),
                          ),
                        );
                      }):const Center(child: Text("Nothing to display"),)
                )

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
