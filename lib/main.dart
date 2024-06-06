import 'package:flutter/material.dart';
import 'package:homework_sql/screens/home_screen.dart';

void main(List<String> args) {
  runApp(const ContactsApp());
}

class ContactsApp extends StatelessWidget {
  const ContactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: const Color.fromARGB(255, 9, 9, 9),
      home: HomeScreen(),
    );
  }
}
