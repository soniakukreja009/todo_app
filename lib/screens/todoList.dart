

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/screens/todoDetail.dart';
import 'package:todoapp/util/dbhelper.dart';

class TodoList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => TodoListState();

}

class TodoListState extends State<TodoList> {
  DBHelper helper = DBHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if(todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo("",3,""));
        },
      ),
    );
  }

  void getData() {
    final dbFuture = helper.initializeDB();
    dbFuture.then((value)
    {
      final todoListFuture = helper.getTodos();
      todoListFuture.then((value)
      {
        List<Todo> todoList = List<Todo>();
        count = value.length;
        for (int i=0; i< count; i++) {
          todoList.add(Todo.fromObject(value[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("Items : "+ count.toString());

      });
    });
  }

  todoListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(this.todos[position].priority),
                child: Text(this.todos[position].priority.toString()),
              ),
              title: Text(this.todos[position].title.toString()),
              subtitle: Text(this.todos[position].date.toString()),
              onTap: () {
                navigateToDetail(this.todos[position]);
              },
            ),

          );
        }
    );
  }

  Color getColor(int priority) {
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo)),).whenComplete(() => getData());
  }

}