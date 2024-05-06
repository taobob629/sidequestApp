import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/address_model.dart';
import '../../../../common/dash_separator.dart';

class DefaultAddress extends StatelessWidget {

  final bool selectable;

  final AddressModel addressModel;

  final Function? selectAddress;

  DefaultAddress({
    required this.addressModel,
    this.selectable = false,
    this.selectAddress
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>selectAddress?.call(),
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfo(),
                Spacer(),
                Offstage(
                  offstage: !selectable,
                  child: Icon(Icons.arrow_forward_ios_rounded,size: 26, color: Colors.white,)
                )
              ],
            ),
            SizedBox(height: 10,),
            Text(
              "${addressModel.email}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            Text(
              "${addressModel.line1} ${addressModel.line2} ${addressModel.city} ${addressModel.postCode}",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DashSeparator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(){
    if(addressModel.id == 0){
      return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          "Please add your shipping address".tr,
          style: TextStyle(
            color: Color(0xFFEC5D00),
            fontSize: 18,
          ),
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          "${addressModel.firstName} ${addressModel.lastName} ${addressModel.phone}",
          style: TextStyle(
            color: Color(0xFFEC5D00),
            fontSize: 24,
            fontFamily: "DIN"
          ),
        ),
      );
    }
  }
}