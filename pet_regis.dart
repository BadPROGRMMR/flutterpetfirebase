import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PetRegis extends StatefulWidget {
  const PetRegis({super.key});
  @override
  State<PetRegis> createState() => _PetRegisState();
}

class _PetRegisState extends State<PetRegis> {
  final _fbAuth = FirebaseAuth.instance;
  final _formregis = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Form(
          key: _formregis,
          child: SizedBox(
            width: 600,
            height: 600,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter email';
                    }
                    return null;
                  },
                  controller: email,
                  decoration:
                      InputDecoration(hintText: ("Enter email@example.com")),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter password';
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: pass,
                  decoration: InputDecoration(hintText: ("Enter password")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        String msg = '';
                        if (_formregis.currentState!.validate()) {
                          try {
                            await _fbAuth.createUserWithEmailAndPassword(
                                email: email.text.trim(),
                                password: pass.text.trim());

                            if (context.mounted) {
                              Navigator.pushNamed(context, '/login');
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              msg = "password too weak";
                            } else if (e.code == 'email-already-in-use') {
                              msg =
                                  "account already registered with that email";
                            }
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(msg)));
                            }
                          }
                        }
                      },
                      child: Text("Register")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
