import 'package:flutter/material.dart';
import 'package:planmeout/util/dialog_box.dart';
import 'package:planmeout/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // list of to do tasks
  List toDoList = [
    ["Go to College", false],
    ["Come back to hostel", false],
    ["Take a Shower", false],
  ];

  // checkbox was touched
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index] [1] = !toDoList[index][1];
    });
  }

  // new task creation
  void createNewTask () {
    showDialog(
      context: context,
      builder: (context) {
        return const DialogBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],

      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'PLAN ME OUT',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,  
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
          );
        },
      )
    );
  }
}