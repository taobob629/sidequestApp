import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/stores/tab_cybercafe_page.dart';
import 'package:sq_hub_app/ui/pages/stores/tab_top_products_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool _isLoaded = false;
  Widget? _content;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContent();
    });
  }

  void _loadContent() {
    if (!Get.isRegistered<CybercafeController>()) {
      Get.put(CybercafeController());
    }
    CybercafeController.find.onRefresh();

    setState(() {
      _content = SafeArea(
        bottom: true,
        child: Column(
          children: [
            Expanded(
              flex: 40,
              child: TabCybercafePage(),
            ),
            SizedBox(height: 10.h),
            Expanded(
              flex: 60,
              child: TabTopProductsPage(),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      );
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return Container(color: const Color(0xFF000000));
    }
    return Container(
      color: const Color(0xFF000000),
      child: _content,
    );
  }
}
