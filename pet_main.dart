import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Petmain extends StatefulWidget {
  const Petmain({super.key});
  @override
  State<Petmain> createState() => _PetMainState();
}

class _PetMainState extends State<Petmain> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main"),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(children: [
          Text("Welcome>>"),
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                } on Exception catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
                if (context.mounted) {
                  Navigator.popUntil(context, ModalRoute.withName("/login"));
                }
              },
              child: Text("logout"))
        ]),
      ),
    );
  }
}
