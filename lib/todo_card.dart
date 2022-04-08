import 'package:flutter/material.dart';

class TodoCard extends StatefulWidget {
  final String name;
  final String? description;

  const TodoCard({Key? key, required this.name, this.description})
      : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        title: Text(widget.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        textColor: Colors.black,
        onExpansionChanged: (bool isExpanding) => _onExpansion(isExpanding),
        children: <Widget>[
          ListTile(
            title: (widget.description != null || widget.description != '')
                ? Text(widget.description!)
                : const Text("No description provided"),
          )
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
    );
  }

  /// Something cool for
  _onExpansion(bool isExpanding) {
    setState(() {});
  }
}
