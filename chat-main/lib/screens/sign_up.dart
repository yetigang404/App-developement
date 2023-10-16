import 'package:chat/screens/chat/chat_home.dart';
import 'package:chat/screens/setup.dart';
import 'package:chat/screens/user_agreement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //state variable here
  bool _secure = true;
  bool _confirm_secure = true;
  bool _isChecked = false;

  TextEditingController _email_controller = TextEditingController();
  TextEditingController _password_controller = TextEditingController();
  TextEditingController _confirm_password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Sign up")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextField(
                controller: _email_controller,
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
              const SizedBox(height: 20),
              TextField(
                controller: _password_controller,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(
                    fontSize: 22,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
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
              const SizedBox(height: 20),
              TextField(
                controller: _confirm_password_controller,
                decoration: InputDecoration(
                  hintText: "Enter the password again",
                  labelText: "Confirm Password",
                  labelStyle: const TextStyle(
                    fontSize: 22,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_confirm_secure
                        ? Icons.security
                        : Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        _confirm_secure = !_confirm_secure;
                      });
                    },
                  ),
                ),
                obscureText: _confirm_secure,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserAgreement(),
                    ),
                  );
                },
                child: Text(
                  "Please read the user agreement before proceed ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = !_isChecked;
                      });
                    },
                  ),
                  const Text("I have read the user agreement",
                      style: TextStyle(fontSize: 16))
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: FilledButton(
                  onPressed: () async {
                    if (_password_controller.text !=
                        _confirm_password_controller.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Passwords do not match!"),
                      ));
                      return;
                    }
                    if (!_isChecked) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("You must agree to the user agreement!"),
                      ));
                      return;
                    }

                    late UserCredential credential;

                    try {
                      credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _email_controller.text,
                        password: _password_controller.text,
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

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetupPage(
                            uid: credential.user!.uid,
                          ),
                        ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
