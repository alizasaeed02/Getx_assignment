import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notes_controller.dart';
import '../model/note.dart';

class UpdateNoteScreen extends StatelessWidget {
  final NotesController controller = Get.find();
  final Note note;

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  UpdateNoteScreen({Key? key, required this.note}) : super(key: key) {
    titleController.text = note.title;
    contentController.text = note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Note')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty ||
                    contentController.text.trim().isEmpty) {
                  Get.snackbar('Error', 'Title and Content cannot be empty',
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }

                final updatedNote = Note(
                  id: note.id,
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  createdAt: note.createdAt,
                  updatedAt: DateTime.now().toIso8601String(),
                );

                await controller.updateNote(updatedNote);
                Get.back();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
