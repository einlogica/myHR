
import 'package:einlogica_hr/services/apiServices.dart';
import 'package:flutter/material.dart';
import '../../Widgets/loadingWidget.dart';
import '../../style/colors.dart';


class collectionSumaryPage extends StatefulWidget {

  const collectionSumaryPage(
      {super.key,
        required this.mobile,
        required this.name,
        required this.permission});

  final String mobile;
  final String name;
  final String permission;

  @override
  State<collectionSumaryPage> createState() => _collectionSumaryPageState();
}

class _collectionSumaryPageState extends State<collectionSumaryPage> {

  var w=0.00,h=0.00,t=0.00;
  // final TextEditingController _nameCtrl = TextEditingController();

  List<Map<String, dynamic>> materialData = [];
  List<Map<String, dynamic>> billerData = [];
  List<Map<String, dynamic>> cashData = [];
  bool _loading=true;
  DateTime? _selected=DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }


  Future fetchData()async{

    materialData = await apiServices().getMaterialSummary(widget.mobile,_selected!);
    billerData = await apiServices().getBillerSummary(widget.mobile,_selected!);
    cashData = await apiServices().getCashSummary(widget.mobile,_selected!);
    // print(materialData);
    // print(billerData);
    setState(() {
    _loading=false;
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
                            const Text("Collection Summary",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                            InkWell(
                              onTap: ()async{
                                setState(() {
                                  _loading=true;
                                });

                                _selected = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(), //get today's date
                                    firstDate:DateTime(2022), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2030)
                                );
                                // print(_selected);
                                if(_selected!=null){
                                  await fetchData();
                                  // print(DateFormat('yyyy-MM-dd').format(_selected!));
                                }
                                else{
                                  setState(() {
                                    _loading=false;
                                  });
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
                Expanded(
                  child: (materialData.isEmpty && billerData.isEmpty && cashData.isEmpty)?const Center(child: Text("Nothing to Display"),):SingleChildScrollView(
                    child: Column(
                      children: [
                        materialData.isEmpty?const SizedBox():const SizedBox(height: 20,),
                        materialData.isEmpty?const SizedBox():const Text("Material Collection"),
                        materialData.isEmpty?const SizedBox():const SizedBox(height: 10,),
                        materialData.isEmpty?const SizedBox():SizedBox(
                          // height: expenseData.length*50,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              // headingRowColor: WidgetStateColor.resolveWith(
                              //         (states) => Colors.blue),
                              columnSpacing: 20,
                              columns: const [
                                DataColumn(label: Text('Division')),
                                DataColumn(label: Text('Type')),
                                DataColumn(label: Text('Count')),
                                DataColumn(label: Text('Dry Weight')),
                                DataColumn(label: Text('Cloth Weight')),
                                DataColumn(label: Text('Rej Amount')),
                              ],
                              rows: materialData.map((model) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(model['division'])),
                                    DataCell(Text(model['type'])),
                                    DataCell(Text(model['Shops'])),
                                    DataCell(Text(model['dryweight'])),
                                    DataCell(Text(model['clothweight'])),
                                    DataCell(Text(model['rejAmount'])),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        billerData.isEmpty?const SizedBox():const SizedBox(height: 40,),
                        billerData.isEmpty?const SizedBox():const Text("Site Visits"),
                        billerData.isEmpty?const SizedBox():const SizedBox(height: 10,),
                        billerData.isEmpty?const SizedBox():Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            // height: expenseData.length*50,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                // headingRowColor: WidgetStateColor.resolveWith(
                                //         (states) => Colors.blue),
                                columnSpacing: 20,
                                columns: const [
                                  DataColumn(label: Text('Division')),
                                  DataColumn(label: Text('Visited')),
                                  DataColumn(label: Text('Enrolled')),
                                ],
                                rows: billerData.map((model) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(model['Division'])),
                                      DataCell(Text(model['Visited'])),
                                      DataCell(Text(model['New'])),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        cashData.isEmpty?const SizedBox():const SizedBox(height: 40,),
                        cashData.isEmpty?const SizedBox():const Text("Cash Collection"),
                        cashData.isEmpty?const SizedBox():const SizedBox(height: 10,),
                        cashData.isEmpty?const SizedBox():Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            // height: expenseData.length*50,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                // headingRowColor: WidgetStateColor.resolveWith(
                                //         (states) => Colors.blue),
                                columnSpacing: 20,
                                columns: const [
                                  DataColumn(label: Text('Type')),
                                  DataColumn(label: Text('Amount')),
                                ],
                                rows: cashData.map((model) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(model['Type'])),
                                      DataCell(Text(model['Amount'])),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      // ignore: prefer_const_constructors
                      SizedBox(height: 30,),
                    ],
                    ),
                  ),
                ),
                

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
