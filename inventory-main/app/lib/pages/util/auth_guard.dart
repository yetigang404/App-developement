import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory/pages/onboarding.dart';
import 'package:inventory/pages/home/home.dart';
import 'package:inventory/services/user.dart';

class AuthGuardScreen extends StatefulWidget {
  const AuthGuardScreen({super.key});

  @override
  State<AuthGuardScreen> createState() => _AuthGuardScreenState();
}

class _AuthGuardScreenState extends State<AuthGuardScreen> {
  late StreamSubscription _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Onboarding()),
          );
        } else {
          await UserService.instance.refresh();
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
