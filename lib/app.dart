import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/ui/pages/main_page.dart';
import 'package:sq_hub_app/widget/custom_error_widget.dart';
import 'package:sq_hub_app/widget/custom_loading_widget.dart';
import 'package:sq_hub_app/widget/custom_success_widget.dart';
import 'package:sq_hub_app/widget/custom_warn_widget.dart';

import 'config/app_color.dart';
import 'config/app_config.dart';
import 'config/controller/bindings.dart';
import 'config/icon_font.dart';
import 'config/lang/translations.dart';
import 'controller/cart_controller.dart';
import 'controller/user_controller.dart';

class App extends StatelessWidget {
  final cartController = Get.put(CartController(), permanent: true);

  final userController = Get.put(UserController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //只能纵向
      DeviceOrientation.portraitDown, //只能纵向
    ]);
    final ThemeData theme = ThemeData(fontFamily: FONT_LIGHT);

    return RefreshConfiguration(
        headerBuilder: () => const WaterDropHeader(
          waterDropColor: AppColor.whiteGray,
        ),
        footerBuilder: () => const ClassicFooter(
          noDataText: "",
        ),
        enableLoadingWhenFailed: true,
        hideFooterWhenNotFull: !true,
        enableBallisticLoad: true,
        child: ScreenUtilInit(
          // designSize: const Size(360, 690),
          designSize: const Size(375, 812),

          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              initialBinding: InitialBindings(),
              // useInheritedMediaQuery: true,
              debugShowCheckedModeBanner: false,
              navigatorKey: AppConfig.navigatorKey,
              theme: theme.copyWith(
                  textTheme: const TextTheme(),
                  appBarTheme: AppBarTheme(backgroundColor: AppColor.primary, elevation: 0, centerTitle: true, titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: FONT_MEDIUM)),
                  // primaryColor: AppColor.accent,
                  unselectedWidgetColor: Colors.white,
                  scaffoldBackgroundColor: AppColor.background,
                  primaryIconTheme: IconThemeData(color: AppColor.iconColorPrimary),
                  colorScheme: theme.colorScheme.copyWith(
                    primary: AppColor.primary,
                    secondary: AppColor.accent,
                    onSecondary: AppColor.accent,
                  )),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('zh', 'CN'),
              ],
              // locale: DevicePreview.locale(context),
              translations: Messages(),
              //跟随系统语言
              fallbackLocale: const Locale('en', 'US'),
              home: MainPage(),
              navigatorObservers: [FlutterSmartDialog.observer],
              builder: FlutterSmartDialog.init(
                loadingBuilder: (String msg) => CustomLoadingWidget(
                  color: Colors.white,
                  size: 40.sp,
                ),
                notifyStyle: FlutterSmartNotifyStyle(
                  successBuilder: (String msg) => CustomSuccessWidget(msg),
                  warningBuilder: (String msg) => CustomWarnWidget(msg),
                  errorBuilder: (String msg) => CustomErrorWidget(msg),
                ),
              ),
            );
          },
        ));
  }
}
