import 'package:flutter/material.dart';
import 'package:todo/database and model/flu_model.dart';
import 'package:todo/database and model/helper.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final dbhelper = Helper();
  late Future<List<DataModel>> notesList;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    notesList = dbhelper.getNOteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo app"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: notesList,
        builder: (context, AsyncSnapshot<List<DataModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final note = snapshot.data![index];
                return Dismissible(
                  key: ValueKey<int>(note.id!),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete_forever),
                  ),
                  onDismissed: (direction) {
                    dbhelper.delete(note.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Item deleted"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                      loadData();
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Long press to edit"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    onLongPress: () {
                      final work = TextEditingController(text: note.work);
                      final description = TextEditingController(text: note.description);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Edit Item"),
                            content: SizedBox(
                              height: 200,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: work,
                                    decoration: const InputDecoration(labelText: "Write the work"),
                                  ),
                                  TextField(
                                    controller: description,
                                    decoration: const InputDecoration(labelText: "Describe the work"),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  dbhelper.update(DataModel(
                                    id: note.id,
                                    work: work.text,
                                    description: description.text,
                                  )).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Data has been edited"),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    setState(() {
                                      loadData();
                                    });
                                  }).onError((error, stackTrace) {
                                    print(error.toString());
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Update"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(note.work ),
                        subtitle: Text(note.description ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final work = TextEditingController();
          final description = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Item"),
                content: SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      TextField(
                        controller: work,
                        decoration: const InputDecoration(labelText: "Write the work"),
                      ),
                      TextField(
                        controller: description,
                        decoration: const InputDecoration(labelText: "Describe the work"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      dbhelper.insert(DataModel(
                        work: work.text,
                        description: description.text,
                      )).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Data has been added"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        setState(() {
                          loadData();
                        });
                      }).onError((error, stackTrace) {
                        print(stackTrace);
                        print(error.toString());
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
