import 'package:flutter/material.dart';

import 'models/data.dart';
import 'root.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedin = false;
  bool isLoginFailed = false;

  void _login() {
    //logic dari UI kemarin
    String username = _usernameController.text; //iniiasi, variabel username ngambil nilai dari controller teksnya, dari input (.text)
    String password = _passwordController.text; //ini juga sama
    if (username == user1.username && password == user1.password) {
      setState(() {
        isLoggedin = true;
        isLoginFailed = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Root(nama: user1.nama)),
      );
    } else {
      setState(() {
        isLoggedin = false;
        isLoginFailed = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Incorrect username or password.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFF9800),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isLoggedin) ...[
                Text('This is Login Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _usernameField(_usernameController, isLoginFailed),
                _passwordField(_passwordController, isLoginFailed),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    minimumSize: Size(200, 45),
                  ),
                  child: Text('Login'),
                ),
              ] else ...[
                //kalo login bener akan merujuk kesini
                Text('Halo, ${user1.nama}!'),
                SizedBox(height: 20),
                Text('Pasti username kamu: ${user1.username}'),
                Text('Pasti password kamu: ${user1.password}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Widget _usernameField(TextEditingController controller, bool isLoginFailed) {
  return _inputField(
    controller: controller,
    hint: 'Username',
    isLoginFailed: isLoginFailed,
  );
}

Widget _passwordField(TextEditingController controller, bool isLoginFailed) {
  return _inputField(
    controller: controller,
    hint: 'Password',
    isLoginFailed: isLoginFailed,
    obscure: true,
  );
}

Widget _inputField({
  required TextEditingController controller,
  required String hint,
  required bool isLoginFailed,
  bool obscure = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      enabled: true,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.all(8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: const Color(0xFFFF9800)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            color: isLoginFailed ? Colors.red : const Color(0xFFFF9800),
            width: 2.0,
          ),
        ),
      ),
    ),
  );
}
