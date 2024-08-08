
//userExpenseList.add(userExpenseModel(ID:d['ID'],Mobile: d['Mobile'], Site: d['Site'], Date : d['Date'], Type: d['Type'], BillNo: d['BillNo'],
// \Amount: d['Amount'], Filename: d['Filename'],Status: d['Status'],Comments: d['Comments']));
//

class userExpenseModel{

  final String ID;
  final String Mobile;
  final String Name;
  final String Site;
  final String LabourName;
  final String LabourCount;
  final String Duration;
  final String FromLoc;
  final String ToLoc;
  final String KM;
  final String Date;
  final String Type;
  final String Item;
  final String ShopName;
  final String ShopDist;
  final String ShopPhone;
  final String ShopGst;
  final String BillNo;
  final String Amount;
  final String Filename;
  final String Status;
  final String L1Status;
  final String L1Comments;
  final String L2Status;
  final String L2Comments;
  final String FinRemarks;

  userExpenseModel({
    required this.ID,
    required this.Mobile,
    required this.Name,
    required this.Site,
    required this.LabourName,
    required this.LabourCount,
    required this.Duration,
    required this.FromLoc,
    required this.ToLoc,
    required this.KM,
    required this.Date,
    required this.Type,
    required this.Item,
    required this.ShopName,
    required this.ShopDist,
    required this.ShopPhone,
    required this.ShopGst,
    required this.BillNo,
    required this.Amount,
    required this.Filename,
    required this.Status,
    required this.L1Status,
    required this.L1Comments,
    required this.L2Status,
    required this.L2Comments,
    required this.FinRemarks
  });

}