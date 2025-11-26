import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo.dart';

class TodoLocalDataSource {
  static const _todoKey = 'todo_list';

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final listString = prefs.getString(_todoKey);
    if (listString == null) return [];
    final List<dynamic> jsonList = json.decode(listString);
    return jsonList.map((json) => Todo.fromMap(json)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = todos.map((todo) => todo.toMap()).toList();
    await prefs.setString(_todoKey, json.encode(jsonList));
  }
}
