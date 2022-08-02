
import 'package:wy/config/app_config.dart';

class ParticipantModel {
  late String avatar = "";
  late String name = "";
  late int ranking = 0;

  ParticipantModel();

  ParticipantModel.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] == null ? "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpornleech.is%2Fstyle%2Fkcd-014%2Fimages%2Fdefault_avatar.gif&refer=http%3A%2F%2Fpornleech.is&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646052420&t=ddce06a0b1bbdb46ed1416b30fd9e1f6" : json['avatar'];
    name = json['name'];
    ranking = json['ranking'];
  }

  String getRank(){
    if(this.ranking == 0 || this.ranking == 10000){
      return "-";
    }else{
      return "$ranking";
    }
  }
}