
import 'package:dio/dio.dart';
import 'package:sq_hub_app/api/wy_http.dart';

import '../model/activity_item_model.dart';
import '../model/event_detail_model.dart';
import '../model/match_item_model.dart';
import '../model/match_team_model.dart';

class EventsApi {

  static Future<List<ActivityItemModel>> activities(int pageNum, int pageSize) async {
    var response = await http.get('/app/events/activities',
        queryParameters: ({'pageNum': pageNum,'pageSize':pageSize})
    );
    //print(response.data);
    List<ActivityItemModel> list = response.data
        .map<ActivityItemModel>((item) => ActivityItemModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<MatchItemModel>> matches(int pageNum, int pageSize) async {
    var response = await http.get('/app/events/matches',
        queryParameters: ({'pageNum': pageNum,'pageSize':pageSize})
    );
    //print(response.data);
    List<MatchItemModel> list = response.data
        .map<MatchItemModel>((item) => MatchItemModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<EventDetailModel?> getMatchDetail(int id) async {
    var response = await http.get('/app/events/26/match/detail/$id',
        queryParameters: ({})
    );
    if (response.data.toString().contains("data") && response.data["data"] == null) {
      return null;
    }
    return EventDetailModel.fromJson(response.data);
  }

  static Future<EventDetailModel?> getActivityDetail(int id) async {
    // var response = await http.get('/app/events/event/detail/$id',
    var response = await http.get('/app/events/26/event/detail/$id',
        queryParameters: ({})
    );

    if (response.data["data"] == null) {
      return null;
    }
    return EventDetailModel.fromJson(response.data);
  }



  static Future<List<ActivityItemModel>> userActivities() async {
    var response = await http.get('/app/events/userActivities',
        queryParameters: ({})
    );
    //print(response.data);
    List<ActivityItemModel> list = response.data
        .map<ActivityItemModel>((item) => ActivityItemModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<List<MatchItemModel>> userMatches() async {
    var response = await http.get('/app/events/userMatches',
        queryParameters: ({})
    );
    //print(response.data);
    List<MatchItemModel> list = response.data
        .map<MatchItemModel>((item) => MatchItemModel.fromJson(item))
        .toList();
    return list;
  }

  static Future<void> joinActivity(int eventId,int userId,int location,{String cupsleeve = '',var memberCouponId}) async {
    var formData = {
      "matchId" : eventId,
      "memberId" : userId,
      "location" : location,
      "cupsleeve" : cupsleeve,
      'memberCouponId':memberCouponId
    };
    var response = await http.post('/app/events/joinActivity',
        data: formData
    );
  }
  static Future<Response> cancelActivity(var eventId) async {
    var response = await http.get('/app/events/cancellEvent/$eventId');
    return response;
  }

  static Future<Map<String, String>> joinMatch(int eventId,int userId,int location,{var cupsleeve,var memberCouponId}) async {
    var formData = {
      "matchId" : eventId,
      "memberId" : userId,
      "location" : location,
      "cupsleeve" : cupsleeve,
      'memberCouponId':memberCouponId
    };
    var response = await http.post('/app/events/joinMatch',
        data: formData
    );
    return {
      'url': response.data['url'],
      'code': response.data['code'],
    };
  }

  static Future<int> createTeam(int eventId,String name,String code,String role, String discordTag,int location) async {
    var formData = {
      "matchId" : eventId,
      "name" : name,
      "code" : code,
      "role" : role,
      "discordTag" : discordTag,
      "location" : location
    };
    var response = await http.post('/app/events/createTeam',
        data: formData
    );

    return response.data;
  }

  static Future<Response> joinTeam(int eventId,String code,String role, String discordTag) async {
    var formData = {
      "matchId" : eventId,
      "code" : code,
      "role" : role,
      "discordTag" : discordTag,
    };
    var response = await http.post('/app/events/joinTeam',
        data: formData
    );
    return response;
  }

  static Future<MatchTeamModel> myTeam(int id) async {
    var response = await http.get('/app/team/myTeam',
        queryParameters: ({"matchId":id})
    );
    return MatchTeamModel.fromJson(response.data);
  }
}