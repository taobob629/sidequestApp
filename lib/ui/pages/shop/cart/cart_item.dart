import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/quantity_selector.dart';
import '../../../../controller/cart_controller.dart';
import '../../../../model/product_item_model.dart';

class CartItem extends StatelessWidget {

  final ProductItemModel product;

  final controller = Get.find<CartController>();

  CartItem({required this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xff28253D),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: [
          Container(
            height: 105,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0x08ffffff),
            ),
            child: Row(
              children: [
                Offstage(
                  offstage: product.image.isEmpty,
                  child: Container(
                    width: 80,
                    height: 80,
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${product.name}",
                          maxLines: 2,
                          style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: Text("",style: TextStyle(color: Colors.white54,fontSize: 12),)),
                          QuantitySelector(
                            initValue: product.count,
                            tag: "${product.id}",
                            onQuantityChanged: (quantity)=>controller.changeQuantity(product.id, quantity),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "£ ${product.price}",
                    style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>controller.deleteProduct(product.id),
                  child: Image.asset("assets/images/ic_delete.webp",width: 26,)
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}