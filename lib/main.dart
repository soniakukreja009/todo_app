import 'package:flutter/material.dart';
import 'package:todoapp/screens/todoApiList.dart';
import 'package:todoapp/screens/todoList.dart';
import 'package:todoapp/util/dbhelper.dart';
import 'model/todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    List<Todo> todoList = List<Todo>();
    DBHelper dbHelper = DBHelper();
    dbHelper.initializeDB().then(
        (result) =>
        dbHelper.getTodos().then(
        (result) =>
          todoList = result));
    DateTime today = DateTime.now();
//    Todo todo = Todo("Buy Bananas", 1, today.toString(),"ANd make sure they are fresh");
//    var result = dbHelper.insertTodo(todo);

    return MaterialApp(
      title: 'Todos',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TodoApiList(),
    );
  }
}
