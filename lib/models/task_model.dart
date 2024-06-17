import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  String? userId;
  String? taskId;
  int? notificationId;
  String? title;
  String? description;
  Deadline? deadline;
  Deadline? expectedDuration;
  bool? completed;

  TaskModel({
    this.userId,
    this.taskId,
    this.notificationId,
    this.title,
    this.description,
    this.deadline,
    this.expectedDuration,
    this.completed,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        userId: json["userId"],
        taskId: json["taskId"],
        notificationId: json["notificationId"],
        title: json["title"],
        description: json["description"],
        deadline: json["deadline"] == null
            ? null
            : Deadline.fromJson(json["deadline"]),
        expectedDuration: json["expectedDuration"] == null
            ? null
            : Deadline.fromJson(json["expectedDuration"]),
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "taskId": taskId,
        "notificationId": notificationId,
        "title": title,
        "description": description,
        "deadline": deadline?.toJson(),
        "expectedDuration": expectedDuration?.toJson(),
        "completed": completed,
      };
}

class Deadline {
  DateTime? date;
  TimeOfDay? time;

  Deadline({
    this.date,
    this.time,
  });

  factory Deadline.fromJson(Map<String, dynamic> json) => Deadline(
        date: json["date"] == null
            ? null
            : convertTimestampToDateTime(json["date"]),
        time: json["time"] == null
            ? null
            : convertTimestampToTimeOfDay(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "time": time == null ? null : convertTimeOfDayToTimestamp(time!),
      };
}

TimeOfDay convertTimestampToTimeOfDay(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

Timestamp convertTimeOfDayToTimestamp(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  return Timestamp.fromDate(dateTime);
}

DateTime convertTimestampToDateTime(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
}

DateTime combineDateAndTime(DateTime dateOnly, DateTime timeOnly) {
  return DateTime(
    dateOnly.year,
    dateOnly.month,
    dateOnly.day,
    timeOnly.hour,
    timeOnly.minute,
    timeOnly.second,
    timeOnly.millisecond,
    timeOnly.microsecond,
  );
}
