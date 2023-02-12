import 'package:dio/dio.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/model/game_model.dart';

class GamesApi {
  static Future<List<SimpleGameModel>> getRecommendGames() async {
    Response response = await http.get(
      '/peiwan/app/login/listGame',
    );
    if (response.data == null) return [];
    return response.data.map<SimpleGameModel>((item) => SimpleGameModel.fromJson(item)).toList();
  }
}
