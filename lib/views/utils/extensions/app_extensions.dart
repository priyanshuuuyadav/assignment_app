import 'package:appignment_app/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateFormators on DateTime{
 String get formate => DateFormat.yMMMMd('en_US').format(this);
}
