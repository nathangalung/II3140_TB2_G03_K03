import 'package:flutter/material.dart';
import 'package:curiosityclash/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curiosityclash/main-page/register-page.dart';
import 'package:curiosityclash/widgets/loginRegister-footer.dart';
import 'package:curiosityclash/widgets/bottomNavbar-widget.dart';
import 'package:curiosityclash/services/api.dart';

import '../models/UserModel.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: isSmallScreen
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _Logo(),
                  _FormContent(),
                ],
              )
                  : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: const [
                    Expanded(child: _Logo()),
                    Expanded(child: Center(child: _FormContent())),
                  ],
                ),
              ),
            ),
          ),
          const Footer(), // Footer berada di bawah
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0), // Menambahkan padding 30 dari atas
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Teks Login
          Text(
            "Login", // Header "Login"
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              textStyle: TextStyle(
                color: AppTheme.darkTheme.primaryColor, // Menggunakan warna utama tema
                fontWeight: FontWeight.bold,
                fontSize: 50, // Ukuran font Login
              ),
            ),
          ),
          const SizedBox(height: 8), // Menambah jarak antara teks
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Welcome back! Please sign in to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF032B44)), // Warna teks deskripsi
            ),
          ),
        ],
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isValid = true;
  bool _isLoggedIn = false;
  String? _sessionId;

  final ApiService _apiService = ApiService();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      UserModel user = await _apiService.login(username, password);
      setState(() {
        _isLoggedIn = true;
        _sessionId = user.id; // Store the session ID
        _isValid = true; // Reset the error state
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavBar(sessionId: _sessionId!),
        ),
      );
    } catch (e) {
      setState(() {
        _isValid = false; // Set the error state
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Error'),
            backgroundColor: Colors.black,
            content: const Text('Invalid username or password. Please try again.', style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.darkTheme.primaryColor;

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: TextStyle(color: AppTheme.darkTheme.primaryColor),
              decoration: InputDecoration(
                labelText: 'Username',
                errorText: _isValid ? null : 'Invalid username or password',
                labelStyle: TextStyle(color: AppTheme.darkTheme.primaryColor),
                hintText: 'Enter your username',
                hintStyle: TextStyle(color: AppTheme.darkTheme.primaryColor),
                prefixIcon: Icon(Icons.person_outline, color: primaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor, width: 5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor, width: 2),
                ),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _isValid ? null : 'Invalid username or password',
                labelStyle: TextStyle(color: primaryColor),
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: primaryColor),
                prefixIcon: Icon(Icons.lock_outline_rounded, color: primaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _login();
                  }
                },
              ),
            ),
            _gap(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ", style: TextStyle(color: Colors.black)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}