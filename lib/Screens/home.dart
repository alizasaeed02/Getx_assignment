import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notes_controller.dart';
import '../model/note.dart';
import 'editnote.dart'; // Make sure this import is correct!

class HomeScreen extends StatelessWidget {
  final NotesController controller = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              _showSortDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            final crossAxisCount = isTablet ? 3 : 1;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(isTablet ? 24.0 : 12.0),
                  child: TextField(
                    onChanged: controller.searchNotes,
                    decoration: InputDecoration(
                      hintText: 'Search notes...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    return GridView.builder(
                      padding: EdgeInsets.all(isTablet ? 24.0 : 12.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isTablet ? 1.2 : 3,
                      ),
                      itemCount: controller.filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = controller.filteredNotes[index];
                        return _buildNoteCard(context, note, isTablet);
                      },
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddNoteScreen (assuming you have it configured separately)
          Get.toNamed('/add');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note, bool isTablet) {
    return Dismissible(
      key: Key(note.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Note'),
            content: Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        controller.deleteNote(note.id!);
        Get.snackbar(
          'Note deleted',
          'Tap to undo',
          mainButton: TextButton(
            onPressed: () {
              controller.restoreLastDeletedNote();
              Get.back();
            },
            child: Text('Undo'),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.all(isTablet ? 20.0 : 12.0),
          width: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        fontSize: isTablet ? 22 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        note.content,
                        style: TextStyle(fontSize: isTablet ? 18 : 14),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.createdAt,
                      style:
                      TextStyle(fontSize: isTablet ? 14 : 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Edit Note',
                  onPressed: () {
                    // Navigate to UpdateNoteScreen with note
                    Get.to(() => UpdateNoteScreen(note: note));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Sort by',
      content: Column(
        children: [
          ListTile(
            title: Text('Date'),
            onTap: () {
              controller.sortNotes('date');
              Get.back();
            },
          ),
          ListTile(
            title: Text('Title'),
            onTap: () {
              controller.sortNotes('title');
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
