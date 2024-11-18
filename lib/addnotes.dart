import 'package:flutter/material.dart';
import 'package:note_app/home_screen.dart';
import 'package:note_app/sqldb.dart';

class Addnotes extends StatefulWidget {
  const Addnotes({super.key});

  @override
  State<Addnotes> createState() => _AddnotesState();
}

class _AddnotesState extends State<Addnotes> {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController color = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Add Notes'),
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
                      decoration:const InputDecoration(hintText: "color"),
                    ),
                    Container(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        int response = await sqlDb.insertData('''
                          INSERT INTO notes(note , title ,color )
                          VALUES ("${note.text}","${title.text}", "${color.text}")
                          ''');
                        print("responce ===================");
                        if (response > 0) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Home_Screen()),
                                  (route)=>false
                              );
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
