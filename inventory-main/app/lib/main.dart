// ignore_for_file: depend_on_referenced_packages

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory/pages/util/auth_guard.dart';
import 'package:inventory/services/user.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:inventory/pages/home/user_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final ImagePickerPlatform imagePickerImplementation =
      ImagePickerPlatform.instance;
  if (imagePickerImplementation is ImagePickerAndroid) {
    imagePickerImplementation.useAndroidPhotoPicker = true;
  }
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key}) {
    UserService.instance;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => UserProvider(),
      child: DynamicColorBuilder(
        builder: (ColorScheme? light, ColorScheme? dark) => MaterialApp(
          theme: ThemeData(
            colorScheme: light ??
                ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.light,
                ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: dark ??
                ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                ),
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: const AuthGuardScreen(),
        ),
      ),
    );
  }
}
