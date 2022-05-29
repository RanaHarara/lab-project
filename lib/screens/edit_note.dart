
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/provider/note_provider.dart';
import 'package:provider/provider.dart';

  class EditNote extends StatefulWidget {
  late int id;
  late String title;
  late String content;
  late Color note_color;
  EditNote({Key? key,required this.id, required this.title, required this.content,required this.note_color})
      : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late TextEditingController _contentTextEditing, _titleTextEditing;
  Color _selectedColor = const Color(0xFF1321e0);

  NoteModel get note {
    NoteModel newNote = NoteModel();
    newNote.id= widget.id;
    newNote.content = _contentTextEditing.text;
    newNote.title = _titleTextEditing.text;
    newNote.note_color=_selectedColor;
    return newNote;
  }

  @override
  void initState() {
    super.initState();
    _contentTextEditing = TextEditingController();
    _titleTextEditing = TextEditingController();
    _titleTextEditing.text = widget.title;
    _contentTextEditing.text = widget.content;

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
            icon: const Icon(Icons.more_vert),
            onPressed: () => {
              _noteEditSheet(context),
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: ()  async  { performEdit();


    }
          ),
        ],
        elevation: 2,
        backgroundColor: widget.note_color,
        centerTitle: false,
        title: const Text(
          'Edit Note',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
        ),
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

  void _noteEditSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {

          return Container(

            color: widget.note_color,
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
                    onTap: () {
                      deleteNote(id: note.id);
                    }),
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
                   _selectedColor = color,
                    widget.note_color=color,
                  }),
                  spacing: 5,
                ),
              ],
            ),
          );
        });
    }
    Future<void> performEdit() async{
      if(CheckData()){
        await editing();
      }
    }
    void showSnackBar({required String message, bool error = false}) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ));
    }

    bool CheckData() {
      if (_contentTextEditing.text.isNotEmpty &&
          _titleTextEditing.text.isNotEmpty) {
        return true;
      }
      showSnackBar(message: 'There is an error', error: true);
      return false;
    }

    Future<void> editing() async{
      bool edited=await Provider.of<NoteProvider>(context,listen: false).update(note: note);
      String message= edited ? 'Edited Successfully' : 'Edited failed';
      showSnackBar(message: message,error: !edited);
      setState(() {
        if(edited){
          Navigator.pop(context);
        }
      });

    }

    Future<void> deleteNote({required id}) async {
      bool deleted = await Provider.of<NoteProvider>(context, listen: false)
          .delete(id: id);

      String message = 'Delete failed';
      if(!deleted){
        showSnackBar(message: message, error: !deleted);
        return;
      }

       Navigator.pushNamedAndRemoveUntil(context, '/Note_Screen', (route) => false);
     // Navigator.pushReplacementNamed(context, '/Note_Screen');
      }

    }


