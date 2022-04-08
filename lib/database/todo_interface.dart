import 'package:flutter_todo_app/database/todo_dto.dart';

abstract class TodoInterface {
  addTodoEntry(TodoDTO tableRow);
  Future<List<TodoDTO>?> getAllTodoEntries();
  Future<TodoDTO?> getTodoEntry(String todoId);
  Future<bool> deleteTodo(String todoId);
  Future<int?> deleteAllTodos();
}
