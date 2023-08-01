import 'package:dio/dio.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/model/game_model.dart';
import 'package:wy/model/game_section.dart';
import 'package:wy/model/game_user_model.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/model/service_detail_model.dart';
import 'package:wy/model/service_info_model.dart';

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

  static Future<GameConfig?> getPriceRange(var gameId,
      {var levelId, var addServiceItem = false}) async {
    Response response = await http.get(
        '${addServiceItem ? '/peiwan/app/service/getItemRange' : '/peiwan/app/service/priceRange'}',
        queryParameters: {'gameId': '$gameId', 'levelid': levelId});
    if (response.data == null) return null;
    return GameConfig.fromJson(response.data);
    //return response.data.map<PriceRangeModel>((item) => PriceRangeModel.fromJson(item)).toList();
  }

  static Future<List<ServiceInfoModel>> getGameServicesInfo(var isEdit) async {
    Response response =
        await http.get('/peiwan/app/service/skillInit?edit=${isEdit ? 1 : 0}');
    if (response.data == null) return [];
    return response.data
        .map<ServiceInfoModel>((item) => ServiceInfoModel.fromJson(item))
        .toList();
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

  static Future<List<SimpleGameModel>> getMyGamesList() async {
    Response response = await http.get('/peiwan/app/home/gamelist',
        queryParameters: Map()
          ..['pageNum'] = 1
          ..['pageSize'] = 10
          ..['searchParams'] = '');
    if (response.data == null) return [];
    return response.data
        .map<SimpleGameModel>((item) => SimpleGameModel.fromJson(item))
        .toList();
  }

  static Future<List<GameUserModel>> getGamesPlayerList(
      Map<String, dynamic> params,
      {var pageNum,
      var pageSize,
      var searchParams,
      var gid}) async {
    Response response = await http.get(
      '/peiwan/app/new/superlist?pageNum=$pageNum&pageSize=10&gid=$gid&searchParams=$searchParams',
    );
    if (response.data == null) return [];
    return response.data
        .map<GameUserModel>((item) => GameUserModel.fromJson(item))
        .toList();
  }

  static Future<Response> addRegisterFavorite(List gameIds) async {
    Response response = await http.post('/peiwan/app/login/addRegisterFavorite',
        data: Map()..['gameIdList'] = gameIds);
    return response;
  }

  static Future<GameSectionModel> getGamesSection(var gameId) async {
    Response response = await http.get('/peiwan/app/new/filter',
        queryParameters: Map()..['gameId'] = gameId);
    return GameSectionModel.fromJson(response.data);
  }

  /**
   * skillDetail
   */
  static Future<ServiceDetailModel> getSkillDetail(var id) async {
    Response response = await http.get('/peiwan/app/service/skill?id=$id');
    return ServiceDetailModel.fromJson(response.data);
  }

  /**
   * skillDetail
   */
  static Future<PriceRangeModel> getConfig(var id) async {
    Response response = await http.get('/peiwan/app/home/config?gameId=$id');
    return PriceRangeModel.fromJson(response.data);
  }

  /**
   *  id 子项id skullAuthid 服务id status 0关闭 1开启
   */
  static Future<Response> changeServiceStatus(
      {var id, var skillAuthid, var status}) async {
    Response response = await http.post('/peiwan/app/service/changeStatus',
        queryParameters: Map<String, dynamic>()
          ..['id'] = id
          ..['skillAuthid'] = skillAuthid
          ..['status'] = status);
    return response;
  }
}
