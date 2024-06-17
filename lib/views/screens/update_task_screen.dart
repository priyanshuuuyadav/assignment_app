import 'package:appignment_app/views/app_widgets/app_widgets.dart';
import 'package:appignment_app/views/utils/extensions/app_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/task_services.dart';
import '../../models/task_model.dart';

class UpdateTaskScreen extends StatefulWidget {
  TaskModel taskModel = TaskModel();

  UpdateTaskScreen({super.key, required this.taskModel});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  DateTime? deadlineSelectedDate;
  DateTime? expectedDurationSelectedDate;
  TimeOfDay? deadlineSelectedTime;
  TimeOfDay? expectedDurationSelectedTime;
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
  bool? task;

  TaskModel get taskModel => widget.taskModel;

  Future<DateTime> _selectDate(
      BuildContext context, DateTime initialDate) async {
    var data = await showDatePicker(
      context: context,
      initialDate: deadlineSelectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return data!;
  }

  Future<TimeOfDay> _selectTime(
      BuildContext context, TimeOfDay initialTime) async {
    var time = await showTimePicker(
      context: context,
      initialTime: deadlineSelectedTime ?? TimeOfDay(hour: 0, minute: 0),
    );
    return time!;
  }

  @override
  void initState() {
    task = widget.taskModel.completed;
    titleController.text = taskModel.title ?? "";
    descriptionController.text = taskModel.description ?? "";
    deadlineSelectedDate = widget.taskModel.deadline?.date;
    deadlineSelectedTime = widget.taskModel.deadline?.time;
    expectedDurationSelectedDate = widget.taskModel.expectedDuration?.date;
    expectedDurationSelectedTime = widget.taskModel.expectedDuration?.time;
    deadlineSelectedDateController.text =
        widget.taskModel.deadline?.date?.formate ?? "";
    expectedDurationSelectedDateController.text =
        widget.taskModel.expectedDuration?.date?.formate ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deadlineSelectedTimeController.text =
        widget.taskModel.deadline?.time?.format(context) ?? "";
    expectedDurationSelectedTimeController.text =
        widget.taskModel.expectedDuration?.time?.format(context) ?? "";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Update Task",style:  TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
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
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  hintText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onTap: () async {
                        deadlineSelectedDate =
                            await _selectDate(context, deadlineSelectedDate!);
                        deadlineSelectedDateController.text =
                            deadlineSelectedDate!.formate;
                      },
                      readOnly: true,
                      controller: deadlineSelectedDateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.date_range),
                        label: Text("Deadline Date"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      onTap: () async {
                        deadlineSelectedTime =
                            await _selectTime(context, deadlineSelectedTime!);
                        deadlineSelectedTimeController.text =
                            deadlineSelectedTime!.format(context);
                      },
                      readOnly: true,
                      controller: deadlineSelectedTimeController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.access_time_outlined),
                        label: Text("Deadline time"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onTap: () async {
                        expectedDurationSelectedDate =
                            await _selectDate(context, deadlineSelectedDate!);
                        expectedDurationSelectedDateController.text =
                            expectedDurationSelectedDate!.formate;
                      },
                      readOnly: true,
                      controller: expectedDurationSelectedDateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.date_range),
                        label: Text("Expected date"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      onTap: () async {
                        expectedDurationSelectedTime = await _selectTime(
                            context, expectedDurationSelectedTime!);
                        expectedDurationSelectedTimeController.text =
                            expectedDurationSelectedTime!.format(context);
                      },
                      readOnly: true,
                      controller: expectedDurationSelectedTimeController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.access_time_rounded),
                        label: Text("Expected time"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                child: Chip(
                  avatar: Icon(
                    task == true
                        ? Icons.done
                        : Icons.clear,
                    color: task == true
                        ? Colors.green
                        : Colors.red,
                  ),
                  label: Text(
                    task == true
                        ? 'Complete'
                        : 'Incomplete',
                    style: TextStyle(
                        color: task == true
                            ? Colors.green
                            : Colors.red),
                  ),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: task == true
                          ? Colors.green
                          : Colors.red,
                      width: 2,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    task = !task!;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: btnStyle,
                  onPressed: () {
                    TaskModel taskModel = TaskModel(
                        taskId: widget.taskModel.taskId ?? "",
                        userId: FirebaseAuth.instance.currentUser?.uid,
                        notificationId: widget.taskModel.notificationId,
                        title: titleController.text,
                        description: descriptionController.text,
                        completed: task,
                        deadline: Deadline(
                          date: deadlineSelectedDate,
                          time: deadlineSelectedTime,
                        ),
                        expectedDuration: Deadline(
                          date: expectedDurationSelectedDate,
                          time: expectedDurationSelectedTime,
                        ));
                    TaskServices.updateTask(
                        context, taskModel.taskId ?? "", taskModel);
                    print(taskModel.taskId);
                  },
                  child: Text("Update", style: btnTextStyle,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
