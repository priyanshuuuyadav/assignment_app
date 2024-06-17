import 'dart:math';
import 'package:appignment_app/views/utils/extensions/app_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/task_services.dart';
import '../../models/task_model.dart';
import '../app_widgets/app_widgets.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime deadlineSelectedDate = DateTime.now();
  DateTime expectedDurationSelectedDate = DateTime.now();
  TimeOfDay deadlineSelectedTime = TimeOfDay.now();
  TimeOfDay expectedDurationSelectedTime = TimeOfDay.now();
  TextEditingController deadlineSelectedDateController =
      TextEditingController();
  TextEditingController expectedDurationSelectedDateController =
      TextEditingController();
  TextEditingController deadlineSelectedTimeController =
      TextEditingController();
  TextEditingController expectedDurationSelectedTimeController =
      TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<DateTime> _selectDate(
      BuildContext context, DateTime initialDate) async {
    var data = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return data ?? initialDate;
  }

  Future<TimeOfDay> _selectTime(
      BuildContext context, TimeOfDay initialTime) async {
    var time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    return time ?? initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Tasks", style: appBarTextStyle),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your title";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    hintText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your description";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onTap: () async {
                          deadlineSelectedDate =
                              await _selectDate(context, deadlineSelectedDate);
                          deadlineSelectedDateController.text =
                              deadlineSelectedDate.formate;
                        },
                        readOnly: true,
                        controller: deadlineSelectedDateController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          hintText: "Deadline Date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a deadline date";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        onTap: () async {
                          deadlineSelectedTime =
                              await _selectTime(context, deadlineSelectedTime);
                          deadlineSelectedTimeController.text =
                              deadlineSelectedTime.format(context);
                        },
                        readOnly: true,
                        controller: deadlineSelectedTimeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.access_time_outlined),
                          hintText: "Deadline time",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a deadline time";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onTap: () async {
                          expectedDurationSelectedDate = await _selectDate(
                              context, expectedDurationSelectedDate);
                          expectedDurationSelectedDateController.text =
                              expectedDurationSelectedDate.formate;
                        },
                        readOnly: true,
                        controller: expectedDurationSelectedDateController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          hintText: "Expected date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select an expected date";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        onTap: () async {
                          expectedDurationSelectedTime = await _selectTime(
                              context, expectedDurationSelectedTime);
                          expectedDurationSelectedTimeController.text =
                              expectedDurationSelectedTime.format(context);
                        },
                        readOnly: true,
                        controller: expectedDurationSelectedTimeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.access_time_rounded),
                          hintText: "Expected time",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select an expected time";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: btnStyle,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var taskId = FirebaseFirestore.instance
                            .collection('task')
                            .doc()
                            .id;
                        TaskModel taskModel = TaskModel(
                          taskId: taskId,
                          userId: FirebaseAuth.instance.currentUser?.uid,
                          notificationId: Random().nextInt(34567),
                          title: titleController.text,
                          description: descriptionController.text,
                          completed: false,
                          deadline: Deadline(
                            date: deadlineSelectedDate,
                            time: deadlineSelectedTime,
                          ),
                          expectedDuration: Deadline(
                            date: expectedDurationSelectedDate,
                            time: expectedDurationSelectedTime,
                          ),
                        );
                        TaskServices.createTask(context, taskModel);
                      }
                    },
                    child: Text("Submit", style: btnTextStyle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
