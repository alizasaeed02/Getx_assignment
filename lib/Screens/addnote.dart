import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notes_controller.dart';
import '../model/note.dart';

class AddNoteScreen extends StatelessWidget {
  final NotesController controller = Get.find();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Note')),
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
                final note = Note(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  createdAt: DateTime.now().toIso8601String(),
                  updatedAt: DateTime.now().toIso8601String(),
                );

                await controller.addNote(note);
                Get.back();
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
