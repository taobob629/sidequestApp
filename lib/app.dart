import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/controller/cart_controller.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/storage_manager.dart';

import 'config/app_config.dart';
import 'config/lang/translations.dart';

class App extends StatelessWidget {
  final cartController = Get.put(CartController(), permanent: true);

  final userController = Get.put(UserController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //只能纵向
      DeviceOrientation.portraitDown, //只能纵向
    ]);
    final ThemeData theme = ThemeData();
    return RefreshConfiguration(
        // headerBuilder: () => WaterDropHeader(
        //   waterDropColor: AppColor.accent,
        // ),
        footerBuilder: () => ClassicFooter(
              noDataText: "",
            ),
        enableLoadingWhenFailed: true,
        hideFooterWhenNotFull: !true,
        enableBallisticLoad: true,
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: AppConfig.navigatorKey,
              theme: theme.copyWith(
                  primaryColor: AppColor.accent,
                  unselectedWidgetColor: Colors.white,
                  scaffoldBackgroundColor: AppColor.background,
                  colorScheme: theme.colorScheme.copyWith(
                    primary: AppColor.primary,
                    secondary: AppColor.accent,
                    secondaryVariant: AppColor.accent,
                    onSecondary: AppColor.accent,
                  )),
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', 'US'),
                const Locale('zh', 'CN'),
              ],
              locale: StorageManager.getLocal(),
              translations: Messages(),
              //跟随系统语言
              fallbackLocale: const Locale('en', 'US'),
              getPages: AppPages.routes,
              initialRoute: AppPages.Main,
              builder: EasyLoading.init(),
            );
          },
        ));
  }
}
