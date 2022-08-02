
import 'package:intl/intl.dart';
import 'package:wy/utils/datetime_utils.dart';

class UserModel {
  late int id = 0;
  late String sex = "0";
  late String firstName = "";
  late String lastName = "";
  late String phone = "";
  late String email = "";
  late String birth = "";
  late String memberCode = "";
  late int memberLevel = 0;
  late String balance = "0.00";
  late int freeTime = 0;
  late String createTime = "";

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0:json['id'];
    sex = json['sex'] == null ? "0":json['sex'];
    firstName = json['firstName'] == null ? "":json['firstName'];
    lastName = json['lastName'] == null ? "":json['lastName'];
    phone = json['phone'] == null ? "":json['phone'];
    email = json['email'] == null ? "":json['email'];
    birth = json['birth'] == null ? "":json['birth'];
    memberCode = json['memberCode'] == null ? "":json['memberCode'];
    memberLevel = json['memberLevel'] == null ? 0:json['memberLevel'];
    balance = json['balance'] == null ? "0.00":json['balance'];
    freeTime = json['freeTime'] == null ? 0:json['freeTime'];
    createTime = json['createTime'] == null ? "":json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sex'] = this.sex;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['birth'] = this.birth;
    data['memberCode'] = this.memberCode;
    data['memberLevel'] = this.memberLevel;
    data['balance'] = this.balance;
    data['freeTime'] = this.freeTime;
    data['createTime'] = this.createTime;
    return data;
  }

  int getAge(){
    try{
      DateTime bd = DateFormat('dd/MM/y', 'en_GB').parse(birth);
      return DatetimeUtils.getAge(bd);
    }catch(e){
      DateTime bd = DateFormat('d-MMM-y', 'en_GB').parse(birth);
      return DatetimeUtils.getAge(bd);
    }
  }

}