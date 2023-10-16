import 'package:chat/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _email_controller = TextEditingController();
  TextEditingController _verification_controller = TextEditingController();
  bool _secure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: _email_controller,
                onTap: () {
                  _email_controller.text =
                      FirebaseAuth.instance.currentUser!.email.toString();
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
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
                height: 50,
              ),
              SizedBox(
                width: 260,
                child: FilledButton(
                  onPressed: () => {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            " Verification code sent to ${_email_controller.value.text}")))
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Send Verification Code",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: _verification_controller,
                decoration: InputDecoration(
                  labelText: "Verification Code",
                  hintText: " Enter the 6-digit number",
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
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 260,
                child: FilledButton(
                  onPressed: () => {
                    FirebaseAuth.instance.sendPasswordResetEmail(
                        email: FirebaseAuth.instance.currentUser!.email!),
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    ),
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Reset Password",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.left,
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
