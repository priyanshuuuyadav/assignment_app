import 'package:appignment_app/controllers/task_services.dart';
import 'package:appignment_app/views/screens/update_task_screen.dart';
import 'package:appignment_app/views/utils/extensions/app_extensions.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../models/task_model.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              AuthService.signOut(context);
            },
            label: Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            icon: Icon(
              Icons.login_outlined,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: TaskServices.getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("You have not defined any tasks"));
          }
          List<TaskModel>? tasks = snapshot.data;
          return ListView.builder(
            itemCount: tasks!.length,
            itemBuilder: (context, index) {
              TaskModel task = tasks[index];
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 5, left: 10, right: 10, top: 5),
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  shape: BoxShape.rectangle,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Deadline:"),
                                  PhysicalModel(
                                      color: Colors.black87,
                                      elevation: 1,
                                      borderRadius: BorderRadius.circular(4),
                                      shape: BoxShape.rectangle,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Text(
                                          "${task.deadline?.date!.formate} | ${task.deadline?.time?.format(context)}" ??
                                              "",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                              Text(task.title ?? "",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(task.description ?? ""),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Expected Duration:"),
                                  PhysicalModel(
                                      color: Colors.black87,
                                      elevation: 1,
                                      borderRadius: BorderRadius.circular(4),
                                      shape: BoxShape.rectangle,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Text(
                                          "${task.expectedDuration?.date!.formate} | ${task.expectedDuration?.time?.format(context)}" ??
                                              "",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Chip(
                                avatar: Icon(
                                  task.completed == true
                                      ? Icons.done
                                      : Icons.clear,
                                  color: task.completed == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                label: Text(
                                  task.completed == true
                                      ? "Complete"
                                      : "Incomplete",
                                  style: TextStyle(
                                      color: task.completed == true
                                          ? Colors.green
                                          : Colors.red),
                                ),
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: task.completed == true
                                        ? Colors.green
                                        : Colors.red,
                                    width: 2,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  task.completed != true
                                      ? IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateTaskScreen(
                                                          taskModel: task),
                                                ));
                                          },
                                          icon: Icon(Icons.edit),
                                        )
                                      : Text(""),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Task deletion"),
                                            content: const Text(
                                                "Are you sure want to delete this task?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No")),
                                              TextButton(
                                                  onPressed: () {
                                                    TaskServices.deleteTask(
                                                      context,
                                                        task.taskId ?? "",
                                                        task.notificationId ??
                                                            1);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Yes"))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
