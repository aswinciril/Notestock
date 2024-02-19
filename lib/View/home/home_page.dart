import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Services/firestore.dart';
import 'package:firebase/View/home/drawer.dart';
import 'package:firebase/View/widgets/home_title.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore
  final FirestoreService firestoreService = FirestoreService();

  //text controller
  final TextEditingController textController = TextEditingController();

  //open a dialog box to add a new note
  void opennoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          //button to save
          ElevatedButton(
            onPressed: () {
              //add a new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }
              //update an existing note

              else {
                firestoreService.updateNote(docID, textController.text);
              }

              //clear the textcontroller
              textController.clear();

              //close the box

              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerHome(),
      drawerScrimColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        onPressed: opennoteBox,
        child: const Icon(Icons.add),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 15),
      //   child: Column(
      //     // mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      // SizedBox(height: 10,),
      // HomeTitle(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: HomeTitle(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getNotesStream(),
                builder: (context, snapshot) {
                  //if we have data,get all the docs
                  if (snapshot.hasData) {
                    List notesList = snapshot.data!.docs;

                    //display as a list
                    return ListView.builder(
                      itemCount: notesList.length,
                      itemBuilder: (context, index) {
                        //get individual doc
                        DocumentSnapshot document = notesList[index];
                        String docID = document.id;

                        //get note from each document

                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String noteText = data['note'];

                        //display as a list tile
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 19, vertical: 15),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.36,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 231, 244, 255),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 206, 206, 206),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ListTile(
                                title: Text(noteText),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //update button
                                    IconButton(
                                      onPressed: () =>
                                          opennoteBox(docID: docID),
                                      icon: const Icon(Icons.edit),
                                    ),

                                    //delete button
                                    IconButton(
                                      onPressed: () =>
                                          firestoreService.deleteNote(docID),
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                    );
                  }
                  //if there is no data
                  else {
                    return const Text("No Notes...");
                  }
                },
              ),
            ),
          ],
        ),
      ),
      //  ],
    );
    //),

    //);
  }
}
