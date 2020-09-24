import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:garden/screens/page_container.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme(), primarySwatch: Colors.blue,visualDensity: VisualDensity.adaptivePlatformDensity,),
      home:PageContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}