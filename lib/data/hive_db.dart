import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/model/note.dart';

class HiveDatabase {
  //reference our hive box\
  final _myBox = Hive.box('note_database');

  //load notes
  List<Note> loadNotes() {
    List<Note> savedNotesFormatted = [];

    //if there exist notes, return that, otherwise return empty list
    if (_myBox.get("ALL_NOTES") != null) {
      List<dynamic> savedNotes = _myBox.get("ALL_NOTES");
      for (int i = 0; i < savedNotes.length; i++) {
        //create individual notes
        Note individualNote = Note(
            text: savedNotes[i][1],
            id: savedNotes[i][0],
            title: savedNotes[i][2]);

        //add to list
        savedNotesFormatted.add(individualNote);
      }
    } else {
      //default first note

      savedNotesFormatted.add(Note(
          id: 0,
          text: 'FHappy to share first note with you',
          title: 'First Note'));
    }
    return savedNotesFormatted;
  }

  //save notes
  void savedNotes(List<Note> allNotes) {
    List<List<dynamic>> allNotesFormatted = [
      /*

      [
        [0,"first note"],
        [1,"second note"],
        --

      ]
      */
      //each note has an id and text
    ];
    for (var note in allNotes) {
      int? id = note.id;
      String? text = note.text;
      allNotesFormatted.add([id, text]);
    }

    //then store into hive
    _myBox.put("ALL_NOTES", allNotesFormatted);
  }
}
