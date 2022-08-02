
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:wy/model/banner_model.dart' as custom;
import 'package:wy/utils/navigator_helper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class BannerView extends StatelessWidget {

  final List<custom.BannerModel> banners;

  BannerView({required this.banners}){
    banners.forEach((element) {
      DefaultCacheManager().downloadFile(element.image);
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
            child: CachedNetworkImage(
              imageUrl: url,
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
          // content = '{"type":"h5","target":"https://baidu.com","title":"Web page title"}';
          // content = '{"type":"page","target":"news","id":12}';
          // content = '{"type":"page","target":"product","id":4}';
          // content = '{"type":"page","target":"activity","id":4}';
          // content = '{"type":"page","target":"match","id":4}';
          // content = '{"type":"page","target":"booking"}';
          // content = '{"type":"page","target":"balance","amount":100}';
          NavigatorHelper.gotoConfigTarget(content);

          // AndroidNotificationDetails androidPlatformChannelSpecifics =
          // AndroidNotificationDetails('${DateTime.now()}', 'systemNotification',
          //   channelDescription: 'system notification',
          //   importance: Importance.max,
          //   priority: Priority.high,
          //   ticker: 'ticker');
          // NotificationDetails platformChannelSpecifics =
          // NotificationDetails(android: androidPlatformChannelSpecifics);
          // await AppConfig.flutterLocalNotificationsPlugin.show(
          //   0, 'plain title', 'plain body${DateTime.now()}', platformChannelSpecifics,
          //   payload: 'item x');

        },
      )
    );
  }
}