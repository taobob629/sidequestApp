import 'package:wy/api/wy_http.dart';
import 'package:wy/model/address_model.dart';

class AddressApi{

  static Future<List<AddressModel>> list() async {
    var response = await http.get('/app/address/list',
      queryParameters: ({})
    );
    List<AddressModel> list = response.data
      .map<AddressModel>((item) => AddressModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<void> save(AddressModel model) async {
    var formData = {
      "id" : model.id,
      "firstName" : model.firstName,
      "lastName" : model.lastName,
      "phone" : model.phone,
      "email" : model.email,
      "line1" : model.line1,
      "line2" : model.line2,
      "postCode" : model.postCode,
      "city" : model.city,
      "useDefault" : model.useDefault,
    };
    var response = await http.post('/app/address/save',
      data: formData
    );
  }

  static Future<void> delete(int id) async {
    await http.delete('/app/address/delete/$id');
  }
}