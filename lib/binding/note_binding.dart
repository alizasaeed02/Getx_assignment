import 'package:get/get.dart';
import '../controllers/notes_controller.dart';
import '../services/notes_database.dart';

class NoteBinding extends Bindings {
  @override
  void dependencies() {
    // Use the singleton instance of NotesDatabase
    Get.lazyPut<NotesDatabase>(() => NotesDatabase.instance);

    // Initialize the note controller
    Get.lazyPut<NotesController>(() => NotesController());
  }
}
