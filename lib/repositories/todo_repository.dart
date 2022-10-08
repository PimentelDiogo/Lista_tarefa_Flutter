import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoRepository {
  // TodoRepository() {
  //   SharedPreferences.getInstance().then((value){
  //     print(sharedPreferences.getString('todo_list'));
  //   });
  // }

  late SharedPreferences sharedPreferences;

  Future <List<Todo>> getTodoList() async{
  sharedPreferences = await SharedPreferences.getInstance(); //retorna a mesma instacia do objeto(no caso sharedPreferences)
  final String jsonString = sharedPreferences.getString('todo_list') ?? '[]';
  final List jsonDecoded = json.decode(jsonString)as List;
  return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }
  void saveTodoList(List<Todo>todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString('todo_list',jsonString);
  }
}