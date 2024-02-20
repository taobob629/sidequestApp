class IntegralCheckInModel {
  late String day;
  late int checkType;
  late int awardType;
  late int number;

  IntegralCheckInModel.fromJson(Map<String, dynamic> json) {
    day = json['day'] ?? '';
    checkType = json['checkType'] ?? 0;
    awardType = json['awardType'] ?? 0;
    number = json['number'] ?? 0;
  }
}