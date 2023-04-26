import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/model/news_item_model.dart';
import 'package:wy/ui/index/news/news_page.dart';
import 'package:wy/common/string_ext.dart';

class NewsItem extends StatelessWidget {
  final NewsItemModel model;

  NewsItem(this.model);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: ()=>Get.to(()=>NewsPage(id: model.id,)),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Color(0xFF28253D)
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  model.addtime.toDateStr,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                Spacer(),
                Text(
                  "News".tr,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                Container(
                  width: 2,
                  height: 12,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(1), color: Colors.white),
                )
              ],
            ),
            SizedBox(width: 15,height: 15,),
            _buildContent()
          ],
        ),
      ),
    );
  }

  Widget _buildContent(){
    if(model.imageList.length >= 3){
      return _buildMultipleImageItem();
    }else if(model.imageList.length >= 1) {
      return _buildSingleImageItem();
    }else {
      return _buildNoImageItem();
    }
  }

  Widget _buildMultipleImageItem(){
    return Column(
      children: [
        Text(
          model.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white,fontSize: 16),
        ),
        SizedBox(width: 10,height: 10,),
        Row(
          children: _buildImageList(),
        )
      ],
    );
  }

  List<Widget> _buildImageList(){
    List<Widget> list = [];
    for(int i = 0; i < 3; i++){
      String img = model.imageList[i];
      list.add(Expanded(
        child: AspectRatio(
          aspectRatio: 10 / 7,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(img,fit: BoxFit.cover)
            // child: CachedNetworkImage(
            //   imageUrl: img,
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
      ));
      if(i < 2) {
        list.add(SizedBox(width: 10,height: 10,));
      }
    }
    return list;
  }

  Widget _buildSingleImageItem(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            model.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.white,fontSize: 16),
          ),
        ),
        SizedBox(width: 10,height: 10,),
        Expanded(
          flex: 1,
          child: AspectRatio(
            aspectRatio: 10/7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(model.imageList[0],fit: BoxFit.cover),
              // child: CachedNetworkImage(
              //   imageUrl: model.imageList[0],
              //   fit: BoxFit.cover,
              // ),
            ),
          )
        )
      ],
    );
  }

  Widget _buildNoImageItem(){
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            model.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.white,fontSize: 16),
          ),
        ),
      ],
    );
  }
}