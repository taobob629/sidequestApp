class LevelModel {
  int levelNum;
  int nextLevelNum;
  double percent;
  int userLevel;
  String levelName;
  String currentRate;
  String nextLevelName;
  String nextRate;
  String tips;

  LevelModel(
      {this.levelNum = 0,
      this.nextLevelNum = 0,
      this.percent = 0,
      this.userLevel = 0,
      this.levelName = '',
      this.currentRate = '',
      this.nextRate = '',
        this.tips='',
      this.nextLevelName = ''});

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      levelNum: json['levelNum'],
      nextLevelNum: json['nextLevelNum'],
      percent: double.parse(json['percent'].toString()),
      userLevel: json['userLevel'],
      levelName: json['levelName'],
      nextRate: json['nextRate']??'',
      currentRate: json['currentRate']??'',
      nextLevelName: json['nextLevelName'],
      tips: json['tips']??'',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['levelNum'] = this.levelNum;
    data['nextLevelNum'] = this.nextLevelNum;
    data['percent'] = this.percent;
    data['userLevel'] = this.userLevel;
    data['levelName'] = this.levelName;
    data['nextLevelName'] = this.nextLevelName;
    data['tips'] = this.tips;
    return data;
  }
}
