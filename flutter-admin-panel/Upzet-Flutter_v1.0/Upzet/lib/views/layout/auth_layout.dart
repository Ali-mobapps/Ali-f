import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:upzet/controller/layout/auth_layout_controller.dart';
import 'package:upzet/helper/utils/ui_mixins.dart';
import 'package:upzet/helper/widgets/my_container.dart';
import 'package:upzet/helper/widgets/my_flex.dart';
import 'package:upzet/helper/widgets/my_flex_item.dart';
import 'package:upzet/helper/widgets/my_responsive.dart';
import 'package:upzet/helper/widgets/my_spacing.dart';
import 'package:upzet/helper/widgets/my_text_style.dart';

class AuthLayout extends StatelessWidget with UIMixin {
  final Widget? child;

  final AuthLayoutController controller = AuthLayoutController();

  AuthLayout({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return MyResponsive(
      builder: (BuildContext context, _, screenMT) {
        return GetBuilder(
          init: controller,
          builder: (controller) {
            return screenMT.isMobile ? mobileScreen(context) : largeScreen(context);
          },
        );
      },
    );
  }

  Widget mobileScreen(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      body: Center(
        child: SingleChildScrollView(padding: MySpacing.x(24), key: controller.scrollKey, child: child),
      ),
    );
  }

  Widget largeScreen(BuildContext context) {
    final currentYear = DateFormat('y').format(DateTime.now());
    return Scaffold(
      key: controller.scaffoldKey,
      body: Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          Center(
            child: Image.asset('assets/bg.jpg', fit: BoxFit.cover, width: Get.width, height: Get.height),
          ),
          MyContainer(color: contentTheme.dark.withValues(alpha: 0.6)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyFlex(
                  wrapAlignment: WrapAlignment.center,
                  wrapCrossAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 0,
                  runSpacing: 0,
                  children: [MyFlexItem(sizes: "xxl-2.65 lg-4 md-6 sm-8", child: child ?? Container())],
                ),
                MySpacing.height(12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: MyTextStyle.bodyMedium(color: Colors.white54),
                    children: [
                      TextSpan(text: '© $currentYear Upzet. Crafted with '),
                      WidgetSpan(child: Icon(Icons.favorite, color: contentTheme.danger, size: 16)),
                      TextSpan(text: ' by Themesdesign'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
