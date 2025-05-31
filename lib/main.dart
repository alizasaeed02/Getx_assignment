import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Screens/home.dart';
import 'Screens/addnote.dart'; // Import Add/Edit Note Screen
import 'controllers/notes_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(NotesController());
  Get.put(ThemeController()); // Initialize theme controller
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode:
      themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/add', page: () => AddNoteScreen()),
        // Add more pages here if needed
      ],
    ));
  }
}

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
