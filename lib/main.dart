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
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _usiaController = TextEditingController();
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

  // Clear text fields
  void _clearFields() {
    _namaController.clear();
    _jobController.clear();
    _usiaController.clear();
  }

  // Add user
  Future<void> _addUser() async {
    if (_namaController.text.isEmpty ||
        _jobController.text.isEmpty ||
        _usiaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    await DatabaseHelper.addUser(
      _namaController.text,
      _jobController.text,
      int.parse(_usiaController.text),
    );
    _refreshUsers();
    _clearFields();
  }

  // Update user dialog
  Future<void> _showUpdateDialog(Map<String, dynamic> user) async {
    _namaController.text = user['nama_user'];
    _jobController.text = user['job'];
    _usiaController.text = user['usia'].toString();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: _jobController,
                decoration: const InputDecoration(labelText: 'Pekerjaan'),
              ),
              TextField(
                controller: _usiaController,
                decoration: const InputDecoration(labelText: 'Usia'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.updateUser(
                user['id'],
                _namaController.text,
                _jobController.text,
                int.parse(_usiaController.text),
              );
              _refreshUsers();
              _clearFields();
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Delete confirmation dialog
  Future<void> _showDeleteDialog(int id) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.deleteUser(id);
              _refreshUsers();
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
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
            child: Column(
              children: [
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama User',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _jobController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pekerjaan',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _usiaController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Usia',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addUser,
                  child: const Text('Tambah User'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () => _showUpdateDialog(_users[index]),
                    title: Text(_users[index]['nama_user']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pekerjaan: ${_users[index]['job']}'),
                        Text('Usia: ${_users[index]['usia']} tahun'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(_users[index]['id']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jobController.dispose();
    _usiaController.dispose();
    super.dispose();
  }
}
