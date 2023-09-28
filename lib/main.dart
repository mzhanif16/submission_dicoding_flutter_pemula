import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:submission_dicoding_flutter_pemula/login_screen.dart';
import 'package:submission_dicoding_flutter_pemula/register_screen.dart';

import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper = DatabaseHelper(); // Inisialisasi DatabaseHelper

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DepokBooks',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.indigoAccent
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        elevatedButtonTheme:ElevatedButtonThemeData(
          style:ButtonStyle(
            backgroundColor:const MaterialStatePropertyAll(Colors.blue),
            shape:MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(10)
              )
            ),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            textStyle: const MaterialStatePropertyAll(
              TextStyle(fontSize: 15),
            ),
          )
        )
      ),
      home: LoginView(databaseHelper: databaseHelper,),
    );
  }
}
