import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  // run this method if it's the 1st time ever opening
  void createInitialData() {
    toDoList = [
      ["Go to College", false],
      ["Attend the classes", false],
      ["Return back to hostel", false],
      ["Do the assignments", false]
    ];
  }

  // load the data from database
  void loadData() {
    // Access Hive box directly here
    toDoList = Hive.box('mybox').get("jj");
  }

  // update the database
  void updateDataBase() {}
}
