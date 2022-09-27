/*
  num_utils
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
/*
 *要求大于1
 */
bool isValidateAmount(var amount,int compareNum) {
  var num;
  try {
    num = double.parse(amount.toString());
    return num >= compareNum;
  } catch (e) {
    return false;
  }
}
