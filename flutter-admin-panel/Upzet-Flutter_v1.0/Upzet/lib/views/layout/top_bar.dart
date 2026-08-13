import 'package:provider/provider.dart';
import 'package:upzet/helper/localization/language.dart';
import 'package:upzet/helper/theme/app_notifier.dart';
import 'package:upzet/helper/theme/app_style.dart';
import 'package:upzet/helper/theme/theme_customizer.dart';
import 'package:upzet/helper/utils/ui_mixins.dart';
import 'package:upzet/helper/utils/my_shadow.dart';
import 'package:upzet/helper/widgets/my_button.dart';
import 'package:upzet/helper/widgets/my_card.dart';
import 'package:upzet/helper/widgets/my_container.dart';
import 'package:upzet/helper/widgets/my_spacing.dart';
import 'package:upzet/helper/widgets/my_text.dart';
import 'package:upzet/helper/widgets/my_text_style.dart';
import 'package:upzet/images.dart';
import 'package:upzet/widgets/custom_pop_menu.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with SingleTickerProviderStateMixin, UIMixin {
  Function? languageHideFn;
  bool isLeftBarCondensed = false;
  int isNotificationTab = 0;
  Function? hideFn;

  void leftBarCondensedToggle() {
    ThemeCustomizer.toggleLeftBarCondensed();
    isLeftBarCondensed = !isLeftBarCondensed;
    setState(() {});
  }

  void onChangeNotificationTabBar(int id) {
    isNotificationTab = id;
    setState(() {});
  }

  final GlobalKey _menuKey = GlobalKey();

  final List<Map<String, String>> apps = [
    {"name": "GitHub", "icon": "assets/brands/github.png"},
    {"name": "Bitbucket", "icon": "assets/brands/bitbucket.png"},
    {"name": "Dribbble", "icon": "assets/brands/dribbble.png"},
    {"name": "Dropbox", "icon": "assets/brands/dropbox.png"},
    {"name": "Mail Chimp", "icon": "assets/brands/mail_chimp.png"},
    {"name": "Slack", "icon": "assets/brands/slack.png"},
  ];

  final List<Map<String, dynamic>> notifications = [
    {'avatar': 'assets/users/avatar-1.jpg', 'text': 'Sally Bieber started following you. Check out their profile!'},
    {
      'avatar': null,
      'icon': Icons.person,
      'bgColor': Colors.blue,
      'title': 'Gloria Chambers',
      'text': "mentioned you in a comment: '@admin, check this out!'",
    },
    {'avatar': 'assets/users/avatar-3.jpg', 'title': 'Jacob Gines', 'text': "Answered to your comment on the cash flow forecast's graph 🔔."},
    {
      'avatar': null,
      'icon': Icons.system_update,
      'bgColor': Colors.orange,
      'text': 'A new system update is available. Update now for the latest features.',
    },
    {'avatar': 'assets/users/avatar-5.jpg', 'title': 'Shawn Bunch', 'text': "commented on your post: 'Great photo!'"},
  ];

  @override
  Widget build(BuildContext context) {
    return MyCard(
      shadow: MyShadow(position: MyShadowPosition.bottomRight, elevation: 0.5),
      height: 69,
      borderRadiusAll: 0,
      padding: MySpacing.x(32),
      color: topBarTheme.background.withAlpha(246),
      child: Row(
        children: [
          InkWell(
            splashColor: colorScheme.onSurface,
            highlightColor: colorScheme.onSurface,
            onTap: () => leftBarCondensedToggle(),
            child: Icon(RemixIcons.menu_2_line, color: topBarTheme.onBackground),
          ),
          MySpacing.width(16),
          SizedBox(
            width: 220,
            child: TextFormField(
              style: MyTextStyle.bodyMedium(),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                contentPadding: MySpacing.xy(20, 16),
                isCollapsed: true,
                isDense: true,
                filled: true,
                hintText: "Search...",
                hintStyle: MyTextStyle.bodyMedium(),
                prefixIcon: Icon(RemixIcons.search_line, size: 16),
                fillColor: topBarTheme.onBackground.withValues(alpha: 0.1),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomPopupMenu(
                  backdrop: true,
                  hideFn: (hideFn) {
                    languageHideFn = hideFn;
                    languageHideFn?.call();
                  },
                  onChange: (_) {},
                  offsetX: -36,
                  menu: Padding(
                    padding: MySpacing.xy(8, 8),
                    child: Center(
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(2),
                        child: Image.asset(
                          "assets/lang/${ThemeCustomizer.instance.currentLanguage.locale.languageCode}.jpg",
                          width: 24,
                          height: 18,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  menuBuilder: (_) => buildLanguageSelector(),
                ),

                MySpacing.width(24),
                IconButton(
                  key: _menuKey,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(RemixIcons.apps_2_line),
                  onPressed: () => _showDropdown(context),
                ),
                MySpacing.width(24),
                Icon(RemixIcons.fullscreen_line, size: 20, color: topBarTheme.onBackground),
                MySpacing.width(24),
                CustomPopupMenu(
                  backdrop: true,
                  onChange: (_) {},
                  offsetX: -200,
                  offsetY: 21,
                  menu: Icon(RemixIcons.notification_3_line, size: 20),
                  menuBuilder: (_) => _buildNotificationIcon(),
                ),
                MySpacing.width(24),
                InkWell(
                  onTap: () {},
                  child: Icon(RemixIcons.settings_4_line, size: 20, color: topBarTheme.onBackground),
                ),
                MySpacing.width(24),
                CustomPopupMenu(
                  backdrop: true,
                  onChange: (_) {},
                  offsetX: -100,
                  offsetY: 0,
                  menu: Row(
                    children: [
                      MyContainer.rounded(paddingAll: 0, child: Image.asset(Images.users[1], height: 28, width: 28, fit: BoxFit.cover)),
                      MySpacing.width(12),
                      MyText.bodyMedium('Kevin',fontWeight: 600,muted: true)
                    ],
                  ),
                  menuBuilder: (_) => buildAccountMenu(),
                  hideFn: (hide) => languageHideFn = hide,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLanguageSelector() {
    return MyContainer.bordered(
      padding: MySpacing.xy(8, 8),
      width: 125,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: Language.languages
            .map(
              (language) => MyButton.text(
                padding: MySpacing.xy(8, 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashColor: contentTheme.onBackground.withAlpha(20),
                onPressed: () async {
                  languageHideFn?.call();
                  await Provider.of<AppNotifier>(context, listen: false).changeLanguage(language, notify: true);
                  ThemeCustomizer.notify();
                  setState(() {});
                },
                child: Row(
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius: BorderRadius.circular(2),
                      child: Image.asset("assets/lang/${language.locale.languageCode}.jpg", width: 18, height: 14, fit: BoxFit.cover),
                    ),
                    MySpacing.width(8),
                    MyText.labelMedium(language.languageName),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return MyContainer(
      paddingAll: 0,
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MySpacing.x(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText.bodyMedium("Notifications", fontWeight: 600),
                MyButton.text(
                  padding: MySpacing.xy(8, 12),
                  onPressed: () => hideFn?.call(),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: MyText.labelSmall("Clear All", xMuted: true, decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          MyContainer(
            height: 300,
            paddingAll: 0,
            child: ListView.separated(
              itemCount: notifications.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return MyButton(
                  backgroundColor: Colors.transparent,
                  msBackgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  onPressed: () {},
                  padding: MySpacing.zero,
                  msPadding: WidgetStatePropertyAll(MySpacing.zero),
                  splashColor: contentTheme.light.withValues(alpha: 0.4),
                  child: Padding(
                    padding: MySpacing.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyContainer.rounded(
                          height: 36,
                          width: 36,
                          paddingAll: 0,
                          color: contentTheme.background,
                          child: notification['avatar'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(36),
                                  child: Image.asset(notification['avatar']!, fit: BoxFit.cover),
                                )
                              : Center(
                                  child: notification['name'] == null
                                      ? Icon(notification['icon'], size: 16, color: notification['bgColor'])
                                      : MyText.titleMedium(notification['name']![0].toUpperCase(), color: contentTheme.primary),
                                ),
                        ),
                        MySpacing.width(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (notification['title'] != null) MyText.bodyMedium(notification['title'] ?? "", fontWeight: 600),
                              if (notification['title'] != null) MySpacing.height(4),
                              MyText.bodySmall(notification['text'] ?? ""),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(height: 0),
            ),
          ),
          Divider(height: 0),
          SizedBox(
            height: 60,
            child: Center(
              child: MyButton.small(
                onPressed: () => hideFn?.call(),
                elevation: 0,
                padding: MySpacing.all(8),
                backgroundColor: contentTheme.primary,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText.labelMedium("View all notification", fontWeight: 600, color: contentTheme.onPrimary),
                    MySpacing.width(8),
                    Icon(RemixIcons.arrow_right_line, size: 16, color: contentTheme.onPrimary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAccountMenu() {
    return MyContainer(
      borderRadiusAll: 8,
      width: 160,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyButton(
            onPressed: () => {},
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            borderRadiusAll: AppStyle.buttonRadius.medium,
            padding: MySpacing.xy(8, 4),
            splashColor: colorScheme.onSurface.withAlpha(20),
            backgroundColor: Colors.transparent,
            child: Row(
              children: [
                Icon(RemixIcons.user_line, size: 14, color: contentTheme.onBackground),
                MySpacing.width(8),
                MyText.labelMedium("Profile", fontWeight: 600),
              ],
            ),
          ),
          MySpacing.height(8),
          MyButton(
            onPressed: () => {},
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            borderRadiusAll: AppStyle.buttonRadius.medium,
            padding: MySpacing.xy(8, 4),
            splashColor: colorScheme.onSurface.withAlpha(20),
            backgroundColor: Colors.transparent,
            child: Row(
              children: [
                Icon(RemixIcons.wallet_line, size: 14, color: contentTheme.onBackground),
                MySpacing.width(8),
                MyText.labelMedium("My Wallet", fontWeight: 600),
              ],
            ),
          ),
          MySpacing.height(8),
          MyButton(
            onPressed: () => {},
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            borderRadiusAll: AppStyle.buttonRadius.medium,
            padding: MySpacing.xy(8, 4),
            splashColor: colorScheme.onSurface.withAlpha(20),
            backgroundColor: Colors.transparent,
            child: Row(
              children: [
                Icon(RemixIcons.lock_line, size: 14, color: contentTheme.onBackground),
                MySpacing.width(8),
                MyText.labelMedium("Lock Screen", fontWeight: 600),
              ],
            ),
          ),
          MySpacing.height(8),
          MyButton(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () => {},
            borderRadiusAll: AppStyle.buttonRadius.medium,
            padding: MySpacing.xy(8, 4),
            splashColor: colorScheme.onSurface.withAlpha(20),
            backgroundColor: Colors.transparent,
            child: Row(
              children: [
                Icon(RemixIcons.settings_line, size: 14, color: contentTheme.onBackground),
                MySpacing.width(8),
                Expanded(child: MyText.labelMedium("Settings", fontWeight: 600)),
                MySpacing.width(8),
                MyContainer(
                  color: contentTheme.success,
                  paddingAll: 4,
                  child: MyText.labelSmall('11',color: contentTheme.onSuccess),
                )
              ],
            ),
          ),
          MySpacing.height(8),
          MyButton(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              languageHideFn?.call();
              // Get.offAll(LoginScreen());
            },
            borderRadiusAll: AppStyle.buttonRadius.medium,
            padding: MySpacing.xy(8, 4),
            splashColor: contentTheme.danger.withAlpha(28),
            backgroundColor: Colors.transparent,
            child: Row(
              children: [
                Icon(RemixIcons.logout_box_r_line, size: 14, color: contentTheme.danger),
                MySpacing.width(8),
                MyText.labelMedium("Log out", fontWeight: 600, color: contentTheme.danger),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showDropdown(BuildContext context) {
    final RenderBox button = _menuKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy + button.size.height, overlay.size.width - position.dx - button.size.width, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          enabled: false,
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 240,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                mainAxisExtent: 80,
              ),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                return MyContainer.none(
                  onTap: () => Navigator.pop(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(app["icon"]!, height: 40, width: 40),
                      const SizedBox(height: 6),
                      Text(app["name"]!, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
