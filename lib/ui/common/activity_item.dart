import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/model/activity_item_model.dart';
import 'package:wy/ui/events/event/event_page.dart';

class ActivityItem extends StatelessWidget {
  final ActivityItemModel model;

  ActivityItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Get.to(()=>EventPage(id: model.id, type: 1,)),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: model.inProgress ? Color(0xFF526EEB) : Color(0xFF28253D)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2/1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: model.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10,height: 15,),
            Row(
              children: [
                Text(model.time, style: TextStyle(fontSize: 12,color: Colors.white),),
                Spacer(),
                Text("Events", style: TextStyle(fontSize: 12,color: Colors.white),),
                Container(
                  width: 2,
                  height: 12,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white
                  ),
                )
              ],
            ),
            SizedBox(width: 10,height: 10,),
            Text(
              model.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white,fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}