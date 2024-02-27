// timer.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';

class TimerPage extends StatelessWidget {
  final Function(TimeOfDay) scheduleNotification;

  const TimerPage({super.key, required this.scheduleNotification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Picker Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showTimePicker(context);
          },
          child: const Text('Open Time Picker'),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      scheduleNotification(picked);
    }
  }
}

class TimerHandler {
  Future<void> scheduleNotification(TimeOfDay selectedTime) async {
    tz.initializeTimeZones();
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, selectedTime.hour, selectedTime.minute);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alert_notification', // Update with your channel ID
      'Alert Notification', // Update with your channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: 'timer.png', // Specify the resource name of the icon from the assets folder
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'This is your scheduled notification.',
      scheduledTime,
      platformChannelSpecifics,
      //androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'customData',
    );

    Logger().i(
        'Notification scheduled for ${selectedTime.hour}:${selectedTime.minute}');
  }
}
