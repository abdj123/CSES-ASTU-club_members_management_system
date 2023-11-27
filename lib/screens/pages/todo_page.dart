import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class TodoPage extends StatefulWidget {
//   const TodoPage({super.key});

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TextEditingController _taskController;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _saveTask(String task) {
    DateTime now = DateTime.now();
    String todayKey = 'tasks_${now.year}_${now.month}_${now.day}';
    List<String> tasks = _prefs.getStringList(todayKey) ?? [];
    tasks.add(task);
    _prefs.setStringList(todayKey, tasks);
  }

  void _deleteTasks() {
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    String yesterdayKey =
        'tasks_${yesterday.year}_${yesterday.month}_${yesterday.day}';
    _prefs.remove(yesterdayKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: 'Enter a task'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  _saveTask(_taskController.text);
                  _taskController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task saved for today'),
                    ),
                  );
                }
              },
              child: const Text('Save Task'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _deleteTasks();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tasks deleted for yesterday'),
                  ),
                );
              },
              child: const Text('Delete Tasks from Yesterday'),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
