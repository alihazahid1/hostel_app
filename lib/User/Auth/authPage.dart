import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/User/View/home_screen.dart';
import 'package:hostel_app/splash_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Loading...'),
            );
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
