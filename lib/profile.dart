import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _email;
  late String _password;
  late DateTime _birthdate;
  late String _address;
  late String _gender;
  bool _obscurePassword = true;  // Untuk buka/tutup tampilan password

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _email = prefs.getString('email') ?? '';
      _password = prefs.getString('password') ?? '';  // Ambil password
      _birthdate = DateTime.parse(prefs.getString('birthdate') ?? DateTime.now().toIso8601String());
      _address = prefs.getString('address') ?? '';
      _gender = prefs.getString('gender') ?? 'Male';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();  // Memuat data pengguna saat inisialisasi
  }

  @override
  Widget build(BuildContext context) {
    final formattedBirthdate = DateFormat('dd-MM-yyyy').format(_birthdate);  // Format tanggal lahir

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              prefs.remove('loggedInUser');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),  // Kembali ke halaman login
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $_email'),
            SizedBox(height: 16),
            Text('Birthdate: $formattedBirthdate'),  // Tanggal lahir terformat
            SizedBox(height: 16),
            Text('Address: $_address'),
            SizedBox(height: 16),
            Text('Gender: $_gender'),
            SizedBox(height: 16),
            TextField(
              obscureText: _obscurePassword,  // Buka/tutup tampilan password
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;  // Ganti mode tampilan
                    });
                  },
                ),
              ),
              controller: TextEditingController(text: _password),  // Isi field dengan password
            ),
          ],
        ),
      ),
    );
  }
}
