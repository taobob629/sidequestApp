import 'dart:convert';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../utils/toast_utils.dart';
import '../api/pay_api.dart';
import '../model/coupon_model.dart';
import '../model/pay_order_model.dart';
import '../model/product_item_model.dart';
import '../utils/platform_utils.dart';
import '../utils/storage_manager.dart';
import '../utils/utils.dart';

class CartController extends GetxController {
  RxList<ProductItemModel> productList = RxList();

  Rx<CouponModel> coupon = CouponModel().obs;

  var shippingFee = 0.00.obs;

  var totalTax = 0.00.obs;

  var totalPrice = 0.00.obs;

  var totalAmount = 0.00.obs;

  var totalCount = 0.obs;

  var discount = 0.00.obs;

  @override
  void onInit() {
    super.onInit();
    if (Platform.isIOS) initInAppPay();
  }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  RxList<ProductDetails> _products = RxList<ProductDetails>([]);

  List<ProductDetails> get products => _products.value;

  set products(List<ProductDetails> value) {
    _products.value = value;
  }

  /**
   * 初始化内购商品列表
   */
  Future<void> initInAppPay() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    flog('isAvailable $isAvailable');
    if (!isAvailable) {}
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails([
      'coin_5',
      'coin_10',
      'coin_30',
      'coin_50',
      'coin_100',
      'coin_200',
      'VIP_4.99',
      'VIP_24.99',
      'VIP_44.99',
      'VIP_79.99',
    ].toSet());
    products = productDetailResponse.productDetails;
    // products.forEach((e) {
    //   flog("products" + e.price + ' id:${e.id} title ${e.title}');
    // });
    // products.clear();
    // products.addAll(products);
    flog(
        'products ${products} nofoundIds=${productDetailResponse.notFoundIDs}');
  }

  @override
  void onReady() async {
    super.onReady();
    String cart = StorageManager.getCart();
    if (cart.isNotEmpty) {
      List<ProductItemModel> list = json
          .decode(cart)
          .map<ProductItemModel>((item) => ProductItemModel.fromJson(item))
          .toList();
      list.forEach((element) {
        addProduct(element);
      });
    }
    _getTotalCount();
  }

  void addProduct(ProductItemModel product, {bool refreshPrice = false}) {
    if (productList.contains(product)) {
      productList.firstWhere((element) => element.id == product.id).count += 1;
    } else {
      ProductItemModel p =
          ProductItemModel.fromJson(jsonDecode(jsonEncode(product)));
      productList.add(p);
    }
    String newList = json.encode(productList);
    StorageManager.setCart(newList);
    _getTotalCount();
    if (refreshPrice) {
      getTotalAmount();
    }
  }

  void _removeProduct(ProductItemModel product) {
    if (productList.contains(product)) {
      productList.firstWhere((element) => element.id == product.id).count -= 1;
    } else {
      if (productList.remove(product)) {}
    }
    StorageManager.setCart(json.encode(productList));
    _getTotalCount();
    getTotalAmount();
  }

  void deleteProduct(int productId) {
    ProductItemModel product =
        productList.firstWhere((element) => element.id == productId);
    productList.remove(product);
    StorageManager.setCart(json.encode(productList));
    if (productId.toString() == coupon.value.productId) {
      coupon.value = CouponModel();
    }
    _getTotalCount();
    getTotalAmount();
  }

  void changeQuantity(int productId, int quantity) {
    ProductItemModel product =
        productList.firstWhere((element) => element.id == productId);
    if (quantity > product.count) {
      addProduct(product, refreshPrice: true);
    } else {
      _removeProduct(product);
    }
  }

  void clearCart() {
    productList.clear();
    coupon.value = CouponModel();
    StorageManager.setCart(json.encode(productList));
    shippingFee.value = 0.0;
    totalTax.value = 0.0;
    totalAmount.value = 0.0;
    totalCount.value = 0;
    discount.value = 0;
  }

  void _getTotalCount() {
    int count = 0;
    productList.forEach((element) {
      count += element.count;
    });
    totalCount.value = count;
  }

  int getProductCount(int productId) {
    for (ProductItemModel productItemModel in productList) {
      if (productItemModel.id == productId) {
        return productItemModel.count;
      }
    }
    return 0;
  }

  void getTotalAmount() async {
    // double amount = 0.0;
    // totalPrice.value = 0.0;
    // productList.forEach((element) {
    //   amount += (element.getTax() + element.getPrice()) * element.count;
    //   totalPrice.value += element.getPrice()*element.count;
    // });
    // totalAmount.value = amount + this.shippingFee.value;
    if (productList.isNotEmpty) {
      PayOrderModel payOrderModel = PayOrderModel();
      payOrderModel.type = -1;
      payOrderModel.couponId = coupon.value.id;
      payOrderModel.couponCode = coupon.value.couponCode;
      payOrderModel.orderShot = json.encode(productList);
      showLoading();
      OrderPriceModel orderPriceModel = await PayApi.getPrice(payOrderModel);
      dismissLoading();
      totalAmount.value = double.parse(orderPriceModel.total);
      totalTax.value = double.parse(orderPriceModel.tax);
      shippingFee.value = double.parse(orderPriceModel.deliveryFee);
      bool hasValue = discount.value > 0;
      discount.value = double.parse(orderPriceModel.discount);
      if (hasValue && discount.value == 0) {
        coupon.value = CouponModel();
      }
    } else {
      shippingFee.value = 0.0;
      totalTax.value = 0.0;
      totalAmount.value = 0.0;
      totalCount.value = 0;
      discount.value = 0;
      coupon.value = CouponModel();
    }
  }

  List<String> getProductIds() {
    List<String> ids = [];
    productList.forEach((element) {
      ids.add("${element.id}");
    });
    return ids;
  }

  void couponSelect(CouponModel model) {
    coupon.value = model;
    getTotalAmount();
  }

  void cancelCoupon() {
    coupon.value = CouponModel();
    getTotalAmount();
  }
}
