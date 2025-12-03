import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo.dart';

class TodoLocalDataSource {
  static const _todoKey = 'todo_list';
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<Todo>> loadTodos() async {
    final preferences = await prefs;
    final listString = preferences.getString(_todoKey);
    if (listString == null) return [];
    final List<dynamic> jsonList = json.decode(listString);
    return jsonList.map((json) => Todo.fromMap(json)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final preferences = await prefs;
    final jsonList = todos.map((todo) => todo.toMap()).toList();
    await preferences.setString(_todoKey, json.encode(jsonList));
  }
}
