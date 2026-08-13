import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upzet/controller/my_controller.dart';
import 'package:upzet/helper/services/auth_services.dart';
import 'package:upzet/helper/widgets/my_form_validator.dart';
import 'package:upzet/helper/widgets/my_validators.dart';

class LoginController extends MyController {
  MyFormValidator basicValidator = MyFormValidator();

  bool loading = false;
  bool rememberMe = false;

  final String _dummyEmail = "user@gmail.com";
  final String _dummyPassword = "password";

  @override
  void onInit() {
    super.onInit();
    basicValidator.addField(
      'email',
      required: true,
      label: "Email",
      validators: [MyEmailValidator()],
      controller: TextEditingController(text: _dummyEmail),
    );

    basicValidator.addField(
      'password',
      required: true,
      label: "Password",
      validators: [MyLengthValidator(min: 6, max: 10)],
      controller: TextEditingController(text: _dummyPassword),
    );
  }

  // Services
  Future<void> onLogin() async {
    if (basicValidator.validateForm()) {
      loading = true;
      update();
      var errors = await AuthService.loginUser(basicValidator.getData());
      if (errors != null) {
        basicValidator.addErrors(errors);
        basicValidator.validateForm();
        basicValidator.clearErrors();
      } else {
        String nextUrl = Uri.parse(ModalRoute.of(Get.context!)?.settings.name ?? "").queryParameters['next'] ?? "/dashboard";
        Get.toNamed(nextUrl);
      }
      loading = false;
      update();
    }
  }

  void goToForgotPassword() {
    Get.toNamed('/auth/recover_password');
  }

  void gotoSignUp() {
    Get.toNamed('/auth/sign_up');
  }
}
