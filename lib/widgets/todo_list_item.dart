import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  TodoListItem({Key? key, required this.todo, required this.onDelete}) : super(key: key);
  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:[
              Colors.blueGrey.shade500,
              Colors.white,

            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(todo.date),
                style: TextStyle(
                  fontSize: 12,
                ),),
              Text(todo.title, style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
            ]),
          ),
          actionExtentRatio:0.2 ,
          actionPane:const SlidableStrechActionPane(),
          secondaryActions: [
          IconSlideAction(
          color:Colors.redAccent,
          icon: Icons.delete_forever_sharp,
          caption: 'Deletar',
          onTap: () {
            onDelete(todo);
          },
        ),
          ],
      ),
    );
  }

}
