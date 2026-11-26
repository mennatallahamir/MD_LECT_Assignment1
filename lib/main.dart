import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  String _name = '';
  int _level = 1;
  int _age = 0;
  int _birthYear = 0;
  int _birthMonth = 0;
  int _birthDay = 0;
  bool _isSubmitted = false;

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2002),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  DateTime? _parseBirthDate(String input) {
    DateTime? date = DateTime.tryParse(input);
    if (date != null) {
      return date;
    }

    List<String> parts = input.contains('/')
        ? input.split('/')
        : input.split('-');
    if (parts.length == 3) {
      int? year = int.tryParse(parts[0]);
      int? month = int.tryParse(parts[1]);
      int? day = int.tryParse(parts[2]);
      if (year != null && month != null && day != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  void _processInputs() {
    DateTime? birthDate = _parseBirthDate(_birthDateController.text.trim());
    if (birthDate == null) {
      return;
    }

    setState(() {
      _name = _nameController.text.trim();
      int level = int.tryParse(_levelController.text.trim()) ?? 1;

      if (level < 1) {
        level = 1;
      } else if (level > 4) {
        level = 4;
      }

      _level = level;

      DateTime now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      _age = age;
      _birthYear = birthDate.year;
      _birthMonth = birthDate.month;
      _birthDay = birthDate.day;

      _isSubmitted = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignment 1')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _birthDateController,
              decoration: InputDecoration(
                labelText: 'Birthdate (YYYY-MM-DD)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _levelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Level in College (1 to 4)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _processInputs,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 24),
            if (_isSubmitted) ...[
              IconButton(
                iconSize: 90,
                icon: Image.asset('assets/$_level.png'),
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              Text('Age: $_age', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              Text(
                'Year of birth: $_birthYear',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                'Month of birth: $_birthMonth',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                'Day of birth: $_birthDay',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Hi $_name, you are in level $_level, and your month of birth is $_birthMonth',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
