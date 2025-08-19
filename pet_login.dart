import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Petlog extends StatefulWidget {
  const Petlog({super.key});
  @override
  State<Petlog> createState() => _PetLogState();
}

class _PetLogState extends State<Petlog> {
  TextEditingController usn = TextEditingController();
  TextEditingController pw = TextEditingController();
  final _formlogin = GlobalKey<FormState>();
  final _fbAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          backgroundColor: Colors.cyan,
        ),
        body: Center(
          child: Form(
            key: _formlogin,
            child: SizedBox(
                width: 600,
                height: 600,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter username';
                          }
                          return null;
                        },
                        controller: usn,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person), hintText: ("Username")),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter password';
                          }
                          return null;
                        },
                        controller: pw,
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock), hintText: ("Password")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white),
                                onPressed: () async {
                                  String msg = '';
                                  if (_formlogin.currentState!.validate()) {
                                    try {
                                      await _fbAuth.signInWithEmailAndPassword(
                                          email: usn.text, password: pw.text);
                                      if (context.mounted) {
                                        Navigator.pushNamed(context, '/land');
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code ==
                                          'INVALID_LOGIN_CREDENTIALS') {
                                        msg = "invalid login";
                                      } else {
                                        msg = e.code;
                                      }
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                SnackBar(content: Text(msg)));
                                      }
                                    }
                                  }
                                },
                                child: Text("Login")),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/regis',
                                    );
                                  },
                                  child: Text("Register")),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ));
  }
}
