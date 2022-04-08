import 'dart:developer';

import 'package:flutter_todo_app/database/todo_dto.dart';
import 'package:flutter_todo_app/database/todo_interface.dart';

import 'db_init.dart';

class TodoMethods implements TodoInterface {
  String todoTable = DbInit.todoItemsTable;
  String name = DbInit.name;
  String id = DbInit.index;
  String description = DbInit.description;

  @override
  addTodoEntry(TodoDTO tableRow) async {
    var dbClient = await DbInit.db;
    await dbClient?.insert(todoTable, tableRow.toMap());
  }

  @override
  Future<int?> deleteAllTodos() async {
    var dbClient = await DbInit.db;
    return await dbClient?.delete(todoTable);
  }

  @override
  Future<bool> deleteTodo(String todoId) async {
    try {
      var dbClient = await DbInit.db;
      int? rowsAffected = await dbClient
          ?.delete(todoTable, where: "$id = ?", whereArgs: [todoId]);
      return rowsAffected != null && rowsAffected != 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<TodoDTO>?> getAllTodoEntries() async {
    try {
      var dbClient = await DbInit.db;
      List<Map<String, dynamic>>? maps = await dbClient?.query(
        todoTable,
        columns: [id, name, description],
      );
      List<TodoDTO> elementList = [];

      /// Gets all todos from local database and stores information in
      /// Todo Data Transfer Objects
      if (maps!.isNotEmpty) {
        for (Map map in maps) {
          elementList.add(TodoDTO(
              description: map[description], todoName: map[name], id: map[id]));
        }
      }
      return elementList;
    } catch (e) {
      log("Error in getAllTodoEntries.", error: e);
      return null;
    }
  }

  @override
  Future<TodoDTO?> getTodoEntry(String todoId) async {
    try {
      var dbClient = await DbInit.db;
      List<Map<String, dynamic>>? map = await dbClient?.query(todoTable,
          columns: [id, name, description],
          where: '$id = ?',
          whereArgs: [todoId]);
      return TodoDTO(
          description: map?[0][id],
          todoName: map?[0][name],
          id: map?[0][description]);
    } catch (e) {
      log("Error in getScheduleEntry.", error: e);
      return null;
    }
  }
}
