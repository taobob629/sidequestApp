class GameAccountModel {
  int? id;
  int? memberId;
  String? lolName;
  String? puuid;
  String? accountId;
  int? summonerLevel;
  int? state;
  String? type;

  GameAccountModel({
    this.id,
    this.memberId,
    this.lolName,
    this.puuid,
    this.accountId,
    this.summonerLevel,
    this.state,
    this.type,
  });

  factory GameAccountModel.fromJson(Map<String, dynamic> json) =>
      GameAccountModel(
        id: json["id"],
        memberId: json["memberId"],
        lolName: json["lolName"],
        puuid: json["puuid"],
        accountId: json["accountId"],
        summonerLevel: json["summonerLevel"],
        state: json["state"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "memberId": memberId,
        "lolName": lolName,
        "puuid": puuid,
        "accountId": accountId,
        "summonerLevel": summonerLevel,
        "state": state,
        "type": type,
      };
}
