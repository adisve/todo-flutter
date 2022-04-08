class TodoDTO {
  final String todoName;
  final String? description;
  final String id;

  TodoDTO(
      {required this.todoName, required this.description, required this.id});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> tableMap = {};
    tableMap["todo_name"] = todoName;
    tableMap["description"] = description;
    tableMap["id"] = id;
    return tableMap;
  }
}
