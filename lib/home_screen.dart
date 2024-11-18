import 'package:flutter/material.dart';
import 'package:note_app/abstracts.dart';
import 'package:note_app/sqldb.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  SqlDb sqlDb = SqlDb();
  bool isLoading = true;
  List notes = [];
  Future<List<Map>> readData() async {
    List<Map> response = await sqlDb.readData('SELECT * FROM notes');
    notes.addAll(response);
    isLoading = false;
    if (this.mounted) {
      setState(() {});
    }
    return response;
  }

  @override
  void initState() {
    
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("addnotes");
          },
          child: Icon(Icons.add),
        ),
        body: isLoading == true
            ? Center(
                child: Text("Loading .........."),
              )
            : Container(
                child: ListView(
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        await sqlDb.mydeleteDatabase();
                      },
                      child: Text("delete database"),
                    ),
                    ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, i) {
                        return Card(
                          child: ListTile(
                            title: Text("${notes[i]["note"]}"),
                            subtitle: Text('${notes[i]['title']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      int response = await sqlDb.deleteData(
                                          "DELETE FROM notes WHERE id = ${notes[i]['id']}");
                                      if (response > 0) {
                                        notes.removeWhere((element) =>
                                            element['id'] == notes[i]['id']);
                                        setState(() {});
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>
                                        EditNotes(
                                        color: notes[i]['color'],
                                        title: notes[i]['title'],
                                        note:notes[i]['note'],
                                        id:notes[i]['id']
                                        )
                                        )
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    )
                  ],
                ),
              ));
  }
}
