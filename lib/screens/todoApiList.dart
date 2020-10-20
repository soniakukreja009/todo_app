import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class TodoApiList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoApiListState();
}

class TodoApiListState extends State<TodoApiList> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    return widgets.length == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  getBody() {
    if (showLoadingDialog())
      return getProgressDialog();
    else
      return getListView();
  }

  getProgressDialog() {
    return Center(child: CircularProgressIndicator(),);
  }

  ListView getListView() {
    return ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext ctx, int pos) {
          return getRow(pos);
        });
  }

  Widget getRow(int pos) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(widgets[pos]["title"]),
      ),
      onTap: (){

      },
    );
  }

  Future<void> loadData() async {
    String dataUrl = "https://jsonplaceholder.typicode.com/";
    http.Response response;
    response = await http.get(dataUrl);

    setState(() {
      widgets = json.decode(response.body);
    });
  }

}
