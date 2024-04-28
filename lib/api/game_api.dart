import 'package:dio/dio.dart';
import 'package:sq_hub_app/api/wy_http.dart';

import '../model/game_model.dart';

class GamesApi {
  static Future<List<SimpleGameModel>> getRecommendGames() async {
    Response response = await http.get(
      '/peiwan/app/login/listGame',
    );
    if (response.data == null) return [];
    return response.data
        .map<SimpleGameModel>((item) => SimpleGameModel.fromJson(item))
        .toList();
  }

  static Future<Response> addRegisterFavorite(List gameIds) async {
    Response response = await http.post('/peiwan/app/login/addRegisterFavorite',
        data: Map()..['gameIdList'] = gameIds);
    return response;
  }

  static Future<List<SimpleGameModel>> getTopPlayers() async {
    Response response = await http.get(
      '/peiwan/app/new/home/topPlayers',
    );
    if (response.data == null) return [];
    return response.data
        .map<SimpleGameModel>((item) => SimpleGameModel.fromJson(item))
        .toList();
  }
}
