import 'package:flutter/material.dart';
import '../model/note.dart';
import 'addnote.dart';
import 'package:provider/provider.dart';

import 'editing_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Generate a random color for each card
  List<Color> cardColors = [];

  @override
  void initState() {
    super.initState();

    Provider.of<NoteData>(context, listen: false).initializeNotes();
  }

  //create a neew note
  void createNewNote() {
    //create a new id
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;

    //create a blank note
    Note newNote = Note(
      id: id,
      text: '',
      title: '',
    );

    //go to edit the note
    goToNotePage(newNote, true);
  }

  //goto note editing page
  void goToNotePage(Note note, bool isNewNote) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditingNotePage(
          note: note,
          isNewNote: isNewNote,
        ),
      ),
    );
  }

  //delete note
  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).deleteNote(note);
  }

  void deleteNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                deleteNote(note);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //heading
            const Padding(
              padding: EdgeInsets.only(left: 25, top: 75),
              child: Text(
                'Notes',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //List of notes
            (value.getAllNotes().isEmpty)
                ? Padding(
                    padding: const EdgeInsets.only(top: 350),
                    child: Center(
                      child: Text(
                        'Empty List',
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 2,
                        ),
                        itemCount: value.getAllNotes().length,
                        itemBuilder: (context, index) {
                          final note = value.getAllNotes()[index];

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return Card(
                                color: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  onTap: () => goToNotePage(note, false),
                                  child: Container(
                                    // height: textHeight,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            note.title ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            note.text ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  onLongPress: () => deleteNoteDialog(
                                    note,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewNote,
          elevation: 6.0,
          backgroundColor: Colors.grey[300],
          child: const Icon(
            Icons.add,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
