import 'package:chat/firebase_options.dart';
import 'package:chat/screens/chat/chat_home.dart';
import 'package:chat/screens/onboarding.dart';
import 'package:chat/screens/setup.dart';
import 'package:chat/screens/sign_in.dart';
import 'package:chat/services/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'dart:io' show Platform;

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  UserService.initialize();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  _MainAppState();

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (
        ColorScheme? light,
        ColorScheme? dark,
      ) =>
          MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: Platform.isIOS
              ? ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 57, 159, 243),
                  brightness: Brightness.light)
              : light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: Platform.isIOS
              ? ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 57, 159, 243),
                  brightness: Brightness.dark)
              : dark,
          useMaterial3: true,
        ),
        home: const Onboarding(),
      ),
    );
  }
}
