import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/model/booking_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';

class BookingItem extends StatelessWidget {

  final BookingModel model;
  final Function(int) onCancel;

  BookingItem({required this.model, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF28253D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            model.done ? Icons.alarm_off : Icons.alarm,
            color: model.done ? Colors.white54 : Colors.white,
            size: 30,
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${model.store}", style: TextStyle(fontSize: 20,fontFamily: "DIN",color: Colors.white),),
              Text("${model.area}", style: TextStyle(fontSize: 14,color: Colors.white),),
              SizedBox(height: 10,),
              Row(
                children: [
                  Image.asset("assets/images/ic_booking_time.webp",width: 12,),
                  SizedBox(width: 5,),
                  Text(
                    "${formatDate(DateTime.fromMillisecondsSinceEpoch(model.time*1000), [d, '/', M, '/', yyyy,' ',HH,':',nn,])}",
                    style: TextStyle(fontSize: 12,color: Colors.white),
                  ),
                  Container(
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.white24))
                    ),
                  ),
                  Image.asset("assets/images/ic_booking_game.webp",width: 16,),
                  SizedBox(width: 5,),
                  Text("${model.duration} H",style: TextStyle(fontSize: 12,color: Colors.white),),
                ],
              )
            ],
          ),
          Spacer(),
          Offstage(
            offstage: model.done,
            child: GestureDetector(
              onTap: (){
                Get.dialog(
                  ConfirmDialog(title: "Cancel Confirm".tr, info: "Do you confirm to cancel this booking?".tr),barrierColor: Colors.black26).then(
                    (value) {
                      if(value != null && value == true){

                      }
                    }
                );
              },
              child: GestureDetector(
                onTap: ()=>onCancel.call(model.id),
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}