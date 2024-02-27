import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:planmeout/data/database.dart';
import 'package:planmeout/util/dialog_box.dart';
import 'package:planmeout/util/todo_tile.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ToDoDataBase db = ToDoDataBase();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('timer');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false, null]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
  }

  final TextEditingController _controller = TextEditingController();

  Future<void> setTimerForTask(BuildContext context, List<dynamic> todo) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        todo[2] = Duration(hours: picked.hour, minutes: picked.minute);
      });

      scheduleNotification(todo);
    }
  }

  Future<void> scheduleNotification(List<dynamic> todo) async {
    if (todo.length >= 3) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'alert_notifications',
        'Alert Notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        icon: 'timer', // Replace with your app icon's name in the assets folder
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      final DateTime now = DateTime.now();
      final DateTime scheduledDate = now.add(todo[2]);
      final tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Task Reminder',
        'Don\'t forget to complete ${todo[0]}!',
        scheduledDateTime,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'customData',
      );
    } else {
      // Handle the error gracefully (optional)
    }
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
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
            setTimerFunction: (context) =>
                setTimerForTask(context, db.toDoList[index]),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
