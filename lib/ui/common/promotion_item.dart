import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wy/model/promotion_item_model.dart';
import 'package:wy/utils/navigator_helper.dart';

class PromotionItem extends StatelessWidget {
  final PromotionItemModel model;

  PromotionItem({required this.model});

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery
      .of(context)
      .size
      .width - 30) * 2 / 7;
    return GestureDetector(
      onTap: ()=>NavigatorHelper.gotoConfigTarget(model.content),
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Color(0xFF28253D),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: model.image, fit: BoxFit.cover, height: height,width: double.infinity,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Text(
                model.title,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white,fontSize: 16),
              ),
            )
          ],
        ),
      )
    );
  }

  /*

  CachedNetworkImage(
        imageUrl: model.image,
        imageBuilder: (context, provider){
          return Container(
            height: height,
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Color(0xFF28253D),
              image: DecorationImage(image: provider,fit: BoxFit.cover)
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: 32,
                color: Colors.black38,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    model.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white,fontSize: 16),
                  )
                ),
              ),
            ),
          );
        },
      )
   */
}