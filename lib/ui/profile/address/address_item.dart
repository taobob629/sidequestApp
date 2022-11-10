import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/address_model.dart';

class AddressItem extends StatelessWidget {

  final AddressModel address;
  final Function? onTap;
  final Function onEdit;

  AddressItem({
    required this.address,
    required this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>onTap?.call(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Color(0xFF28253D),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "${address.firstName} ${address.lastName}",
                      style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "DIN"),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "${address.phone}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Offstage(
                    offstage: !address.useDefault,
                    child: Container(
                      height: 17,
                      decoration: BoxDecoration(color: AppColor.accent, borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 1),
                      child: Text(
                        "Default".tr,
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: ()=> onEdit.call(),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.transparent,
                      child: Image.asset("assets/images/ic_edit.webp",width: 14,)
                    )
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0x08ffffff),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        address.email,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "${address.line1} ${address.line2} ${address.city} ${address.postCode}",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}