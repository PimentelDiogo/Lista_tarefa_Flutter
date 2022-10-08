import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/todo.dart';
import 'package:lista_tarefas/repositories/todo_repository.dart';
import '../../widgets/todo_list_item.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deleteTodo;
  int? deleteTodoPosition;
  String? errorText;

  @override
  void initState(){
    super.initState();
    todoRepository.getTodoList().then((value){
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration:  InputDecoration(
                            border:  OutlineInputBorder(),
                            labelText: 'Adicionar uma Tarefa',
                            hintText: 'Estudar mais tarde',
                            errorText: errorText,
                          labelStyle:const TextStyle( color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(

                      onPressed: () {
                        String text = todoController.text;
                        if (text.isEmpty){
                          setState(() {
                            errorText='Adicione uma tarefa!';
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            date: DateTime.now(),
                          );
                          todos.add(newTodo);
                        });
                        errorText = null;
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      child: Icon(
                        Icons.add,
                        size: 32,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
               const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Suas tarefas pendentes : ${todos.length}',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDeleteDialog,
                      child: Text('Limpar Tarefas'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: EdgeInsets.all(14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deleteTodo = todo;
    deleteTodoPosition = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa (${todo.title}) foi removida! '),
        backgroundColor: Colors.blueGrey,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              todos.insert(deleteTodoPosition!, deleteTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Vai apagar todas as suas tarefas?'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text('Cancelar', style: TextStyle(color: Colors.redAccent),)),
          TextButton(onPressed: () {
            Navigator.of(context).pop();
            deleteAllTodos();
          },  child: Text('Limpar Tudo')),
        ],
      ),
    );
  }
  void deleteAllTodos(){
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
