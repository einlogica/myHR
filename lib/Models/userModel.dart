//userList.add(userModel(Mobile: d['Mobile'], Name: d['Name'], Permission: d['Permission']));
//

class userModel{

  final String Mobile;
  final String Name;
  final String Email;
  final String EmployeeID;
  final String Employer;
  final String Department;
  final String Position;
  final String Permission;
  final String Manager;
  final String ManagerID;
  final String DOJ;
  final double LeaveCount;
  final String Status;
  final String ImageFile;


  userModel({
    required this.Mobile,
    required this.Name,
    required this.Email,
    required this.EmployeeID,
    required this.Employer,
    required this.Department,
    required this.Position,
    required this.Permission,
    required this.Manager,
    required this.ManagerID,
    required this.DOJ,
    required this.LeaveCount,
    required this.Status,
    required this.ImageFile

  });

  // Map<String, dynamic> toMap(){
  //   return {"Mobile":Mobile,
  //     "Name":Name,
  //     "EmployeeID":EmployeeID,
  //     "Department":Department,
  //     "Position":Position,
  //     "Permission":Permission,
  //     "Manager":Manager,
  //     "ManagerID":ManagerID,
  //     "LeaveCount":LeaveCount,
  //     "Status":Status,
  //     "ImageFile":ImageFile,};
  // }
}