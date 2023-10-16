import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory/pages/home/home.dart';
import 'package:inventory/pages/signup.dart';
import 'package:inventory/services/user.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _secure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(
                  fontSize: 22,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(
                  fontSize: 22,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_secure ? Icons.security : Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      _secure = !_secure;
                    });
                  },
                ),
              ),
              obscureText: _secure,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Placeholder(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ));
                    },
                    child: const Text(
                      "Sign Up",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 260,
              child: FilledButton(
                onPressed: () async {
                  if (FocusManager.instance.primaryFocus != null) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  }
                  try {
                    await UserService.instance.loginWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    );
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString(),
                        ),
                      ),
                    );
                    return;
                  }
                  await UserService.instance.refresh();
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 3,
            ),
            // const SizedBox(height: 40),
            Expanded(child: Container()),
            SizedBox(
              width: 260,
              child: OutlinedButton(
                onPressed: () => {},
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Sign in with Google",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 260,
              child: OutlinedButton(
                onPressed: () => {},
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Sign in with Facebook",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
