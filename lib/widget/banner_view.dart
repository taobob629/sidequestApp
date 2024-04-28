import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../model/banner_model.dart';
import '../utils/navigator_helper.dart';

class BannerView extends StatelessWidget {

  final List<BannerModel> banners;

  BannerView({required this.banners}){
    banners.forEach((element) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Swiper(
        autoplay: false,
        itemBuilder: (BuildContext context, int index) {
          String url = banners[index].image;
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
            ),
            child: ExtendedImage.network(
              url,
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: banners.length,
        pagination: SwiperPagination(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 10)
        ),
        onTap: (index) async{
          String content = banners[index].content;
          NavigatorHelper.gotoConfigTarget(content);
        },
      )
    );
  }
}