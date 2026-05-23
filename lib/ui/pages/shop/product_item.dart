import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/shop/product/product_page.dart';

import '../../../common/colorful_button.dart';
import '../../../controller/cart_controller.dart';
import '../../../model/product_item_model.dart';

class ProductItem extends StatelessWidget {

  final ProductItemModel product;
  ProductItem(this.product);

  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => ProductPage(productId: product.id),
        transition: Transition.noTransition,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 280/349,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Color(0xFF1F1D30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,top: 0,right: 0,bottom: 0,
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 8),
                      child: Offstage(
                        offstage: product.hot == false,
                        child: Image.asset("assets/images/ic_fire.webp",height: 20,)
                      )
                    )
                  ),
                ],
              )
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontFamily: "DIN",fontSize: 18),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "£${product.price}",
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontFamily: "DIN",fontSize: 25),
                ),
              ),
              ColorfulButton(
                height: 26,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "+ ${'Cart'.tr}",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                onTap: () {
                  controller.addProduct(product);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
