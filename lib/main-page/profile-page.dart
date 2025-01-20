import 'package:curiosityclash/theme.dart';
import 'package:flutter/material.dart';
import 'package:curiosityclash/main-page/login-page.dart';
import 'package:curiosityclash/main-page/draft-page.dart';
import 'package:curiosityclash/services/api.dart';
import 'package:curiosityclash/models/UserModel.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Profilepage extends StatefulWidget {
  final String? sessionId;

  const Profilepage({super.key, this.sessionId});

  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late Future<UserModel>? _userFuture;
  String userName = 'Brodi';  // Nama default
  String userLevel = 'Null'; // Level default
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sessionId != null) {
      _userFuture = ApiService().fetchUserById(widget.sessionId!);
      _fetchUserName();
    } else {
      _userFuture = null;
    }
  }

  void _fetchUserName() async {
    try {
      var user = await _userFuture;
      setState(() {
        if (user != null) {
          userName = user.name;
          userLevel = user.level; // Get user level
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _changePassword(String newPassword) async {
    if (newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password must be at least 8 characters long!'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    try {
      var user = await _userFuture;
      if (user != null) {
        var bytes = utf8.encode(newPassword); // data being hashed
        var digest = sha256.convert(bytes);
        user.password = digest.toString(); // Update the password with the hashed value
        await ApiService().updateUser(widget.sessionId!, user); // Pass the session ID and updated UserModel object
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password updated successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  void _changeName(String newName) async {
    try {
      var user = await _userFuture;
      if (user != null) {
        user.name = newName; // Update the name
        await ApiService().updateUser(widget.sessionId!, user); // Pass the session ID and updated UserModel object
        setState(() {
          userName = newName; // Update the name in the state
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Name updated successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error updating name: $e');
    }
  }

  void _showEditProfileDialog() {
    _nameController.text = userName; // Set the current name in the controller
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Name Input
              TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "Enter your new name",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Save the new name
                    _changeName(_nameController.text);
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "Save Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Ensure the background image covers the entire screen
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg2Page.png', // Your background image asset
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/img/avatar-profile.jpg'),
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // Player Level and Experience Progress Bar aligned horizontally
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the items horizontally
                    children: [
                      // Level Display
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.darkTheme.primaryColor,
                              AppTheme.darkTheme.colorScheme.primary,
                              AppTheme.darkTheme.colorScheme.secondary,
                            ], // Gradien hijau
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20), // Bentuk persegi panjang
                          border: Border.all(
                            color: Colors.black, // Warna border kuning
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 6,
                              offset: Offset(2, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Color(0xFFFFd700), // Ikon bintang kuning
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              userLevel, // Level user
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20), // Space between level and progress bar
                      // Experience Progress Bar
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Stack(
                              children: [
                                // Background Bar
                                Container(
                                  height: 20, // Tinggi progress bar
                                  width: 100, // Lebar penuh progress bar
                                  decoration: BoxDecoration(
                                    color: Colors.black, // Warna background
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5), // Warna shadow hitam semi-transparan
                                        blurRadius: 6, // Tingkat blur shadow
                                        offset: Offset(2, 10), // Posisi shadow
                                      ),
                                    ],
                                  ),
                                ),
                                // Foreground Bar
                                Container(
                                  height: 20, // Sama dengan tinggi background bar
                                  width: 100 * 0.75, // 75% dari panjang bar
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF008000), // Warna hijau foreground
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                // Text Percentage (Centered in the bar)
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      '75%', // Persentase
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white, // Warna teks
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 20), // Divider between sections
                // Menu Container with light theme background
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor, // Light theme background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Edit Profile Action
                      ListTile(
                        leading: const Icon(Icons.edit, color: Colors.black),
                        title: const Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: _showEditProfileDialog,
                      ),
                      const DividerLine(), // Custom Divider
                      // Change Password Action
                      ListTile(
                        leading: const Icon(Icons.lock, color: Colors.black),
                        title: const Text(
                          "Change Password",
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          // Tampilkan popup
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                contentPadding: const EdgeInsets.all(16.0),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Change Password",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Password Input
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: true, // Hide the password
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: TextStyle(color: Colors.black),
                                        hintText: "Enter your new password",
                                        hintStyle: TextStyle(color: Colors.black54),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // Save Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Logika menyimpan password
                                          _changePassword(
                                            _passwordController.text, // Use the actual password input
                                          );
                                          Navigator.of(context).pop(); // Tutup dialog
                                        },
                                        child: const Text(
                                          "Save Password",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Cancel Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            side: const BorderSide(color: Colors.black, width: 1),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Tutup dialog
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const DividerLine(), // Custom Divider
                      // Logout Action
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.black),
                        title: const Text("Logout", style: TextStyle(color: Colors.black)),
                        onTap: () {
                          // Navigate to login page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignInPage()), // Replace with your LoginPage widget
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: const BottomNavBar(),
    );
  }
}

// Custom Divider widget to limit the width
class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Limit width by adding padding
      child: const Divider(color: Colors.black),
    );
  }
}