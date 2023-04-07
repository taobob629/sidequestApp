import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CsPhotoViewer extends StatelessWidget {
  CsPhotoViewer({Key? key, this.photoList = const []}) : super(key: key);
  List<String> photoList = [];
  PageController? _pageController = PageController();
  @override
  Widget build(BuildContext context) {
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
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CupertinoActivityIndicator(),
          ),
        ),
        // backgroundDecoration: widget.backgroundDecoration,
        pageController: _pageController,
        // onPageChanged: onPageChanged,
      )),
    );
  }
}
