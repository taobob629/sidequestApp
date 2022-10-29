import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/my_bouncing_scroll_physics.dart';
import 'package:wy/widget/photo_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

class PhotoWallWidget extends StatefulWidget {
  final List<String> imageList;
  final bool isPage;
  const PhotoWallWidget(this.imageList, {Key? key, this.isPage = false}) : super(key: key);
  @override
  _PhotoWallWidgetState createState() => _PhotoWallWidgetState();
}

class _PhotoWallWidgetState extends State<PhotoWallWidget> {
  List<String> imageList = [];

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    imageList = widget.imageList;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPage) {
      return ScaffoldWidget(
        appBar: AppBar(title: Text('Album'), elevation: 0),
        body: MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          physics: MyBouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.zero,
          itemCount: imageList.length,
          itemBuilder: (context, i) {
            return AspectRatio(
              aspectRatio: 3 / 4,
              child: GestureDetector(
                child: CachedNetworkImage(imageUrl: imageList[i], fit: BoxFit.cover),
                onTap: () => Get.to(() => PhotoView(images: imageList, index: i)),
              ),
            );
          },
        ),
      );
    }
    flog(imageList.length);
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: List.generate(imageList.length.clamp(0, 4), (i) {
        var url = imageList[i];
        return StaggeredGridTile.count(
          crossAxisCellCount: [
            //1张
            [4, 2, 3, 4][i],
            //2张
            [2, 2, 3, 4][i],
            //3张
            [2, 2, 2, 4][i],
            //4张
            [2, 2, 2, 4][i],
          ][(imageList.length - 1).clamp(0, 3)],
          mainAxisCellCount: [
            //1张
            [3, 1, 3, 4][i],
            //2张
            [2, 2, 3, 4][i],
            //3张
            [3, 1.5, 1.5, 4][i],
            //4张
            [3, 1.5, 1.5, 2][i],
          ][(imageList.length - 1).clamp(0, 3)],
          child: GestureDetector(
            onTap: () => Get.to(() => PhotoView(images: imageList, index: i)),
            child: ClipRRect(child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover), borderRadius: BorderRadius.circular(4)),
          ),
        );
      }),
    );
  }
}
