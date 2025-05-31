import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  // Observable to track theme mode: false = light, true = dark
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Optionally, you could load saved theme mode from storage here
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
