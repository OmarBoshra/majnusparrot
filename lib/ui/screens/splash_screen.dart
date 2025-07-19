import 'package:flutter/material.dart';
import 'package:majnusparrot/constants/strings.dart';
import 'package:majnusparrot/ui/screens/poem_screen.dart'; // Ensure this path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Recommended for better UI density
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return; // Check if the widget is still mounted

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => PoemScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/majnusparrot.jpeg'),
                  fit: BoxFit.cover,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
