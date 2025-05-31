import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assgnment_getx/controllers/notes_controller.dart';
import 'package:assgnment_getx/model/note.dart';

class DeleteNodeScreen extends StatelessWidget {
  final NotesController controller = Get.find();
  final Note note;

  DeleteNodeScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delete Note')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Are you sure you want to delete this note?'),
            SizedBox(height: 16),
            Text(
              note.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(note.content),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.deleteNote(note.id!);
                Get.back();
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
