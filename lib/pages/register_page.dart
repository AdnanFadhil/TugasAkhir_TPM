import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Services/user_hive.dart';
import '../Services/enkripsian.dart';
import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _validatorController = TextEditingController();

  bool _isErrorVisible = false;
  bool _isPasswordHidden = true;

  Future<void> _signup() async {
    String? username = _usernameController.text;
    String? password = _passwordController.text;
    String? validator = _validatorController.text;

    bool isUserValid = false;

    if (password == validator) {
      isUserValid = true;
    }

    if (isUserValid && username != null && password != null) {
      await addUser(username, password);

      setState(() {
        _isErrorVisible = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      setState(() {
        _isErrorVisible = true;
      });
    }

    _passwordController.clear();
  }

  Future<void> addUser(String username, String password) async {
    var box = await Hive.openBox<UserHive>('users');
    var user = UserHive()
      ..username = username
      ..password =
          EncryptionUtils.encryptString(password); // Encrypt the password
    await box.add(user);
  }

  String _getErrorText() {
    if (_usernameController.text.isEmpty && _passwordController.text.isEmpty) {
      return 'Username dan password belum diisi.';
    } else if (_usernameController.text.isEmpty) {
      return 'Username belum diisi.';
    } else if (_passwordController.text.isEmpty) {
      return 'Password belum diisi.';
    } else {
      return 'Periksa kembali username dan password Anda.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.ac_unit_rounded,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'Isi sesuai data anda',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    labelText: 'Masukkan Username',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      child: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _validatorController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: 'Validasi Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      child: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isErrorVisible,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      _getErrorText(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _signup,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
