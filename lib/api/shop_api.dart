import 'package:sq_hub_app/api/wy_http.dart';

import '../model/product_detail_model.dart';
import '../model/product_item_model.dart';
import '../model/shop_tab_model.dart';

class ShopApi {

  static Future<List<ShopTabModel>> tabs() async {
    var response = await http.get('/app/shop/tabs',
      queryParameters: ({})
    );
    List<ShopTabModel> list = response.data
      .map<ShopTabModel>((item) => ShopTabModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<List<ProductItemModel>> products(int tab, int pageNum, int pageSize) async {
    var response = await http.get('/app/shop/products',
      queryParameters: ({'tab' : tab, 'pageNum': pageNum,'pageSize' : pageSize})
    );
    //print(response.data);
    List<ProductItemModel> list = response.data
      .map<ProductItemModel>((item) => ProductItemModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<ProductDetailModel> getProductDetail(int id) async {
    var response = await http.get('/app/shop/product/detail/$id',
      queryParameters: ({})
    );
    return ProductDetailModel.fromJson(response.data);
  }

  static Future<List<ProductItemModel>> recommend(int productId) async {
    var response = await http.get('/app/shop/recommend',
      queryParameters: ({"id":productId})
    );
    List<ProductItemModel> list = response.data
      .map<ProductItemModel>((item) => ProductItemModel.fromJson(item))
      .toList();
    return list;
  }

  static Future<List<ProductItemModel>> search(String key) async {
    var response = await http.get('/app/shop/search',
      queryParameters: ({"key":key})
    );
    List<ProductItemModel> list = response.data
      .map<ProductItemModel>((item) => ProductItemModel.fromJson(item))
      .toList();
    return list;
  }
}