import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart'; // Import AppTheme
import 'main-page/profile-page.dart';
import 'main-page/train-page.dart';
import 'main-page/shop-page.dart';
import 'package:curiosityclash/main-page/login-page.dart'; // Import halaman Login
import 'package:curiosityclash/widgets/bottomNavbar-widget.dart'; // Import BottomNavBar widget
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Widget untuk Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initialization() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
    FlutterNativeSplash.remove();
  }

  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3)); // Durasi splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp()), // Halaman utama setelah splash screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover, // Mengisi layar dengan gambar background
            ),
          ),
          // Logo image
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 200, // Atur ukuran logo sesuai kebutuhan
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false; // Menyimpan status login

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.blueAccent,
        ),
      ),
      darkTheme: AppTheme.darkTheme,
      // Gunakan tema dark
      themeMode: ThemeMode.system,
      // Gunakan sistem (light/dark)
      initialRoute: _isLoggedIn ? '/' : '/login',
      // Halaman login atau halaman utama
      routes: {
        '/login': (context) => const SignInPage(), // Halaman login
        '/': (context) => const BottomNavBar(), // Halaman utama setelah login
        '/shop': (context) => const ShopPage(),
        '/train': (context) => const TrainPage(),
        '/profile': (context) => const Profilepage(),
      },
    );
  }
}
