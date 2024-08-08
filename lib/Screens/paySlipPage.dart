import 'dart:io';
import 'package:einlogica_hr/Models/employerModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:einlogica_hr/Models/paySlipModel.dart';
import 'package:einlogica_hr/Models/userModel.dart';
import 'package:einlogica_hr/Widgets/loadingWidget.dart';
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:einlogica_hr/style/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

class paySlipPage extends StatefulWidget {

  // final String mobile;
  // final String name;
  final userModel currentUser;
  // final String permission;

  const paySlipPage({super.key, required this.currentUser});

  @override
  State<paySlipPage> createState() => _paySlipPageState();
}

class _paySlipPageState extends State<paySlipPage> {

  var w=0.00,h=0.00,t=0.00;
  // TextEditingController _nameCtrl= TextEditingController();
  final TextEditingController _monthCtrl = TextEditingController();
  DateTime? _selected=DateTime.now();
  paySlipModel paySlip = paySlipModel(Mobile: "", Name: "",Month: 0,Year: 0, Days: 0, LeaveDays: 0, LOP: 0, PresentDays: 0, Basic: 0, Allowance: 0, HRA: 0, TA: 0, DA: 0, Incentive: 0, GrossIncome: 0, PF: 0, ESIC: 0, ProTax: 0, Advance: 0, GrossDeduction: 0, NetPay: 0,DOJ: "",Department: "",Position: "",BankName: "",AccNo: "",UAN: "",PAN: "",ESICNo: "");
  List<paySlipModel> paySlipList = [];
  bool _loading=false;

  String _sel = DateTime?.now().year.toString();
  bool _paySlipPressed = false;
  final int startYear = 2022;
  int endYear = DateTime.now().year;
  Uint8List empIcon= Uint8List(0);
  List<employerModel> empDetails = [];


  @override
  void dispose() {
    // TODO: implement dispose
    _monthCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _monthCtrl.text= "${_selected!.month.toString()}  / ${_selected!.year.toString()}";
    fetchData(endYear.toString());
  }
  
  fetchData(String year)async{
    paySlipList = await apiServices().getPaySlip(year,widget.currentUser.Mobile);
    empIcon=await apiServices().getBill(widget.currentUser.Employer, "Employer");
    empDetails = await apiServices().getEmployer(widget.currentUser.Employer);
    setState(() {

    });
  }



