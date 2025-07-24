import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showNowNotification(String title, String body) async {
  const androidDetails = AndroidNotificationDetails(
    'jadwal_channel',
    'Jadwal Notifikasi',
    importance: Importance.max,
    priority: Priority.high,
  );

  const notifDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notifDetails,
  );
}

Future<void> scheduleNotification({
  required String title,
  required String body,
  required DateTime scheduledTime,
  required int id,
}) async {
  const androidDetails = AndroidNotificationDetails(
    'jadwal_channel',
    'Jadwal Notifikasi',
    importance: Importance.max,
    priority: Priority.high,
  );

  final notifDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledTime, tz.local),
    notifDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
