
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/util/dbhelper.dart';


DBHelper helper = DBHelper();
final List<String> choices = const <String>[
  'Save & Back',
  'Delete',
  'Back to List'
];

const menuSave = 'Save & Back';
const menuDelete = 'Delete';
const menuBack = 'Back to List';

class TodoDetail extends StatefulWidget{
  final Todo todo;
  TodoDetail(this.todo);
  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);

}

class TodoDetailState extends State {
  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["high", "medium", "low"];
  String _priority = "low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Detail"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: selectMenu,
            itemBuilder: (BuildContext context){
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: ListView(children: <Widget>[
        Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
            child: TextField(
              controller: titleController,
              style: textStyle,
              onChanged: (value)=> this.updateTitle(),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
            child: TextField(
              controller: descriptionController,
              style: textStyle,
              onChanged: (value) => this.updateDescription(),
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          ListTile(title: DropdownButton(
            items: _priorities.map((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            style: textStyle,
            value: retrievePriority(todo.priority),
            onChanged: (value) => updatePriority(value),
          )),
          RaisedButton(
            color: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            child: Text("Submit"),
            onPressed: () {

            },
          )
        ],)
      ],),
    );
  }

  void selectMenu(String value) async{
    switch(value) {
      case menuSave:
        save();
        break;
      case menuDelete:
        delete();
        break;
      case menuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if(todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
  }

  void delete() async{
    Navigator.pop(context, true);
    if (todo.id == null) {
      return;
    }
    var result = await helper.deleteTodo(todo.id);
    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Delet Todo"),
        content: Text("The Todo has been deleted!"),
      );
      showDialog(
        context: context,
        builder: (_) => alertDialog
      );
    }
  }

  void updatePriority(String value) {
    switch(value) {
      case "high":
        todo.priority = 1;
        break;
      case "medium":
        todo.priority = 2;
        break;
      case "low":
        todo.priority = 3;
        break;
    }

    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value-1];
  }

  String updateTitle(){
    todo.title = titleController.text;
  }

  String updateDescription(){
    todo.description = descriptionController.text;
  }
}