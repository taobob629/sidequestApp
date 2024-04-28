import 'package:sq_hub_app/api/wy_http.dart';

import '../model/booking_model.dart';

class BookingApi  {
  static Future<List<BookingModel>> list() async {
    var response = await http.get('/app/booking/list',
      queryParameters: ({})
    );
    List<BookingModel> list = response.data
      .map<BookingModel>((item) => BookingModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<List<BookingSelectModel>> listStores() async {
    // var response = await http.get('/app/booking/stores',
    var response = await http.get('/app/booking/211/stores',
      queryParameters: ({})
    );
    List<BookingSelectModel> list = [];

    List<StoreModel> storeList = response.data
      .map<StoreModel>((item) => StoreModel.fromJson(item))
      .toList();

    storeList.forEach((element) {
      BookingSelectModel model = BookingSelectModel();
      model.id = element.id;
      model.name = element.name;
      model.model = element;
      list.add(model);
    });
    return list;
  }

  static Future<List<BookingSelectModel>> listAreas(int storeId) async {
    var response = await http.get('/app/booking/areas',
      queryParameters: ({"storeId":storeId})
    );
    List<BookingSelectModel> list = [];

    List<StoreAreaModel> areaList = response.data
      .map<StoreAreaModel>((item) => StoreAreaModel.fromJson(item))
      .toList();

    areaList.forEach((element) {
      BookingSelectModel model = BookingSelectModel();
      model.id = element.id;
      model.name = element.areaName;
      model.model = element;
      list.add(model);
    });
    return list;
  }

  static Future<void> reserve(BookingModel model) async {
    var formData = {
      "storeId" : model.storeId,
      "areaId" : model.areaId,
      "people" : model.people,
      "duration" : model.duration,
      "time" : model.time,
      "phone" : model.phone
    };
    await http.post('/app/booking/reserve',
      data: formData
    );
  }

  static Future<void> cancel(int id) async {
    await http.get('/app/booking/cancel',
      queryParameters: ({"bookid":id})
    );
  }
}