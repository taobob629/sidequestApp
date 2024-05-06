import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/shop/product/product_page.dart';

import '../../../../model/product_item_model.dart';

class RecommendItem extends StatelessWidget {

  final ProductItemModel productItemModel;

  RecommendItem({required this.productItemModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>ProductPage(productId: productItemModel.id),preventDuplicates: false);
        },
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: productItemModel.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}