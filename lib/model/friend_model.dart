class FriendModel {
  int? id;
  int? memberId;
  int? toMemberId;
  int? friendState;
  String? notes;
  String? nickName;
  String? memberCode;
  String? memberPhoto;

  FriendModel({
    this.id,
    this.memberId,
    this.toMemberId,
    this.friendState,
    this.notes,
    this.nickName,
    this.memberCode,
    this.memberPhoto,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
    id: json["id"],
    memberId: json["memberId"],
    toMemberId: json["toMemberId"],
    friendState: json["friendState"],
    notes: json["notes"],
    nickName: json["nickName"],
    memberCode: json["memberCode"],
    memberPhoto: json["memberPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "memberId": memberId,
    "toMemberId": toMemberId,
    "friendState": friendState,
    "notes": notes,
    "nickName": nickName,
    "memberCode": memberCode,
    "memberPhoto": memberPhoto,
  };
}
