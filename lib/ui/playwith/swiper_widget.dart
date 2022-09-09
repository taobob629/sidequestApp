import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/widget/custom_scroll_physics.dart';
import 'package:wy/widget/paixs_widget.dart';

///轮播图小组件
class SwiperWidget extends StatefulWidget {
  final double height;
  final double radius;
  final List<dynamic> imageList;

  const SwiperWidget({Key? key, this.height = 200, this.imageList = const [], this.radius = 8.0}) : super(key: key);
  @override
  _SwiperWidgetState createState() => _SwiperWidgetState();
}

class _SwiperWidgetState extends State<SwiperWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          StreamBuilder(builder: (context, v) {
            return Swiper(
              autoplay: !true,
              onIndexChanged: (i) => setState(() => index = i),
              autoplayDelay: 5000,
              curve: Curves.easeOutCubic,
              duration: 500,
              // pagination: SwiperPagination(
              //   builder: DotSwiperPaginationBuilder(
              //     size: 6,
              //     activeSize: 8,
              //     color: Colors.white,
              //     activeColor: Theme.of(context).primaryColor,
              //   ),
              // ),
              itemCount: widget.imageList.length,
              physics: PagePhysics(),
              // onTap: (i) => jumpPage(
              //   PhotoView(images: widget.imageList, index: i),
              // ),
              itemBuilder: (_, i) {
                // return SwiperImageWidget(imageList: widget.imageList, i: i);
                if (widget.imageList[i] == '')
                  return Image.asset(
                    'assets/images/play_bg.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: widget.height,
                  );
                return CachedNetworkImage(
                  imageUrl: widget.imageList[i],
                  height: widget.height,
                );
              },
            );
          }),
          PWidget.row(
            List.generate(widget.imageList.length, (i) {
              return PWidget.container(PWidget.boxh(0), [8, 8, Colors.white.withOpacity(index == i ? 1 : 0.25)], {'br': 8, 'mg': 4});
            }),
            '221',
          ),
          // PWidget.positioned(
          //   PWidget.container(
          //     PWidget.text('${index + 1}/${widget.imageList.length}', [Colors.white]),
          //     [null, null, Colors.black26],
          //     {'br': 56, 'pd': PFun.lg(2, 2, 12, 12)},
          //   ),
          //   [null, 12, null, 12],
          // ),
        ],
      ),
    );
  }
}

class SwiperImageWidget extends StatefulWidget {
  final List<dynamic> imageList;
  final int? i;

  const SwiperImageWidget({Key? key, this.imageList = const [], this.i}) : super(key: key);

  @override
  _SwiperImageWidgetState createState() => _SwiperImageWidgetState();
}

class _SwiperImageWidgetState extends State<SwiperImageWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CachedNetworkImage(
      imageUrl: widget.imageList[widget.i!],
      height: 200,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
