
import '../model/im_sig_model.dart';
import '../model/play_detail_model.dart';
import 'wy_http.dart';

class ImApi {

  static Future<ImSigModel> login() async {
    var response = await http.get('/peiwan/app/tim/getSig',);
    return ImSigModel.fromJson(response.data);
  }

  static Future<PlayDetailModel> getPlayDetail(String id) async {
    var response = await http.get('/peiwan/app/home/super/$id',
      queryParameters: ({})
    );
    return PlayDetailModel.fromJson(response.data);
  }
}