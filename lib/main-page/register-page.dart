import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curiosityclash/theme.dart'; // Sesuaikan dengan lokasi tema Anda
import 'package:curiosityclash/main-page/login-page.dart';
import 'package:curiosityclash/widgets/loginRegister-footer.dart'; // Sesuaikan dengan lokasi footer Anda
import 'package:curiosityclash/services/api.dart'; // Sesuaikan dengan lokasi API Anda
import 'package:curiosityclash/models/UserModel.dart'; // Sesuaikan dengan lokasi model Anda

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Bagian atas: Logo dan Form Content
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
          // Footer berada di bawah
          const Footer(),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Teks Register
        Text(
          "Register", // Header "Register"
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            textStyle: TextStyle(
              color: AppTheme.darkTheme.primaryColor, // Menggunakan warna utama tema
              fontWeight: FontWeight.bold,
              fontSize: 50, // Ukuran font Register
            ),
          ),
        ),
        const SizedBox(height: 8), // Menambah jarak antara teks
        // Teks Welcome!
        Text(
          "Create an account", // Teks "Create an account"
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoCondensed(
            textStyle: TextStyle(
              color: AppTheme.darkTheme.primaryColor, // Menggunakan warna utama tema
              fontWeight: FontWeight.bold,
              fontSize: 20, // Ukuran font untuk "Create an account"
            ),
          ),
        ),
      ],
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
  bool _isConfirmPasswordVisible = false;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = UserModel(
        name: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      try {
        await ApiService().register(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      } catch (e) {
        String errorMessage = e.toString();
        if (errorMessage.contains('Username already exists')) {
          errorMessage = 'Username is already registered';
        } else if (errorMessage.contains('Email already exists')) {
          errorMessage = 'Email is already registered';
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registration Error'),
              content: Text(errorMessage),
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
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.darkTheme.primaryColor;

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nama
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                style: TextStyle(color: AppTheme.darkTheme.primaryColor), // Warna teks input
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: TextStyle(color: AppTheme.darkTheme.primaryColor), // Warna label
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(color: AppTheme.darkTheme.primaryColor), // Warna hint
                  prefixIcon: Icon(Icons.person, color: primaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                  ),
                ),
              ),
              _gap(),
              // Username
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                style: TextStyle(color: AppTheme.darkTheme.primaryColor), // Warna teks input
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: AppTheme.darkTheme.primaryColor), // Warna label
                  hintText: 'Enter your username',
                  hintStyle: TextStyle(color: AppTheme.darkTheme.primaryColor), // Warna hint
                  prefixIcon: Icon(Icons.account_circle, color: primaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                  ),
                ),
              ),
              _gap(),
              // Email
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if (!emailValid) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                style: TextStyle(color: AppTheme.darkTheme.primaryColor), // Warna teks input
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppTheme.darkTheme.primaryColor), // Warna label
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: AppTheme.darkTheme.primaryColor), // Warna hint
                  prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                  ),
                ),
              ),
              _gap(),
              // Password
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.black), // Warna teks input
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: primaryColor), // Warna label
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.grey), // Warna hint
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: primaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
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
              // Confirm Password
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
                obscureText: !_isConfirmPasswordVisible,
                style: const TextStyle(color: Colors.black), // Warna teks input
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: primaryColor), // Warna label
                  hintText: 'Confirm your password',
                  hintStyle: TextStyle(color: Colors.grey), // Warna hint
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: primaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              _gap(),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // Warna tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  onPressed: _register,
                ),
              ),
              _gap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("You already have an account? ",
                      style: TextStyle(color: Colors.black)), // Warna teks
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman Register
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()), // Menavigasi ke RegisterPage
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: primaryColor, // Warna teks register
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}