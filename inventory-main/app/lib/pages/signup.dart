import 'package:flutter/material.dart';
import 'package:inventory/pages/setup.dart';
import 'package:inventory/pages/util/wait.dart';
import 'package:inventory/services/user.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _secure = true;
  bool _confirmSecure = true;
  bool _isChecked = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
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
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
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
                controller: _confirmPasswordController,
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
                    icon: Icon(
                        _confirmSecure ? Icons.security : Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        _confirmSecure = !_confirmSecure;
                      });
                    },
                  ),
                ),
                obscureText: _confirmSecure,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(),
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
                    if (FocusManager.instance.primaryFocus != null) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    }

                    String email = _emailController.text;
                    String password = _passwordController.text;
                    String confirmPassword = _confirmPasswordController.text;
                    if (password != confirmPassword) {
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

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaitScreen<String>(
                          future: UserService.instance
                              .createAccountWithEmailAndPassword(
                            email,
                            password,
                          ),
                          onSuccess: (String data) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SetupScreen(
                                  uid: data,
                                  email: email,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
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
