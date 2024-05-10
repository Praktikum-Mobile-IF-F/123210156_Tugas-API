import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Untuk menyimpan dan mengambil data

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final registeredEmail = prefs.getString('email');
    final registeredPassword = prefs.getString('password');

    if (_emailController.text == registeredEmail && _passwordController.text == registeredPassword) {
      // Login berhasil, arahkan ke halaman home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Login gagal, tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bidang input email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),  // Jeda antara bidang input

              // Bidang input password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _passwordController.text = _passwordController.text.isNotEmpty ? '' : _passwordController.text;
                      });
                    },
                  ),
                ),
                obscureText: true,  // Menyembunyikan teks
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),  // Jeda antara bidang input

              // Tombol untuk login
              ElevatedButton(
                onPressed: () {
                  _login(context);  // Validasi login
                },
                child: Text('Login'),
              ),
              SizedBox(height: 16),  // Jeda antara tombol

              // Tombol untuk navigasi ke halaman registrasi
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');  // Navigasi ke halaman registrasi
                },
                child: Text(
                  'Don\'t have an account? Register here',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
