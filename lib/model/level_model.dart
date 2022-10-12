class LevelModel {
  int levelNum;
  int nextLevelNum;
  double percent;
  int userLevel;

  LevelModel({this.levelNum=0, this.nextLevelNum=0, this.percent=0, this.userLevel=0});

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      levelNum: json['levelNum'],
      nextLevelNum: json['nextLevelNum'],
      percent:double.parse(json['percent'].toString()) ,
      userLevel: json['userLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['levelNum'] = this.levelNum;
    data['nextLevelNum'] = this.nextLevelNum;
    data['percent'] = this.percent;
    data['userLevel'] = this.userLevel;
    return data;
  }
}
