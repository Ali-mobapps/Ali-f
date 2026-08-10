import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:upzet/helper/services/url_service.dart';
import 'package:upzet/helper/theme/theme_customizer.dart';
import 'package:upzet/helper/utils/ui_mixins.dart';
import 'package:upzet/helper/utils/my_shadow.dart';
import 'package:upzet/helper/widgets/my_card.dart';
import 'package:upzet/helper/widgets/my_spacing.dart';
import 'package:upzet/helper/widgets/my_text.dart';
import 'package:upzet/images.dart';
import 'package:upzet/views/layout/widget/menu_item.dart';
import 'package:upzet/views/layout/widget/menu_widget.dart';
import 'package:upzet/views/layout/widget/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:remixicon/remixicon.dart';

class LeftBar extends StatefulWidget {
  final bool isCondensed;

  const LeftBar({super.key, this.isCondensed = false});

  @override
  State<LeftBar> createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> with SingleTickerProviderStateMixin, UIMixin {
  final ThemeCustomizer customizer = ThemeCustomizer.instance;

  bool isCondensed = false;
  String path = UrlService.getCurrentUrl();

  @override
  Widget build(BuildContext context) {
    isCondensed = widget.isCondensed;
    return MyCard(
      paddingAll: 0,
      shadow: MyShadow(position: MyShadowPosition.centerRight, elevation: 0.2),
      child: AnimatedContainer(
        color: leftBarTheme.background,
        width: isCondensed ? 70 : 255,
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed('/dashboard');
                    },
                    child: Image.asset(
                      (widget.isCondensed
                          ? (customizer.leftBarTheme == ThemeMode.system ? Images.logoSmDark : Images.logoSmLight)
                          : (customizer.leftBarTheme == ThemeMode.system ? Images.logoDark : Images.logoLight)),
                      height: widget.isCondensed ? 28 : 24,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView(
                  shrinkWrap: true,
                  controller: ScrollController(),
                  physics: BouncingScrollPhysics(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [
                    labelWidget("menu"),
                    MySpacing.height(12),
                    NavigationItem(iconData: MdiIcons.homeVariantOutline, title: "Dashboard", isCondensed: isCondensed, route: '/dashboard'),
                    NavigationItem(iconData: MdiIcons.calendarOutline, title: "Calendar", isCondensed: isCondensed, route: '/app/calendar'),
                    MenuWidget(
                      iconData: MdiIcons.emailOutline,
                      isCondensed: isCondensed,
                      title: "Email",
                      children: [
                        MenuItem(title: 'Inbox', route: '/email/inbox', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Read Email', route: '/email/read', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Email Compose', route: '/email/compose', isCondensed: widget.isCondensed),
                      ],
                    ),
                    MySpacing.height(12),
                    labelWidget("pages"),
                    MySpacing.height(12),
                    MenuWidget(
                      iconData: MdiIcons.accountCircleOutline,
                      isCondensed: isCondensed,
                      title: "Authentication",
                      children: [
                        MenuItem(title: 'Sign In', route: '/auth/login', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Sign Up', route: '/auth/sign_up', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Reset Password', route: '/auth/recover_password', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Lock Screen', route: '/auth/lock', isCondensed: widget.isCondensed),
                      ],
                    ),
                    MenuWidget(
                      iconData: MdiIcons.formatPageBreak,
                      isCondensed: isCondensed,
                      title: "Utilities",
                      children: [
                        MenuItem(title: 'Starter Page', route: '/utilities/starter', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Maintenance', route: '/utilities/maintenance', isCondensed: widget.isCondensed),
                        MenuItem(title: 'ComingSoon', route: '/utilities/coming_soon', isCondensed: widget.isCondensed),
                        MenuItem(title: 'TimeLine', route: '/utilities/time_line', isCondensed: widget.isCondensed),
                        MenuItem(title: 'FAQs', route: '/utilities/faqs', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Pricing', route: '/utilities/pricing', isCondensed: widget.isCondensed),
                        MenuItem(title: '404 Error', route: '/utilities/page-404', isCondensed: widget.isCondensed),
                        MenuItem(title: '500 Error', route: '/utilities/page-500', isCondensed: widget.isCondensed),
                      ],
                    ),
                    MySpacing.height(12),
                    labelWidget("component"),
                    MySpacing.height(12),
                    MenuWidget(
                      iconData: MdiIcons.briefcaseVariant,
                      isCondensed: isCondensed,
                      title: "Base UI",
                      children: [
                        MenuItem(title: 'Accordion', route: '/components/accordions', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Alerts', route: '/components/alerts', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Avatars', route: '/components/avatar', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Buttons', route: '/components/button', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Badges', route: '/components/badges', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Breadcrumb', route: '/components/breadcrumb', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Card', route: '/components/card', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Carousel', route: '/components/carousel', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Collapse', route: '/components/collapse', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Dropdown', route: '/components/dropdown', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Embed Video', route: '/components/embed_video', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Links', route: '/components/links', isCondensed: widget.isCondensed),
                        MenuItem(title: 'List Group', route: '/components/list_group', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Modals', route: '/components/modals', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Notifications', route: '/components/notification', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Placeholders', route: '/components/placeholders', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Pagination', route: '/components/pagination', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Progress', route: '/components/progress', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Spinner', route: '/components/spinner', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Tabs', route: '/components/tab', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Tooltips', route: '/components/tooltip', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Typography', route: '/components/typography', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Utilities', route: '/components/utilities', isCondensed: widget.isCondensed),
                      ],
                    ),
                    MenuWidget(
                      iconData: RemixIcons.bar_chart_2_line,
                      isCondensed: isCondensed,
                      title: "Advanced UI",
                      children: [
                        MenuItem(title: 'Range Slider', route: '/extended_ui/range_slider', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Scrollbar', route: '/extended_ui/scrollbar', isCondensed: widget.isCondensed),
                        MenuItem(title: 'Portlets', route: '/extended_ui/portlets', isCondensed: widget.isCondensed),
                      ],
                    ),
                    MenuWidget(
                      iconData: RemixIcons.pencil_ruler_2_line,
                      isCondensed: isCondensed,
                      title: "Icons",
                      children: [MenuItem(title: 'Remix Icon', route: '/icon/remix_icon', isCondensed: widget.isCondensed)],
                    ),
                    NavigationItem(iconData: RemixIcons.bar_chart_line, title: "Charts", isCondensed: isCondensed, route: '/chart'),
                    MenuWidget(
                      iconData: RemixIcons.survey_line,
                      isCondensed: isCondensed,
                      title: "Forms",
                      children: [
                        MenuItem(title: "Basic Element", route: '/forms/basic_element', isCondensed: widget.isCondensed),
                        MenuItem(title: "Form Validation", route: '/forms/validation', isCondensed: widget.isCondensed),
                        MenuItem(title: "File Uploads", route: '/forms/file_upload', isCondensed: widget.isCondensed),
                        MenuItem(title: "Form Editors", route: '/forms/form_editors', isCondensed: widget.isCondensed),
                        MenuItem(title: "X Editable", route: '/forms/x_editable', isCondensed: widget.isCondensed),
                        MenuItem(title: "Form Wizard", route: '/forms/form_wizard', isCondensed: widget.isCondensed),
                      ],
                    ),
                    NavigationItem(iconData: RemixIcons.table_line, title: "Table", isCondensed: isCondensed, route: '/table'),
                    NavigationItem(iconData: RemixIcons.map_line, title: "Maps", isCondensed: isCondensed, route: '/maps'),
                    MySpacing.height(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget labelWidget(String label) {
    return isCondensed
        ? MySpacing.empty()
        : Container(
            padding: MySpacing.x(24),
            child: MyText.labelSmall(
              label.toUpperCase(),
              color: leftBarTheme.labelColor,
              muted: true,
              maxLines: 1,
              overflow: TextOverflow.clip,
              fontWeight: 700,
            ),
          );
  }
}
