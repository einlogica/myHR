//trackerList.add(trackerModel(Mobile: d['Mobile'], Name: d['Name'], Site: d['Site'], Date: d['Date'], Type: d['Type'],
// BillNo: d['BillNo'], Amount: d['Amount'], Filename: d['Filename'],Status: d['Status']));
//

class trackerModel{

  final String Mobile;
  final String Name;
  final String Site;
  final String FromLoc;
  final String ToLoc;
  final String KM;
  final String Date;
  final String Type;
  final String BillNo;
  final double Amount;
  final String Filename;
  final String Status;

  trackerModel({
    required this.Mobile,
    required this.Name,
    required this.Site,
    required this.FromLoc,
    required this.ToLoc,
    required this.KM,
    required this.Date,
    required this.Type,
    required this.BillNo,
    required this.Amount,
    required this.Filename,
    required this.Status
  });
}