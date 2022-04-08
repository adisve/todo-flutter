// ignore_for_file: deprecated_member_use
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_todo_app/database/todo_repository.dart';
import 'package:flutter_todo_app/todoitem_card.dart';

import 'database/todo_dto.dart';

/// Page of todo items that the user can manipulate
class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool _loading = false;
  String codeDialog = '';
  String valueText = '';
  String todoName = '';
  String todoDescription = '';
  final myController = TextEditingController();
  List<TodoItemCard> _todoItemCardList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(33, 34, 39, 100),
        body: Stack(
          children: [
            Container(
              child: () {
                if (_loading) {
                  return const SpinKitWanderingCubes(
                    color: Colors.green,
                    size: 50.0,
                  );
                }
                if (_todoItemCardList.isEmpty) {
                  return Center(
                    child: Text(
                      "No to-do items",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                } else {
                  /// Returns a list view of Todo items in the form of
                  /// TodoItemCards. When you press one item it
                  /// will expand showing a detailed description, which
                  /// is optional for the user to provide.
                  return ListView.separated(
                    padding: const EdgeInsets.only(
                        top: 55, left: 10, right: 10, bottom: 10),
                    scrollDirection: Axis.vertical,
                    itemCount: _todoItemCardList.length,
                    itemBuilder: ((context, index) {
                      return _todoItemCardList[index];
                    }),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  );
                }
              }(),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  padding: const EdgeInsets.all(30),
                  child: ElevatedButton(
                    onPressed: () {
                      _createNewListItem(context, myController);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: const BorderSide(color: Colors.green)))),
                    child: const Icon(Icons.add),
                  )),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    padding: const EdgeInsets.all(30),
                    child: ElevatedButton(
                      onPressed: () {
                        _removeCheckedListItems();
                        _updateDatabase();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: const BorderSide(color: Colors.red)))),
                      child: const Icon(Icons.remove),
                    )))
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _updateSession();
  }

  void _updateDatabase() async {
    setState(() {
      _loading = true;
    });
    await TodoRepository.deleteAllTodos();

    /// Assign each item in _todoItemCardList to a new list of database
    /// DTO's
    for (var i = 0; i < _todoItemCardList.length; i++) {
      TodoRepository.addTodoEntry(TodoDTO(
          todoName: _todoItemCardList[i].name,
          description: _todoItemCardList[i].description,
          id: i.toString()));
    }
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _loading = false;
    });
  }

  /// Fetches all todo items from database and assigns
  /// them to current list state
  void _updateSession() {
    List<TodoItemCard> temp = [];
    TodoRepository.getAllTodoEntries().then((_databaseList) {
      for (var todo in _databaseList!) {
        temp.add(TodoItemCard(
            name: todo.todoName,
            description: todo.description,
            index: todo.id,
            isChecked: false));
      }
      setState(() {
        _todoItemCardList = temp;
      });
    });
  }

  void _addTodoItemCard(TodoItemCard todoItemCard) async {
    setState(() {
      todoItemCard.index = (_todoItemCardList.length - 1).toString();
      _todoItemCardList.add(todoItemCard);
    });
    await TodoRepository.addTodoEntry(TodoDTO(
        description: todoItemCard.description,
        id: (_todoItemCardList.length - 1).toString(),
        todoName: todoItemCard.name));
  }

  /// Removes list items in bulk to avoid messing with subsequent iteration
  /// of the _todoItemCardList
  void _removeCheckedListItems() {
    List<TodoItemCard> toRemove = [];
    for (var todo in _todoItemCardList) {
      if (todo.isChecked) {
        toRemove.add(todo);
        setState(() {
          TodoRepository.deleteTodo(todo.index!);
        });
      }
    }
    setState(() {
      _todoItemCardList.removeWhere((todo) => toRemove.contains(todo));
    });
    toRemove.clear();
  }

  /// Function to display a popup in case the
  /// user presses the 'add todo' button
  Future<void> _showCreateTodoItem(
      BuildContext context, TextEditingController myController) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Todo'),
            content: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: myController,
              decoration: const InputDecoration(hintText: "New Todo"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('ADD'),
                onPressed: () {
                  setState(() {
                    todoName = valueText;
                    myController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _showCreateDescription(
      BuildContext context, TextEditingController myController) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Description'),
            content: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: myController,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('ADD'),
                onPressed: () {
                  setState(() {
                    todoDescription = valueText;
                    myController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void _createNewListItem(
      BuildContext context, TextEditingController myController) async {
    await _showCreateTodoItem(context, myController);

    /// Check to see if user did not enter a mandatory todo name
    if (todoName == '') return;

    valueText = '';
    await _showCreateDescription(context, myController);
    valueText = '';
    _addTodoItemCard(
        TodoItemCard(name: todoName, description: todoDescription));
    _updateDatabase();
    todoName = '';
    todoDescription = '';
  }
}
