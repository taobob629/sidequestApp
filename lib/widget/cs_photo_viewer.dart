import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wy/widget/views.dart';

class CsPhotoViewer extends StatelessWidget {
  CsPhotoViewer({Key? key, this.photoList = const [], this.tapIndex = 0}) : super(key: key);
  List<String> photoList = [];
  int tapIndex = 0;
  late PageController? _pageController;
  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: tapIndex);
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
          child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          var imgUrl = photoList[index];
          final image = imgUrl.contains("http") ? NetworkImage(imgUrl) : AssetImage(imgUrl);
          return PhotoViewGalleryPageOptions(
            imageProvider: image as ImageProvider,
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag: photoList[index]),
          );
        },
        itemCount: photoList.length,
        loadingBuilder: (context, event) => buildLoad(),
        // backgroundDecoration: widget.backgroundDecoration,
        pageController: _pageController,
        // onPageChanged: onPageChanged,
      )),
    );
  }
}
