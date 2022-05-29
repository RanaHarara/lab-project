import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/provider/note_provider.dart';
import 'package:provider/provider.dart';

  class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);
  @override
  State<NewNote> createState() => _NewNoteState();
}

  class _NewNoteState extends State<NewNote> {
  late TextEditingController _contentTextEditing, _titleTextEditing;
  Color _selectedColor =  const Color(0xFF1321e0);
  @override
  void initState() {
    super.initState();
    _contentTextEditing = TextEditingController();
    _titleTextEditing = TextEditingController();
  }
  @override
  void dispose() {
    _contentTextEditing.dispose();
    _titleTextEditing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, size: 25,),
            onPressed: () => {
              _noteEditSheet(context),
            },
          ),
          IconButton(
            icon: const Icon(Icons.check, size: 25,),
            onPressed: () async => performSave(),
          ),
        ],
        elevation: 2,
        backgroundColor: _selectedColor,
        centerTitle: false,
        title:  const Text('New Note', style: TextStyle(fontFamily: 'OpenSans'),),
      ),
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(right: 25, left: 25, top: 25, bottom: 0),
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: TextField(
              controller: _titleTextEditing,
              decoration: const InputDecoration(
                hintText: 'Type Something.....',
                hintStyle: TextStyle(color: Color(0xFF1321e0), fontFamily: 'OpenSans'),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: TextField(
              controller: _contentTextEditing,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type Something....',
                hintStyle: TextStyle(color: Colors.grey,fontFamily: 'OpenSans' ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> performSave() async {
    if (CheckData()) {
      await save();} }
      bool CheckData() {
    if (_contentTextEditing.text.isNotEmpty &&
        _titleTextEditing.text.isNotEmpty) {
      return true;
    }showSnackBar(message: 'There is an Error', error: true);
    return false;
     }

  void showSnackBar({required String message, bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red : Colors.green,
    ));
  }

  Future<void> save() async {
    bool created = await Provider.of<NoteProvider>(context, listen: false)
        .create(note: note);
    print(created);
    if (created) {
      clear();
      Navigator.pop(context);
    }
    String message = created ? 'Created Successfully' : 'Created failed';
    showSnackBar(message: message, error: !created);
  }

  NoteModel get note {
    NoteModel newNote = NoteModel();
    newNote.content = _contentTextEditing.text;
    newNote.title = _titleTextEditing.text;
    newNote.note_color = _selectedColor;
    return newNote;
  }

  void clear() {
    _contentTextEditing.text = '';
    _titleTextEditing.text = '';
  }

  void _noteEditSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: _selectedColor,
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.share, color: Colors.white,size: 20,),
                    title: const Text('Share With Your friends', style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, fontFamily: 'OpenSans'),),
                    onTap: () {}),
                ListTile(
                    leading: const Icon(Icons.delete, color: Colors.white,size: 20,),
                    title: const Text('Delete' , style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, fontFamily: 'OpenSans'),),
                    onTap: () { }),
                ListTile(
                    leading: const Icon(Icons.content_copy,color: Colors.white,size: 20, ),
                    title: const Text('Duplicate',style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, fontFamily: 'OpenSans'),),
                    onTap: () {}),
                MaterialColorPicker(
                  colors: const [Colors.pink,
                  Colors.pink,
                  Colors.yellow,
                  Colors.green,
                  Colors.cyan,
                  Colors.lightBlue,
                  Colors.brown,
                  Colors.grey,
                ],
                  selectedColor: _selectedColor,
                  onColorChange: (color) => setState(() => {
                    print("object ${color.toString()}"),
                    print("ot ${color}"),
                        _selectedColor = color,
                      }),
                      spacing: 5,
                ),
              ],
            ),
          );
        });
  }
}
