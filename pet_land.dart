import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petapp/firebase_svc.dart';

class PetLand extends StatefulWidget {
  const PetLand({super.key});
  @override
  State<PetLand> createState() => _PetLandState();
}

class _PetLandState extends State<PetLand> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final FirebaseSvc firebaseSvc = FirebaseSvc();
    DateTime? selectDate = DateTime.now();
    String date;
    TextEditingController own = TextEditingController();
    TextEditingController pn = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Petcare"),
        backgroundColor: Colors.cyan,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.popUntil(context, ModalRoute.withName('/login'));
                  }
                },
                child: Text("Log out")),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/queue');
                },
                child: Text("Queue")),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 600,
          height: 600,
          child: Column(
            children: [
              TextFormField(
                controller: own,
                decoration: InputDecoration(
                    icon: Icon(Icons.person), hintText: ("Owner Name")),
              ),
              TextFormField(
                controller: pn,
                decoration: InputDecoration(
                    icon: Icon(Icons.pets_rounded), hintText: ("Petname")),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      final DateTime? pickDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2026),
                      );
                      if (pickDate != null) {
                        selectDate = pickDate;
                      }
                    },
                    child: Text("Pick Date")),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      date = selectDate.toString();
                      date = date.substring(0, 10);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Summary'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Name = ${own.text}"),
                                Text("Petname = ${pn.text}"),
                                Text("Date = "),
                                Text(date),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Navigator.pushNamed(context, '/queue');
                                  await firebaseSvc.addQ(
                                      own.text, pn.text, uid, date);
                                  own.clear();
                                  pn.clear();
                                },
                                child: Text('OK'),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"))
                            ],
                          );
                        },
                      );
                    },
                    child: Text("Send")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
