import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:note_app/pages/addnote.dart';
import 'package:provider/provider.dart';
import '../model/note.dart';

class EditingNotePage extends StatefulWidget {
  final Note note;
  final bool isNewNote;

  const EditingNotePage({Key? key, required this.note, required this.isNewNote})
      : super(key: key);

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  QuillController _controller = QuillController.basic();
  late TextEditingController _titleController;
  //late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    loadExistingNote();

    // _textController = TextEditingController(text: widget.note.text);
  }

  //load existing note
  void loadExistingNote() {
    final doc = Document()..insert(0, widget.note.text);
    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
      _titleController.text = widget.note.title ?? '';
      //_textController.text = widget.note.text ?? '';
    });
  }

  //add new note
  void addNewNote() {
    final noteData = Provider.of<NoteData>(context, listen: false);
    final title = _titleController.text;
    final text = _controller.document.toPlainText();
    //get id
    int id = noteData.getAllNotes().length;
    //add new note
    noteData.addNewNote(
      Note(text: text, id: id, title: title),
    );
  }

  //update existing code
  void updateNote() {
    final noteData = Provider.of<NoteData>(context, listen: false);
    String text = _controller.document.toPlainText();
    String title = _titleController.text;

    if (text.isEmpty && title.isEmpty) {
      noteData.deleteNote(widget.note);
      return;
    }
    //update note
    noteData.updateNote(widget.note, title, text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (widget.isNewNote && !_controller.document.isEmpty()) {
                addNewNote();
              } else {
                updateNote();
              }
              Provider.of<NoteData>(context, listen: false)
                  .updateNoteTitle(widget.note, _titleController.text);
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
              controller: _titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //editor
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  QuillEditor.basic(controller: _controller, readOnly: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
