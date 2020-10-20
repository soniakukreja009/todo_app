
class Todo {
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;

  Todo(this._title, this._priority, this._date, [this._description]);
  Todo.withId(this._id,this._title, this._priority, this._date, [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;

  set title(String newTitle){
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set date(String value) {
    _date = value;
  }

  set priority(int value) {
    _priority = value;
  }

  set description(String value) {
    _description = value;
  }

  Map<String, dynamic> getMap(){
    var map = Map<String, dynamic>();
    map["title"]= _title;
    map["description"]= _description;
    map["priority"]= _priority;
    map["date"]= _date;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Todo.fromObject(dynamic o){
    this._id = o["id"];
    this._title = o["title"];
    this._description = o["description"];
    this._priority = o["priority"];
    this._date = o["date"];
  }

}