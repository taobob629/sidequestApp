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
bool isValidateAmount(var amount) {
  var num;
  try {
    num = double.parse(amount.toString());
    return num >= 1;
  } catch (e) {
    return false;
  }
}
