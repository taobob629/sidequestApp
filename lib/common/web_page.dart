import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/toast_utils.dart';
import '../utils/storage_manager.dart';

class WebPage extends StatelessWidget {
  final String? title;
  final String? url;
  late final WebPageController webPageController;

  WebPage({required this.title, required this.url}){
    webPageController = Get.put(WebPageController(url: url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebView(
            initialUrl: "$url?X-Wanyoo-Token=${StorageManager.getToken()}&samesite=None&secure=true&language=${Get.locale?.languageCode}",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              webPageController.setWebViewController(webViewController);
            },
            onPageStarted: (url) {
              String cookie = '''
                document.cookie = 'X-Wanyoo-Token=${StorageManager.getToken()};samesite=None; secure=true;language=${Get.locale?.languageCode}';
              ''';
              webPageController.webViewController.runJavascript(cookie);
            },
            onPageFinished: (url) {
              dismissLoading();
            },
            onWebResourceError: (error) {
              dismissLoading();
            },
          ),
          SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.back(),
              child: Container(
                width: 30.w,
                height: 30.w,
                margin: EdgeInsets.only(left: 15.w),
                decoration: ShapeDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: const OvalBorder(),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WebPageController extends GetxController{
  final String? url;
  late WebViewController webViewController;
  WebPageController({required this.url});

  void setWebViewController(WebViewController webViewController){
    this.webViewController = webViewController;
  }

  @override
  void onReady() {
    super.onReady();
    showLoading();
  }
}
