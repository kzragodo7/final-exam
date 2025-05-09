import 'package:flutter/material.dart';

void main() => runApp(const ToDo());


class ToDo extends StatelessWidget {
  const ToDo({super.key});

  static const blue = Color(0xff0056B3);
  static const yellow = Color.fromARGB(255, 247, 255, 10);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'To-Do List',
    debugShowCheckedModeBanner: false,
      home: ToDoHomePage(),
      theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: blue,
        foregroundColor: yellow),
      ),
    );
    
  }
  }

class ToDoHomePage extends StatefulWidget {
  @override
  
  _ToDoHomePageState createState() => _ToDoHomePageState();
}
  class _ToDoHomePageState extends State<ToDoHomePage> {
    List<String> _tasks = [];
    List<String> _filteredTasks = [];
    final TextEditingController _taskController = TextEditingController();
    final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
  super.initState();
  _searchController.addListener(_filter);
  }

void _filter() {
String query = _searchController.text.toLowerCase();
setState(() {
_filteredTasks = _tasks
.where((task) => task.toLowerCase().contains(query))
.toList();
});
}

void _addTask(String task) {
if (task.isNotEmpty) {
setState(() {
_tasks.add(task);
_taskController.clear();
_filter(); // update filtered list
});
}
}

void _editTask(int index) {
_taskController.text = _filteredTasks[index];
int actualIndex = _tasks.indexOf(_filteredTasks[index]);

showDialog(
context: context,
builder: (_) => AlertDialog(
title: Text('Edit Task'),
content: TextField(controller: _taskController),
actions: [
TextButton(
onPressed: () {
setState(() {
_tasks[actualIndex] = _taskController.text;
_taskController.clear();
_filter();
});
Navigator.pop(context);
},
child: Text('Save'),
),
],
),
);
}

void _deleteTask(int index) {
    setState(() {
      _tasks.remove(_filteredTasks[index]);
      _filter();
    });
  }

  @override
  Widget build(BuildContext context) {
    _filteredTasks = _searchController.text.isEmpty
    ? _tasks
    : _tasks
    .where((task) => task.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Tasks...',
            prefixIcon: Icon(Icons.search),
          ),
        ),),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [ Expanded(child: TextField(
            controller: _taskController,
            decoration: InputDecoration(labelText: 'New Task'),
          ),),
          IconButton(icon: Icon(Icons.add),
          onPressed: () => _addTask(_taskController.text),
          ),
          ],
        ),),
        Expanded(child: _filteredTasks.isEmpty
        ? Center(child: Text('Not Found'))
        : ListView.builder(
          itemCount: _filteredTasks.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(_filteredTasks[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit),
                onPressed: () => _editTask(index),
                ),
                IconButton(icon: Icon(Icons.delete), 
                onPressed: () => _deleteTask(index),
                ),
              ],
            ),
          ),
        ),
      ),
          ],
      ),
    );
    }
}
