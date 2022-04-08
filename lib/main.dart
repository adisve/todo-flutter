import 'package:flutter/material.dart';
import 'package:flutter_todo_app/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        unselectedWidgetColor: Colors.green,
      ),
      home: FutureBuilder(builder: (context, snapshot) {
        return const TodoListPage();
      }),
    );
  }
}
