import 'package:wy/model/match_init_model.dart';

class SendMatchModel {
  SendMatchModel({
    required this.types,
    required this.gid,
    required this.category,
    required this.language,
    required this.optional,
    required this.orderId,
    required this.unit,
    required this.game,
    required this.minPrice,
    required this.maxPrice,
    required this.tags,
  });

  int gid;
  String category;
  String game;
  String minPrice;
  String maxPrice;
  String unit;
  String language;
  String types;
  String optional;
  int orderId;
  List<Language> tags;
}