  @override
  Widget build(BuildContext context) {

    w=MediaQuery.of(context).size.width;
    h=MediaQuery.of(context).size.height;
    t=MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: w,
            height: h,
            child: Column(
              children: [
                Container(
                  height: 80+t,
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
                            const Text("PaySlip",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            InkWell(
                              onTap: ()async{

                                _showYearPicker(context);

                                if(_selected!=null){
                                    fetchData(_selected!.year.toString());
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
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: paySlipList.isNotEmpty?ListView.builder(
                    padding: EdgeInsets.zero,
                      itemCount: paySlipList.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: w-50,
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
                              leading: const Icon(Icons.receipt),
                              title: Text('${DateFormat('MMMM').format(DateTime(2023,paySlipList[index].Month))} ${paySlipList[index].Year.toString()}'),
                              trailing: InkWell(
                                onTap: (){
                                  paySlip=paySlipList[index];
                                  setState(() {
                                    _paySlipPressed=true;
                                  });
                                },
                                child: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(Icons.arrow_forward_ios_rounded),
                                ),
                              ),
                            ),
                          ),
                        );

                  }):const Center(child: Text("Nothing to display"),),
                )
                // Row(
                //   children: [
                //     FieldArea("Month/Year", _monthCtrl, TextInputType.text,false),
                //
                //     InkWell(
                //       onTap: ()async{
                //         _selected = await showMonthYearPicker(
                //
                //           context: context,
                //           initialDate: _selected ?? DateTime.now(),
                //           firstDate: DateTime(2019),
                //           lastDate: DateTime(2030),
                //           // locale: localeObj,
                //         );
                //         if(_selected!=null){
                //           _monthCtrl.text = "${_selected!.month.toString()} / ${_selected!.year.toString()}";
                //         }
                //       },
                //       child: Container(
                //         width: 40,
                //         height: 40,
                //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                //             color: AppColors.buttonColorDark),
                //         child: const Icon(Icons.calendar_month_sharp,color: Colors.white,),
                //       ),
                //     )
                //   ],
                // ),
                // const SizedBox(height:100,),
                // InkWell(
                //   onTap: (){
                //     generatePdf();
                //   },
                //   child: Container(
                //     width: w/2,
                //     height: 50,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       color: AppColors.buttonColorDark,
                //     ),
                //
                //     child: const Center(child: Text("Download Pay Slip",style: TextStyle(color: Colors.white,fontSize: 16),)),
                //   ),
                // )

              ],
            ),
          ),
          _paySlipPressed?Container(
            width: w,
            height: h,
            color: Colors.black.withOpacity(.4),
            child: Center(
              child: Container(
                width: w-20,
                // height: h-50,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15,),
                    Center(child: Text('${DateFormat('MMMM').format(DateTime(2023,paySlip.Month))} ${paySlip.Year.toString()}',style: const TextStyle(fontWeight: FontWeight.bold),),),
                    const SizedBox(height: 10,),
                    Container(
                      width: w-50,
                      height: 20,
                      color: Colors.blue.shade100,
                      child: const Center(child: Text("Basic Information")),
                    ),
                    PaySlipBox("Name", paySlip.Name.toString() , "AccNo", paySlip.AccNo.toString()),
                    PaySlipBox("Desig", paySlip.Position, "Bank", paySlip.BankName.toString()),
                    PaySlipBox("Dep", paySlip.Department, "PAN", paySlip.PAN.toString()),
                    PaySlipBox("UAN", paySlip.UAN.toString() , "Work Days", paySlip.Days.toString()),
                    PaySlipBox("ESIC", paySlip.ESICNo.toString() , "LOP", paySlip.LOP.toString()),
                    PaySlipBox("DOJ", paySlip.DOJ.toString() , "Present", paySlip.PresentDays.toString()),
                    const SizedBox(height: 10,),
                    Container(
                      width: w-50,
                      height: 20,
                      color: Colors.blue.shade100,
                      child: const Center(child: Text("Salary Information")),
                    ),
                    const SizedBox(height: 10,),
                    PaySlipBox("Basic", paySlip.Basic.toString() , "PF", paySlip.PF.toString()),
                    PaySlipBox("Allowance", paySlip.Allowance.toString() , "ESI", paySlip.ESIC.toString()),
                    PaySlipBox("HRA", paySlip.HRA.toString() , "Loan", paySlip.Advance.toString()),
                    PaySlipBox("TA", paySlip.TA.toString() , "Pro Tax", paySlip.ProTax.toString()),
                    PaySlipBox("DA", paySlip.TA.toString() , "", ""),
                    PaySlipBox("Incentive", paySlip.Incentive.toString() , "", ""),
                    const SizedBox(height: 10,),
                    Container(
                        color: Colors.blue.shade100,
                        child: PaySlipBox("Earnings", paySlip.GrossIncome.toString() , "Deduction", paySlip.GrossDeduction.toString())),
                    Container(
                        color: Colors.blue.shade100,
                        child: PaySlipBox("", "" , "Net Pay", paySlip.NetPay.toString())),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: w/2.5,
                          height: 40,
                          child: ElevatedButton(onPressed: (){
                            setState(() {
                              _paySlipPressed=false;
                            });
                          }, child: const Text("Close")),
                        ),
                        SizedBox(
                          width: w/2.5,
                          height: 40,
                          child: ElevatedButton(onPressed: (){
                            generatePdf(paySlip);
                          }, child: const Text("Download")),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
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

  Future<void> generatePdf(paySlipModel paySlip) async {



    // String res =await apiServices().getPaySlip(_selected!.month.toString(),_selected!.year.toString(),widget.currentUser.Mobile);
    // if(res==""){
    //   showMessage("Pay Slip not available");
    //   print("Empty");
    //   return;
    // }
    //
    //
    // var d = jsonDecode(res)[0];
    //
    // paySlip = paySlipModel(Mobile: d['Mobile'], Name: d['Name'],Month: int.parse(d['Month']),Year: int.parse(d['Year']), Days: int.parse(d['Days']), LeaveDays: double.parse(d['LeaveDays']), LOP: double.parse(d['TotalLOP']), PresentDays: double.parse(d['PresentDays']), Basic: double.parse(d['Basic']), Allowance: double.parse(d['Allowance']), HRA: double.parse(d['HRA']), TA: double.parse(d['TA']), DA: double.parse(d['DA']), Incentive: double.parse(d['Incentive']), GrossIncome: double.parse(d['GrossIncome']), PF: double.parse(d['PF']), ESIC: double.parse(d['ESIC']), ProTax: double.parse(d['ProTax']), Advance: double.parse(d['Advance']), GrossDeduction: double.parse(d['GrossDeduction']), NetPay: double.parse(d['NetPay']),DOJ: d['DOJ'],Department: d['Department'],BankName: d['BankName'],AccNo: d['AccNum']);



    final pdf = pw.Document();

    // Read data from JSON
    // final json = await rootBundle.loadString('assets/payslip_data.json');
    // final dynamic payslipData = jsonDecode(json);

    // Company Information
    final pw.Widget companyInfo = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Add company logo

        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Container(
              width: 50,
              height: 50,
              child:await generateLogo()),
        ),
        pw.SizedBox(height: 10), // Add some space

        // Company name and address
        pw.Text(
          empDetails[0].name,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(empDetails[0].addl1),
        pw.Text(empDetails[0].addl2),
      ],
    );

    // PaySlip Information
    final pw.Widget payslipInfo = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // pw.Text(
        //   'PaySlip - ${payslipData['month']} ${payslipData['year']}',
        //   style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        // ),
        // pw.SizedBox(height: 10), // Add some space

        // Creating table
        pw.TableHelper.fromTextArray(
          // headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.center,
          cellStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          rowDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          headers: [],
          data: [['Pay Slip ${DateFormat('MMM').format(DateTime(2023,_selected!.month))} ${_selected!.year.toString()}']],
        ),

        pw.TableHelper.fromTextArray(
          columnWidths: {
            0: const pw.FixedColumnWidth(150),
            1: const pw.FixedColumnWidth(150),
            2: const pw.FixedColumnWidth(150),
            3: const pw.FixedColumnWidth(150),

          },
          // headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.centerLeft,
          cellStyle: const pw.TextStyle(fontSize: 10),
          // rowDecoration: const pw.BoxDecoration(
          //   color: PdfColors.grey300,
          // ),

          // headers: ['Pay Slip Jan 2024'],
          data: [[],['Name',paySlip.Name,"Bank Acc No",paySlip.AccNo],["Designation",widget.currentUser.Position,"Bank Name",paySlip.BankName],["UAN",paySlip.UAN,"PAN",paySlip.PAN],["Department",widget.currentUser.Department,"Total Working Days",paySlip.Days],["ESIC",paySlip.ESICNo,"LOP Days",paySlip.LOP],
            ["DOJ",paySlip.DOJ,"Present Days",paySlip.PresentDays]],
        ),

        pw.TableHelper.fromTextArray(
          // headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.centerLeft,
          rowDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          cellStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          // headers: ['Pay Slip Jan 2024'],
          columnWidths: {
            0: const pw.FixedColumnWidth(300),
            1: const pw.FixedColumnWidth(300),

          },
          headers: [],
          data: [['Earning Amount',"Deduction Amount"]],
        ),


        pw.TableHelper.fromTextArray(
          columnWidths: {
            0: const pw.FixedColumnWidth(150),
            1: const pw.FixedColumnWidth(150),
            2: const pw.FixedColumnWidth(150),
            3: const pw.FixedColumnWidth(150),

          },
          // headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.centerLeft,
          cellStyle: const pw.TextStyle(fontSize: 10),

          // headers: ['Pay Slip Jan 2024'],
          data: [[],['Basic',paySlip.Basic,"EPF",paySlip.PF],["Allowance",paySlip.Allowance,"ESI",paySlip.ESIC],["HRA",paySlip.HRA,"Pro Tax",paySlip.ProTax],["TA",paySlip.TA,"Loan Recovery",paySlip.Advance],
            ["DA",paySlip.DA,"",""],["Incentive",paySlip.Incentive,"",""]],
        ),


        pw.TableHelper.fromTextArray(
          columnWidths: {
            0: const pw.FixedColumnWidth(150),
            1: const pw.FixedColumnWidth(150),
            2: const pw.FixedColumnWidth(150),
            3: const pw.FixedColumnWidth(150),

          },
          cellStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          // headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.centerLeft,
          rowDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),

          // headers: ['Pay Slip Jan 2024'],
          data: [[],['Total Earnings',paySlip.GrossIncome,"Total Deductions",paySlip.GrossDeduction]],
        ),

        pw.TableHelper.fromTextArray(
          columnWidths: {
            0: const pw.FixedColumnWidth(150),
            1: const pw.FixedColumnWidth(150),
            2: const pw.FixedColumnWidth(150),
            3: const pw.FixedColumnWidth(150),

          },
          cellStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          // headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.centerLeft,
          rowDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),

          // headers: ['Pay Slip Jan 2024'],
          data: [[],['','',"Net Pay",paySlip.NetPay]],
        ),


      ],
    );

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              companyInfo,
              pw.SizedBox(height: 20), // Add some space
              payslipInfo,
            ],
          );
        },
      ),
    );
    // print("Saving PDF");
    // Save the PDF to a file
    // final output = await getApplicationDocumentsDirectory();
    final file = File('/storage/emulated/0/Download/payslip-${DateFormat('MMM').format(DateTime(2023,_selected!.month))}-${_selected!.year.toString()}-${DateTime.now().microsecond}.pdf');
    await file.writeAsBytes(await pdf.save()).whenComplete((){
      showDialog(context: context,
          builder: (BuildContext context)=>AlertDialog(
            title: const Text("Success"),
            content: const Text("PDF saved to downloads folder"),
            actions: [
              TextButton(
                onPressed: () async{

                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(14),
                  child: const Text("OK",style: TextStyle(color: Colors.black),),
                ),
              ),
            ],
          ));
    });
  }

  // Future<pw.Widget> generateLogo(String icon) async {
  //   final ByteData data = await rootBundle.load('assets/$icon');
  //   final Uint8List bytes = data.buffer.asUint8List();
  //   final imageProvider = pw.MemoryImage(bytes);
  //
  //   return pw.Image(imageProvider);
  // }
  Future<pw.Widget> generateLogo() async {
    // final ByteData data = await rootBundle.load('assets/$icon');
    final Uint8List bytes = empIcon;
    final imageProvider = pw.MemoryImage(bytes);

    return pw.Image(imageProvider);
  }


  Widget FieldArea(String title,TextEditingController ctrl,TextInputType type,bool edit){
    return SizedBox(
      width: w-100,
      height: 50,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: w*.25,
            // color: Colors.green,
            child: Text("$title :",style: const TextStyle(fontWeight: FontWeight.bold),),
          ),
          SizedBox(
              width: w*.3,
              child: TextFormField(

                keyboardType: type,
                enabled: edit,
                controller: ctrl,
                decoration: InputDecoration(
                  // icon: Icon(Icons.password),
                  // hintText: "Pin",

                  filled: true,
                  fillColor: Colors.white,
                  enabled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )
          ),
        ],
      ),
    );
  }

  showMessage(String mess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess),duration: const Duration(seconds: 1),));
  }


  _showYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Select a Year')),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SizedBox(
            height: 180,
            width: w/2-20,

            // width: double.maxFinite,
            child: ListView.builder(
              itemCount: endYear - startYear + 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Center(child: Text('${endYear - index}')),
                  onTap: () {
                    // Do something with the selected year
                    int year = endYear-index;
                    _sel=year.toString();
                    // print('Selected Year: ${startYear + index}');
                    fetchData(_sel);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget PaySlipBox(String T1,String V1, String T2, String V2){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
      child: SizedBox(
        width: w-50,
        // color: Colors.green,
        child: Row(

          children: [
            SizedBox(
                width:w/6,
                child: Text(T1)),
            SizedBox(
                width:w/4,
                child: Text(V1)),
            const Spacer(),
            SizedBox(
                width:w/6,
                child: Text(T2)),
            SizedBox(
                width:w/4,
                child: Text(V2)),

          ],
        ),
      ),
    );
  }


}

