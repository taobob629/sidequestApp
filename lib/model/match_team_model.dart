

class MatchTeamModel{
  late int id = 0;
  late String name = "";
  late String avatar = "";
  late String passCode = "";
  late int ranking = 0;
  late String leader = "";
  late String createTime = "";
  late List<TeamMemberModel> members = [];

  MatchTeamModel();

  MatchTeamModel.fromJson(Map<String, dynamic> json) {
    members = json["members"].map<TeamMemberModel>((item) => TeamMemberModel.fromJson(item)).toList();
    id = json["id"];
    name = json["name"];
    createTime = json["createTime"];
    avatar = json["avatar"];
    passCode = json["passCode"];
    ranking = json["ranking"];
    leader = json["leader"];
  }
}

class TeamMemberModel{
  late String memberRole = "";
  late String memberTag = "";
  late String memberPhoto = "";
  late String nickName = "";

  TeamMemberModel();

  TeamMemberModel.fromJson(Map<String, dynamic> json) {
    memberRole = json["memberRole"] == null ? "":json["memberRole"];
    memberTag = json["memberTag"] == null ? "":json["memberTag"];
    memberPhoto = json["memberPhoto"];
    nickName = json["memberName"];
  }
}