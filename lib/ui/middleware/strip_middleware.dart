/*
  strip_middleware
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:get/get.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/utils/utils.dart';

class StripMiddleWare extends GetMiddleware {
  var action;

  StripMiddleWare({this.action = AppConfig.ACTION_DEFAULT});

  @override
  int? priority = 0;

  @override
  void onPageDispose() {
    //  flog('onPageDispose==');
    AppConfig.init('default', action: AppConfig.ACTION_DEFAULT);
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    //  flog('onPageCalled==');
    AppConfig.init('default', action: action);
    return page;
  }
}
