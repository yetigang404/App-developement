import 'package:chat/screens/chat/chat_home.dart';
import 'package:chat/screens/sign_in.dart';
import 'package:chat/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  void _checkUserLoggedIn(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatHomeScreen(),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkUserLoggedIn(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bantr",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.onBackground),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        FadeAnimatedText("Hello!"),
                        FadeAnimatedText("Hola!"),
                        FadeAnimatedText("Hallo!"),
                        FadeAnimatedText("안녕하세요!"),
                        FadeAnimatedText("你好!"),
                        FadeAnimatedText("Привіт"),
                        FadeAnimatedText("Bonjour"),
                        FadeAnimatedText("こんにちは"),
                        FadeAnimatedText("Hallå")
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Get started to find and talk to new people...",
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Container(),
              ),
              Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Sign Up",
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignIn(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Login",
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
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
}
