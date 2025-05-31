import 'package:get/get.dart';
import '../model/note.dart';
import '../Services/notes_database.dart';

class NotesController extends GetxController {
  var notes = <Note>[].obs; // All notes
  var filteredNotes = <Note>[].obs; // Filtered notes for search/sort
  var searchQuery = ''.obs;
  var sortBy = 'date'.obs; // Can be 'date' or 'title'

  Note? lastDeletedNote; // For Undo delete

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final allNotes = await NotesDatabase.instance.getNotes();
    notes.assignAll(allNotes);
    applyFilters();
  }

  Future<void> addNote(Note note) async {
    await NotesDatabase.instance.addNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await NotesDatabase.instance.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    // Save last deleted note for Undo
    lastDeletedNote = notes.firstWhereOrNull((n) => n.id == id);

    await NotesDatabase.instance.deleteNote(id);
    await loadNotes();
  }

  void restoreLastDeletedNote() async {
    if (lastDeletedNote != null) {
      await NotesDatabase.instance.addNote(lastDeletedNote!);
      await loadNotes();
      lastDeletedNote = null;
    }
  }

  void searchNotes(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void sortNotes(String sortOption) {
    sortBy.value = sortOption;
    applyFilters();
  }

  void applyFilters() {
    List<Note> tempNotes = notes.toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      tempNotes = tempNotes.where((note) {
        final lowerQuery = searchQuery.value.toLowerCase();
        return note.title.toLowerCase().contains(lowerQuery) ||
            note.content.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    // Apply sort
    if (sortBy.value == 'date') {
      tempNotes.sort((a, b) =>
          DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));
    } else if (sortBy.value == 'title') {
      tempNotes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }

    filteredNotes.assignAll(tempNotes);
  }
}
