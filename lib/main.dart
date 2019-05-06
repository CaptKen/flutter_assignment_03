import 'package:flutter/material.dart';
import './ui/MyTodoList.dart';
import './ui/Addlist.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pink
      ),
      routes:{
       "/" : (context) => MyTodoList(),
       "add" : (context) => Addlist(),
        },
    );
  }
}