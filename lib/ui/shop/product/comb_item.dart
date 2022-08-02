import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/model/product_item_model.dart';

import 'product_page.dart';

class CombItem extends StatelessWidget {

  final ProductItemModel productItemModel;

  CombItem({required this.productItemModel});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Get.to(()=>ProductPage(productId: productItemModel.id),preventDuplicates: false),
      child: Container(
        height: 95,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF28253D),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 95,
              child: CachedNetworkImage(
                imageUrl: productItemModel.image,
                fit: BoxFit.cover,
              )
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "${productItemModel.name}",
                      maxLines: 2,
                      style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: "DIN"),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "price: £ ${productItemModel.price}",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white54,fontSize: 12),
                        )
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}