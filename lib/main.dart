import 'package:flutter/material.dart';
import 'database/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _namaController = TextEditingController();
  List<Map<String, dynamic>> _users = [];

  void _refreshUsers() async {
    final data = await DatabaseHelper.getUsers();
    setState(() {
      _users = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  Future<void> _addUser() async {
    await DatabaseHelper.addUser(_namaController.text);
    _refreshUsers();
    _namaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama User',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addUser,
            child: const Text('Tambah User'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(_users[index]['nama_user']),
                    subtitle: Text('ID: ${_users[index]['id']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
