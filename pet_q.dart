import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petapp/firebase_svc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetQ extends StatefulWidget {
  const PetQ({super.key});
  @override
  State<PetQ> createState() => _PetQState();
}

class _PetQState extends State<PetQ> {
  final FirebaseSvc firebaseSvc = FirebaseSvc();
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController editQ1 = TextEditingController();
  TextEditingController editQ2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Queue"),
          backgroundColor: Colors.blue,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/login'));
                    }
                  },
                  child: Text("Log out")),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/land');
                  },
                  child: Text("ADD")),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: firebaseSvc.showQ(uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List q = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: q.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = q[index];
                      String docID = doc.id;
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      String? own_name = data['owner'];
                      String? pet_name = data['petname'];
                      String? qdate = data['date'];

                      return ListTile(
                        tileColor: Colors.blueGrey[50],
                        title: Text("Record"),
                        trailing: SizedBox(
                          width: 1000,
                          height: 1000,
                          child: Row(
                            children: [
                              Text(
                                  style: TextStyle(fontSize: 18),
                                  qdate ?? "missing date"),
                              Text(style: TextStyle(fontSize: 18), " Owner: "),
                              Text(
                                  style: TextStyle(fontSize: 18),
                                  own_name ?? "missing name"),
                              Text(style: TextStyle(fontSize: 18), " Pet: "),
                              Text(
                                  style: TextStyle(fontSize: 18),
                                  pet_name ?? "missing pet name"),
                              IconButton(
                                  onPressed: () {
                                    editQ1.text = own_name ?? " ";
                                    editQ2.text = pet_name ?? " ";
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Edit queue"),
                                        content: Column(
                                          children: [
                                            TextFormField(
                                              controller: editQ1,
                                              decoration: InputDecoration(
                                                  hintText: "Enter new name"),
                                            ),
                                            TextFormField(
                                              controller: editQ2,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      "Enter new pet name"),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              await firebaseSvc.updateQ(docID,
                                                  editQ1.text, editQ2.text);
                                              if (context.mounted) {
                                                Navigator.pushNamed(
                                                    context, '/queue');
                                              }
                                            },
                                            child: Text("Update"),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"))
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue)),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Confirm delete"),
                                            content: Text(own_name ?? ""),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    await firebaseSvc
                                                        .deleteQ(docID);
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text("Delete")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel"))
                                            ],
                                          ));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(child: Text(" no queue "));
              }
            }));
  }
}
