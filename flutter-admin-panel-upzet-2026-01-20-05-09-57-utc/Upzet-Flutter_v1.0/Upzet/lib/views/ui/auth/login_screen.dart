import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:upzet/controller/ui/auth/login_controller.dart';
import 'package:upzet/helper/utils/ui_mixins.dart';
import 'package:upzet/helper/widgets/my_button.dart';
import 'package:upzet/helper/widgets/my_container.dart';
import 'package:upzet/helper/widgets/my_spacing.dart';
import 'package:upzet/helper/widgets/my_text.dart';
import 'package:upzet/helper/widgets/my_text_style.dart';
import 'package:upzet/images.dart';
import 'package:upzet/views/layout/auth_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with UIMixin {
  late LoginController controller;

  @override
  void initState() {
    controller = Get.put(LoginController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      tag: 'login_controller',
      builder: (controller) {
        return AuthLayout(
          child: Column(
            children: [
              MyContainer(
                padding: MySpacing.xy(24, 28),
                child: Form(
                  key: controller.basicValidator.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Image.asset(Images.logoDark, height: 30)),
                      MySpacing.height(24),
                      Center(child: MyText.titleLarge("Welcome Back!", fontWeight: 600, muted: true)),
                      MySpacing.height(12),
                      Center(child: MyText.bodyMedium("Sign in to continue to Upzet.")),
                      MySpacing.height(40),
                      MyText.bodyMedium("Email Address", fontWeight: 600),
                      MySpacing.height(8),
                      TextFormField(
                        validator: controller.basicValidator.getValidation('email'),
                        controller: controller.basicValidator.getController('email'),
                        keyboardType: TextInputType.emailAddress,
                        style: MyTextStyle.bodyMedium(),
                        decoration: InputDecoration(
                          hintText: "Email Address",
                          hintStyle: MyTextStyle.bodySmall(xMuted: true),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(width: 1, strokeAlign: 0, color: colorScheme.onSurface.withAlpha(80)),
                          ),
                          contentPadding: MySpacing.all(16),
                          isDense: true,
                          isCollapsed: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                      MySpacing.height(16),
                          MyText.bodyMedium("Password", fontWeight: 600),
                      MySpacing.height(8),
                      TextFormField(
                        validator: controller.basicValidator.getValidation('password'),
                        controller: controller.basicValidator.getController('password'),
                        keyboardType: TextInputType.visiblePassword,
                        style: MyTextStyle.bodyMedium(xMuted: true),
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: MyTextStyle.bodySmall(xMuted: true),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(width: 1, strokeAlign: 0, color: colorScheme.onSurface.withAlpha(80)),
                          ),
                          contentPadding: MySpacing.all(16),
                          isCollapsed: true,
                          isDense: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                      MySpacing.height(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Theme(
                                data: ThemeData(visualDensity: VisualDensity.compact),
                                child: Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  value: controller.rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      controller.rememberMe = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              MyText.bodyMedium('Remember me', fontWeight: 600),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(MdiIcons.lock, size: 16, color: contentTheme.secondary),
                              MySpacing.width(4),
                              MyButton.text(
                                onPressed: controller.goToForgotPassword,
                                elevation: 0,
                                padding: MySpacing.xy(0, 0),
                                splashColor: contentTheme.secondary.withValues(alpha: 0.1),
                                child: MyText.bodyMedium('Forgot your Password?', color: contentTheme.secondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      MySpacing.height(16),
                      MyContainer(
                        onTap: controller.onLogin,
                        color: contentTheme.primary,
                        borderRadiusAll: 6,
                        paddingAll: 12,
                        child: Center(child: MyText.bodyMedium("Log in", color: contentTheme.onDark)),
                      ),
                    ],
                  ),
                ),
              ),
              MySpacing.height(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText.bodyMedium("Don't have an account?", color: contentTheme.background),
                  MySpacing.width(12),
                  InkWell(
                    onTap: () => controller.gotoSignUp(),
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: MyText.bodyMedium("Register", fontWeight: 700, color: contentTheme.primary),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
