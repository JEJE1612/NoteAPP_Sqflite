import 'package:flutter/material.dart';
import 'package:note_app/home_screen.dart';
import 'package:note_app/sqldb.dart';

class EditNotes extends StatefulWidget {
  final note;
  final title;
  final color;
  final id;
  const EditNotes({super.key, this.note, this.id, this.title, this.color});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController color = TextEditingController();
  @override
  void initState() {
    note.text = widget.note;
    title.text = widget.title;
    color.text = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Edit Notes'),
      ),
      body: Container(
        padding:const EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
                key: formstate,
                child: Column(
                  children: [
                    TextFormField(
                      controller: note,
                      decoration:const InputDecoration(hintText: 'note'),
                    ),
                    TextFormField(
                      controller: title,
                      decoration:const InputDecoration(hintText: "title"),
                    ),
                    TextFormField(
                      controller: color,
                      decoration: const InputDecoration(hintText: "color"),
                    ),
                    Container(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        int response = await sqlDb.updateData('''
                          UPDATE notes SET
                          note = "${note.text}",
                          title = "${note.text}",
                          color ="${color.text}"
                          WHERE id = ${widget.id}
                          ''');
                        print("responce ===================");
                        if (response > 0) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Home_Screen()),
                              (route) => false);
                        }
                        print(response);
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child:const Text("Add Notes"),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
