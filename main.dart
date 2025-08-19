import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petapp/firebase_options.dart';
import 'package:petapp/pet_land.dart';
import 'package:petapp/pet_login.dart';
import 'package:petapp/pet_main.dart';
import 'package:petapp/pet_q.dart';
import 'package:petapp/pet_regis.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Petlog(),
        '/regis': (context) => const PetRegis(),
        '/land': (context) => const PetLand(),
        '/main': (context) => const Petmain(),
        '/queue': (context) => const PetQ(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
