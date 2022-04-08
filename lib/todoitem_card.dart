import 'package:flutter/material.dart';
import 'package:flutter_todo_app/todo_card.dart';

// ignore: must_be_immutable
class TodoItemCard extends StatefulWidget {
  String name;
  String? index;
  String? description;
  bool isChecked;

  TodoItemCard(
      {Key? key,
      required this.name,
      this.index,
      this.description,
      this.isChecked = false})
      : super(key: key);
  @override
  State<TodoItemCard> createState() => _TodoItemCardState();
}

class _TodoItemCardState extends State<TodoItemCard> {
  late bool _isChecked;

  @override
  initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            activeColor: Colors.green,
            checkColor: Colors.white,
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
                widget.isChecked = _isChecked;
              });
            },
          ),
        ),
        Expanded(
            child: TodoCard(name: widget.name, description: widget.description))
      ],
    );
  }
}
