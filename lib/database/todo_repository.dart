import 'package:flutter_todo_app/database/todo_dto.dart';
import 'package:flutter_todo_app/database/todo_methods.dart';

class TodoRepository {
  static var dbObject = TodoMethods();

  static addTodoEntry(TodoDTO tableRow) => dbObject.addTodoEntry(tableRow);

  static Future<List<TodoDTO>?> getAllTodoEntries() =>
      dbObject.getAllTodoEntries();

  static Future<TodoDTO?> getTodoEntry(String todoId) =>
      dbObject.getTodoEntry(todoId);

  static Future<bool> deleteTodo(String todoId) => dbObject.deleteTodo(todoId);

  static Future<int?> deleteAllTodos() => dbObject.deleteAllTodos();
}
