class payRollModel{

  final String Mobile;
  final String Name;
  final int Month;
  final int Year;
  final int Days;
  final int WorkingDays;
  final double LeaveDays;
  final double LOP;
  final double PresentDays;
  final double TotalLOP;
  final double Basic;
  final double Allowance;
  final double HRA;
  final double TA;
  final double DA;
  final double Incentive;
  final double GrossIncome;
  final double PF;
  final double ESIC;
  final double ProTax;
  final double Advance;
  final double GrossDeduction;
  final double NetPay;


  payRollModel({
    required this.Mobile,
    required this.Name,
    required this.Month,
    required this.Year,
    required this.Days,
    required this.WorkingDays,
    required this.LeaveDays,
    required this.LOP,
    required this.PresentDays,
    required this.TotalLOP,
    required this.Basic,
    required this.Allowance,
    required this.HRA,
    required this.TA,
    required this.DA,
    required this.Incentive,
    required this.GrossIncome,
    required this.PF,
    required this.ESIC,
    required this.ProTax,
    required this.Advance,
    required this.GrossDeduction,
    required this.NetPay
  });

}