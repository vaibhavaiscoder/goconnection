import 'dart:convert';
import 'package:flutter/material.dart';
import 'task.dart'; // Import the model class
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Task> tasks = [];

  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse('http://192.168.1.4:8080/gettasks'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final List<Task> fetchedTasks = jsonData.map((taskData) {
        return Task(
          id: taskData['id'],
          taskName: taskData['task_name'],
          taskDetail: taskData['task_detail'],
          date: taskData['date'],
        );
      }).toList();

      setState(() {
        tasks = fetchedTasks;
      });
    } else {
      print('Failed to fetch tasks');
    }
  }
  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Task List'),
        ),
        body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task.taskName),
              subtitle: Text(task.taskDetail),
              trailing: Text(task.date),
            );
          },
        ),
      ),
    );
  }

}
