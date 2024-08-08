// import 'package:einlogica_hr/Models/locationModel.dart';
// import 'package:einlogica_hr/services/apiServices.dart';
// import 'package:flutter/material.dart';
//
// import '../Models/userModel.dart';
// import '../Widgets/loadingWidget.dart';
// import '../style/colors.dart';
//
// class settingsPage extends StatefulWidget {
//
//   final userModel currentUser;
//   const settingsPage({super.key,required this.currentUser});
//
//   @override
//   State<settingsPage> createState() => _settingsPageState();
// }
//
// class _settingsPageState extends State<settingsPage> {
//
//   var w=0.00,h=0.00,t=0.00;
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _latCtrl = TextEditingController();
//   final TextEditingController _longCtrl = TextEditingController();
//   final TextEditingController _rangeCtrl = TextEditingController();
//   List<locationModel> locationList = [];
//
//   bool _loading=false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchList();
//   }
//
//
//   Future fetchList()async{
//
//     locationList=await apiServices().getDefaultLocations();
//     setState(() {
//
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     w=MediaQuery.of(context).size.width;
//     h=MediaQuery.of(context).size.height;
//     t=MediaQuery.of(context).viewPadding.top;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         width: w,
//         height: h,
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   height: 80+t,
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: [AppColors.themeStart,AppColors.themeStop]
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       SizedBox(height: t,),
//                       SizedBox(
//                         height: 80,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             InkWell(
//                               onTap:(){
//                                 // widget.callback();
//                                 Navigator.pop(context);
//                               },
//                               child: const SizedBox(
//                                 width: 60,
//                                 height: 40,
//
//                                 // color: Colors.grey,
//                                 child: Center(child: Icon(Icons.arrow_back,size: 20,color: Colors.white,)),
//                               ),
//                             ),
//                             const Text("Location Settings",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
//                             const SizedBox(
//                               width: 60,
//                             )
//                           ],
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//
//
//               ],
//             ),
//
//             _loading?loadingWidget():const SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   showMessage(String mess){
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
//   }
// }
