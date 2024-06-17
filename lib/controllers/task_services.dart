import 'package:appignment_app/controllers/notifications.dart';
import 'package:appignment_app/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskServices {
  static final FirebaseFirestore _firebaseFireStore =
      FirebaseFirestore.instance;

  static Future<void> createTask(
      BuildContext context, TaskModel taskModel) async {
    try {
      await _firebaseFireStore
          .collection("tasks")
          .doc(taskModel.taskId)
          .set(taskModel.toJson())
          .whenComplete(
        () {
          DateTime dateTime = combineDateAndTime(taskModel.deadline!.date!,
              convertTimeOfDayToTimestamp(taskModel.deadline!.time!).toDate());
          LocalNotificationServices.showNotification(
              notificationId: taskModel.notificationId ?? 0,
              dateTime: dateTime,
              body: taskModel.description,
              title: taskModel.title);
          Navigator.pop(context);
        },
      );
    } catch (e) {
      print("Error : $e");
    }
  }

  static Stream<List<TaskModel>> getTasks() {
    return _firebaseFireStore
        .collection("tasks")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data()))
            .toList());
  }

  static Future<void> updateTask(
      BuildContext context, String taskId, TaskModel taskModel) async {
    try {
      await _firebaseFireStore
          .collection("tasks")
          .doc(taskId)
          .update(taskModel.toJson())
          .whenComplete(
        () {
          DateTime dateTime = combineDateAndTime(taskModel.deadline!.date!,
              convertTimeOfDayToTimestamp(taskModel.deadline!.time!).toDate());
          LocalNotificationServices.showNotification(
              notificationId: taskModel.notificationId ?? 0,
              dateTime: dateTime,
              body: taskModel.description,
              title: taskModel.title);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Update successful")),
          );
        },
      );
    } catch (e) {
      print("Error : $e");
    }
  }

  static Future<void> deleteTask(
      BuildContext context, String taskId, int notificationId) async {
    try {
      print(taskId);
      await _firebaseFireStore
          .collection("tasks")
          .doc(taskId)
          .delete()
          .whenComplete(
        () {
          LocalNotificationServices.flutterLocalNotificationsPlugin
              .cancel(notificationId);
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update successful")));
    } catch (e) {
      print("Error : $e");
    }
  }
}
